# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/front_end/parser'

module Loxxy
  module FrontEnd
    describe Parser do
      subject { Parser.new }

      # Utility method to walk towards deeply nested node
      # @param aNTNode [Rley::PTree::NonTerminalNode]
      # @param subnodePath[Array<Integer>] An Array of subnode indices
      def walk_subnodes(aNTNode, subnodePath)
        curr_node = aNTNode
        subnodePath.each do |index|
          curr_node = curr_node.subnodes[index]
        end

        curr_node
      end

      context 'Initialization:' do
        it 'should be initialized without argument' do
          expect { Parser.new }.not_to raise_error
        end

        it 'should have its parse engine initialized' do
          expect(subject.engine).to be_kind_of(Rley::Engine)
        end
      end # context

      context 'Parsing blank files:' do
        def check_empty_input_result(aParseTree)
          # Parse results MUST to comply to grammar rule:
          #   program => declaration_star EOF
          #   where the declaration_star MUST be empty
          expect(aParseTree.root.symbol.name).to eq('EOF')
        end

        it 'should cope with an empty input' do
          ptree = subject.parse('')
          check_empty_input_result(ptree)
        end

        it 'should cope with whitespaces only input' do
          ptree = subject.parse(' ' * 80 + "\n" * 20)
          check_empty_input_result(ptree)
        end

        it 'should cope with comments only input' do
          input = +''
          %w[First Second Third].each do |ordinal|
            input << "// #{ordinal} comment line\r\n"
          end
          ptree = subject.parse(input)
          check_empty_input_result(ptree)
        end
      end # context

      context 'Parsing literals:' do
        it 'should parse a false literal' do
          input = 'false;'
          ptree = subject.parse(input)
          leaf = walk_subnodes(ptree.root, [0, 0])
          expect(leaf).to be_kind_of(Ast::LoxLiteralExpr)
          expect(leaf.literal).to be_equal(Datatype::False.instance)
        end

        it 'should parse a true literal' do
          input = 'true;'
          ptree = subject.parse(input)
          leaf = walk_subnodes(ptree.root, [0, 0])
          expect(leaf).to be_kind_of(Ast::LoxLiteralExpr)
          expect(leaf.literal).to be_equal(Datatype::True.instance)
        end

        it 'should parse number literals' do
          inputs = %w[1234; 12.34;]
          inputs.each do |source|
            ptree = subject.parse(source)
            leaf = walk_subnodes(ptree.root, [0, 0])
            expect(leaf).to be_kind_of(Ast::LoxLiteralExpr)
            expect(leaf.literal).to be_kind_of(Datatype::Number)
            expect(leaf.literal.value).to eq(source.to_f)
          end
        end

        it 'should parse string literals' do
          inputs = [
            '"I am a string";',
            '"";',
            '"123";'
          ]
          inputs.each do |source|
            ptree = subject.parse(source)
            leaf = walk_subnodes(ptree.root, [0, 0])
            expect(leaf).to be_kind_of(Ast::LoxLiteralExpr)
            expect(leaf.literal).to be_kind_of(Datatype::LXString)
            expect(leaf.literal.value).to eq(source.gsub(/(^")|(";$)/, ''))
          end
        end

        it 'should parse a nil literal' do
          input = 'nil;'
          ptree = subject.parse(input)
          leaf = walk_subnodes(ptree.root, [0, 0])
          expect(leaf).to be_kind_of(Ast::LoxLiteralExpr)
          expect(leaf.literal).to be_equal(Datatype::Nil.instance)
        end
      end

      context 'Parsing expressions:' do
        it 'should parse a hello world program' do
          program = <<-LOX_END
            // Your first Lox program!
            print "Hello, world!";
