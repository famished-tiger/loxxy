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
          expect(aParseTree.root).to be_kind_of(Ast::LoxNoopExpr)
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
          expect(ptree.root).to be_kind_of(Ast::LoxSeqDecl)
          leaf = ptree.root.subnodes[0]
          expect(leaf).to be_kind_of(Ast::LoxLiteralExpr)
          expect(leaf.literal).to be_equal(Datatype::False.instance)
        end

        it 'should parse a true literal' do
          input = 'true;'
          ptree = subject.parse(input)
          expect(ptree.root).to be_kind_of(Ast::LoxSeqDecl)
          leaf = ptree.root.subnodes[0]
          expect(leaf).to be_kind_of(Ast::LoxLiteralExpr)
          expect(leaf.literal).to be_equal(Datatype::True.instance)
        end

        it 'should parse number literals' do
          inputs = %w[1234; 12.34;]
          inputs.each do |source|
            ptree = subject.parse(source)
            leaf = ptree.root.subnodes[0]
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
            leaf = ptree.root.subnodes[0]
            expect(leaf).to be_kind_of(Ast::LoxLiteralExpr)
            expect(leaf.literal).to be_kind_of(Datatype::LXString)
            expect(leaf.literal.value).to eq(source.gsub(/(^")|(";$)/, ''))
          end
        end

        it 'should parse a nil literal' do
          input = 'nil;'
          ptree = subject.parse(input)
          leaf = ptree.root.subnodes[0]
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
          prnt_stmt = ptree.root.subnodes[0]
          expect(prnt_stmt).to be_kind_of(Ast::LoxPrintStmt)
          expect(prnt_stmt.subnodes[0]).to be_kind_of(Ast::LoxLiteralExpr)
          expect(prnt_stmt.subnodes[0].literal).to be_kind_of(Loxxy::Datatype::LXString)
          expect(prnt_stmt.subnodes[0].literal.value).to eq('Hello, world!')
        end
      end # context

      context 'Parsing arithmetic operations' do
        it 'should parse the addition of two number literals' do
          input = '123 + 456;'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:+)
          expect(expr.operands[0].literal.value).to eq(123)
          expect(expr.operands[1].literal.value).to eq(456)
        end

        it 'should parse the subtraction of two number literals' do
          input = '4 - 3;'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:-)
          expect(expr.operands[0].literal.value).to eq(4)
          expect(expr.operands[1].literal.value).to eq(3)
        end

        it 'should parse multiple additive operations' do
          input = '5 + 2 - 3;'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
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
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:/)
          expect(expr.operands[0].literal.value).to eq(8)
          expect(expr.operands[1].literal.value).to eq(2)
        end

        it 'should parse the product of two number literals' do
          input = '12.34 * 0.3;'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:*)
          expect(expr.operands[0].literal.value).to eq(12.34)
          expect(expr.operands[1].literal.value).to eq(0.3)
        end

        it 'should parse multiple multiplicative operations' do
          input = '5 * 2 / 3;'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
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
          expr = ptree.root.subnodes[0]
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
          expr = ptree.root.subnodes[0]
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
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(predicate.to_sym)
          expect(expr.operands[0].literal.value).to eq(3)
          expect(expr.operands[1].literal.value).to eq(2)
        end
      end
      end # context

      context 'Parsing equality expressions' do
        it 'should parse the equality of two number literals' do
          %w[!= ==].each do |predicate|
            input = "3 #{predicate} 2;"
            ptree = subject.parse(input)
            expr = ptree.root.subnodes[0]
            expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
            expect(expr.operator).to eq(predicate.to_sym)
            expect(expr.operands[0].literal.value).to eq(3)
            expect(expr.operands[1].literal.value).to eq(2)
          end
        end

        it 'should parse combination of equality expressions' do
          input = '5 != 2 == false; // A bit contrived example'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operator).to eq(:==)
          expect(expr.operands[0]).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operands[0].operator).to eq(:!=)
          expect(expr.operands[0].operands[0].literal.value).to eq(5)
          expect(expr.operands[0].operands[1].literal.value).to eq(2)
          expect(expr.operands[1].literal.value).to be_falsey
        end
      end # context

      context 'Parsing logical expressions' do
        it 'should parse the logical operations between two sub-expression' do
          %w[or and].each do |connector|
            input = "5 > 2 #{connector} 3 <= 4;"
            ptree = subject.parse(input)
            expr = ptree.root.subnodes[0]
            expect(expr).to be_kind_of(Ast::LoxLogicalExpr)
            expect(expr.operator).to eq(connector.to_sym)
            expect(expr.operands[0]).to be_kind_of(Ast::LoxBinaryExpr)
            expect(expr.operands[0].operator).to eq(:>)
            expect(expr.operands[0].operands[0].literal.value).to eq(5)
            expect(expr.operands[0].operands[1].literal.value).to eq(2)
            expect(expr.operands[1]).to be_kind_of(Ast::LoxBinaryExpr)
            expect(expr.operands[1].operator).to eq(:<=)
            expect(expr.operands[1].operands[0].literal.value).to eq(3)
            expect(expr.operands[1].operands[1].literal.value).to eq(4)
          end
        end

        it 'should parse a combinations of logical expressions' do
          input = '4 > 3 and 1 < 2 or 4 >= 5;'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxLogicalExpr)
          expect(expr.operator).to eq(:or) # or has lower precedence than and
          expect(expr.operands[0]).to be_kind_of(Ast::LoxLogicalExpr)
          expect(expr.operands[0].operator).to eq(:and)
          conjuncts = expr.operands[0].operands
          expect(conjuncts[0]).to be_kind_of(Ast::LoxBinaryExpr)
          expect(conjuncts[0].operator).to eq(:>)
          expect(conjuncts[0].operands[0].literal.value).to eq(4)
          expect(conjuncts[0].operands[1].literal.value).to eq(3)
          expect(conjuncts[1]).to be_kind_of(Ast::LoxBinaryExpr)
          expect(conjuncts[1].operator).to eq(:<)
          expect(conjuncts[1].operands[0].literal.value).to eq(1)
          expect(conjuncts[1].operands[1].literal.value).to eq(2)
          expect(expr.operands[1]).to be_kind_of(Ast::LoxBinaryExpr)
          expect(expr.operands[1].operator).to eq(:>=)
          expect(expr.operands[1].operands[0].literal.value).to eq(4)
          expect(expr.operands[1].operands[1].literal.value).to eq(5)
        end
      end # context

      context 'Object orientation:' do
        it 'should parse object property get access' do
          input = 'print someObject.someProperty;'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxPrintStmt)
          get_expr = expr.subnodes[0]
          expect(get_expr).to be_kind_of(Ast::LoxGetExpr)
          expect(get_expr.object.name).to eq('someObject')
          expect(get_expr.property).to eq('someProperty')
        end

        it 'should parse nested call expressions' do
          input = 'print egg.scramble(3).with(cheddar);'
          # From section 12.3.1, one expects something like:
          # LoxCallExpr
          # +- arguments = ['cheddar']
          # +- callee = LoxGetExpr
          #    +- property = 'with'
          #    +- object = LoxCallExpr
          #       +- arguments = [3]
          #       +- callee = LoxGetExpr
          #          +- property = 'scramble'
          #          +- object = variable 'egg'
          ptree = subject.parse(input)
          print_stmt = ptree.root.subnodes[0]
          expect(print_stmt).to be_kind_of(Ast::LoxPrintStmt)
          outer_call = print_stmt.subnodes[0]
          expect(outer_call).to be_kind_of(Ast::LoxCallExpr)
          expect(outer_call.arguments[0].name).to eq('cheddar')
          expect(outer_call.callee).to be_kind_of(Ast::LoxGetExpr)
          expect(outer_call.callee.property).to eq('with')
          inner_call = outer_call.callee.object
          expect(inner_call).to be_kind_of(Ast::LoxCallExpr)
          expect(inner_call.arguments[0].literal).to eq(3)
          expect(inner_call.callee).to be_kind_of(Ast::LoxGetExpr)
          expect(inner_call.callee.property).to eq('scramble')
          expect(inner_call.callee.object.name).to eq('egg')
        end

        it 'should parse object property set access' do
          input = 'someObject.someProperty = value;'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxSetExpr)
          expect(expr.object.name).to eq('someObject')
          expect(expr.property).to eq('someProperty')
          expect(expr.subnodes[0]).to be_kind_of(Ast::LoxVariableExpr)
          expect(expr.subnodes[0].name).to eq('value')
        end

        it 'should parse complex set access' do
          input = 'breakfast.omelette.filling.meat = ham;'
          # From section 12.3.2, one expects something like:
          # LoxSetExpr
          # +- property = 'meat'
          # +- subnodes[0] = LoxVariableExpr 'ham'
          # +- object = LoxGetExpr
          #    +- property = 'filling'
          #    +- object = LoxGetExpr
          #       +- property = 'omelette'
          #       +- object = LoxVariableExpr 'breakfast'
          ptree = subject.parse(input)
          expr = ptree.root.subnodes[0]
          expect(expr).to be_kind_of(Ast::LoxSetExpr)
          expect(expr.property).to eq('meat')
          expect(expr.subnodes[0]).to be_kind_of(Ast::LoxVariableExpr)
          expect(expr.subnodes[0].name).to eq('ham')
          expect(expr.object).to be_kind_of(Ast::LoxGetExpr)
          expect(expr.object.property).to eq('filling')
          expect(expr.object.object).to be_kind_of(Ast::LoxGetExpr)
          expect(expr.object.object.property).to eq('omelette')
          expect(expr.object.object.object).to be_kind_of(Ast::LoxVariableExpr)
          expect(expr.object.object.object.name).to eq('breakfast')
        end
      end # context
    end # describe
  end # module
end # module