LOX_END
          ptree = subject.parse(program)
          root = ptree.root
          expect(root.symbol.name).to eq('program')
          (prnt_stmt, eof) = root.subnodes
          expect(prnt_stmt).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(prnt_stmt.symbol.name).to eq('printStmt')
          expect(prnt_stmt.subnodes.size).to eq(3)
          expect(prnt_stmt.subnodes[0]).to be_kind_of(Rley::PTree::TerminalNode)
          expect(prnt_stmt.subnodes[0].symbol.name).to eq('PRINT')
          expect(prnt_stmt.subnodes[1]).to be_kind_of(Loxxy::Ast::LoxLiteralExpr)
          expect(prnt_stmt.subnodes[1].literal).to be_kind_of(Loxxy::Datatype::LXString)
          expect(prnt_stmt.subnodes[1].literal.value).to eq('Hello, world!')
          expect(prnt_stmt.subnodes[2]).to be_kind_of(Rley::PTree::TerminalNode)
          expect(prnt_stmt.subnodes[2].symbol.name).to eq('SEMICOLON')
          expect(eof).to be_kind_of(Rley::PTree::TerminalNode)
          expect(eof.symbol.name).to eq('EOF')
        end
      end # context

      context 'Parsing arithmetic operations' do
        it 'should parse the addition of two number literals' do
          input = '123 + 456;'
          ptree = subject.parse(input)
          parent = ptree.root.subnodes[0]
          expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(parent.symbol.name).to eq('exprStmt')
          expr = parent.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:+)
          expect(expr.operands[0].literal.value).to eq(123)
          expect(expr.operands[1].literal.value).to eq(456)
        end

        it 'should parse the subtraction of two number literals' do
          input = '4 - 3;'
          ptree = subject.parse(input)
          parent = ptree.root.subnodes[0]
          expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(parent.symbol.name).to eq('exprStmt')
          expr = parent.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:-)
          expect(expr.operands[0].literal.value).to eq(4)
          expect(expr.operands[1].literal.value).to eq(3)
        end

        it 'should parse multiple additive operations' do
          input = '5 + 2 - 3;'
          ptree = subject.parse(input)
          parent = ptree.root.subnodes[0]
          expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(parent.symbol.name).to eq('exprStmt')
          expr = parent.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:-)
          expect(expr.operands[0]).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operands[0].operator).to eq(:+)
          expect(expr.operands[0].operands[0].literal.value).to eq(5)
          expect(expr.operands[0].operands[1].literal.value).to eq(2)
          expect(expr.operands[1].literal.value).to eq(3)
        end

        it 'should parse the division of two number literals' do
          input = '8 / 2;'
          ptree = subject.parse(input)
          parent = ptree.root.subnodes[0]
          expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(parent.symbol.name).to eq('exprStmt')
          expr = parent.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:/)
          expect(expr.operands[0].literal.value).to eq(8)
          expect(expr.operands[1].literal.value).to eq(2)
        end

        it 'should parse the product of two number literals' do
          input = '12.34 * 0.3;'
          ptree = subject.parse(input)
          parent = ptree.root.subnodes[0]
          expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(parent.symbol.name).to eq('exprStmt')
          expr = parent.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:*)
          expect(expr.operands[0].literal.value).to eq(12.34)
          expect(expr.operands[1].literal.value).to eq(0.3)
        end

        it 'should parse multiple multiplicative operations' do
          input = '5 * 2 / 3;'
          ptree = subject.parse(input)
          parent = ptree.root.subnodes[0]
          expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(parent.symbol.name).to eq('exprStmt')
          expr = parent.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:/)
          expect(expr.operands[0]).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operands[0].operator).to eq(:*)
          expect(expr.operands[0].operands[0].literal.value).to eq(5)
          expect(expr.operands[0].operands[1].literal.value).to eq(2)
          expect(expr.operands[1].literal.value).to eq(3)
        end

        it 'should parse combination of terms and factors' do
          input = '5 + 2 / 3;'
          ptree = subject.parse(input)
          parent = ptree.root.subnodes[0]
          expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(parent.symbol.name).to eq('exprStmt')
          expr = parent.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:+)
          expect(expr.operands[0].literal.value).to eq(5)
          expect(expr.operands[1]).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operands[1].operator).to eq(:/)
          expect(expr.operands[1].operands[0].literal.value).to eq(2)
          expect(expr.operands[1].operands[1].literal.value).to eq(3)
        end
      end # context

      context 'Parsing string concatenation' do
        it 'should parse the concatenation of two string literals' do
          input = '"Lo" + "ve";'
          ptree = subject.parse(input)
          parent = ptree.root.subnodes[0]
          expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(parent.symbol.name).to eq('exprStmt')
          expr = parent.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:+)
          expect(expr.operands[0].literal.value).to eq('Lo')
          expect(expr.operands[1].literal.value).to eq('ve')
        end
      end # context

      context 'Parsing comparison expressions' do
        it 'should parse the comparison of two number literals' do
          %w[> >= < <=].each do |predicate|
            input = "3 #{predicate} 2;"
            ptree = subject.parse(input)
            parent = ptree.root.subnodes[0]
            expect(parent).to be_kind_of(Rley::PTree::NonTerminalNode)
            expect(parent.symbol.name).to eq('exprStmt')
            expr = parent.subnodes[0]
            expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
            expect(expr.operator).to eq(predicate.to_sym)
            expect(expr.operands[0].literal.value).to eq(3)
            expect(expr.operands[1].literal.value).to eq(2)
          end
        end
      end # context
    end # describe
  end # module
end # module
