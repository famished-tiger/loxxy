# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/front_end/raw_parser'

module Loxxy
  module FrontEnd
    describe RawParser do
      subject { RawParser.new }

      context 'Initialization:' do
        it 'should be initialized without argument' do
          expect { RawParser.new }.not_to raise_error
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
          expect(aParseTree.root.symbol.name).to eq('program')
          (decls, eof) = aParseTree.root.subnodes
          expect(decls).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(decls.symbol.name).to eq('declaration_star')
          expect(decls.subnodes).to be_empty
          expect(eof).to be_kind_of(Rley::PTree::TerminalNode)
          expect(eof.symbol.name).to eq('EOF')
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

      context 'Parsing expressions:' do
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
        it 'should parse a hello world program' do
          program = <<-LOX_END
            // Your first Lox program!
            print "Hello, world!";
LOX_END
          ptree = subject.parse(program)
          root = ptree.root
          expect(root.symbol.name).to eq('program')
          (decls, eof) = root.subnodes
          expect(decls).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(decls.symbol.name).to eq('declaration_star')
          expect(decls.subnodes[0]).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(decls.subnodes[0].symbol.name).to eq('declaration_star')
          expect(decls.subnodes[1]).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(decls.subnodes[1].symbol.name).to eq('declaration')
          statement = decls.subnodes[1].subnodes[0]
          expect(statement).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(statement.symbol.name).to eq('statement')
          prnt_stmt = statement.subnodes[0]
          expect(prnt_stmt).to be_kind_of(Rley::PTree::NonTerminalNode)
          expect(prnt_stmt.subnodes.size).to eq(3)
          expect(prnt_stmt.subnodes[0]).to be_kind_of(Rley::PTree::TerminalNode)
          expect(prnt_stmt.subnodes[0].symbol.name).to eq('PRINT')
          expect(prnt_stmt.subnodes[1]).to be_kind_of(Rley::PTree::NonTerminalNode)
          leaf_node = walk_subnodes(prnt_stmt, [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
          expect(leaf_node).to be_kind_of(Rley::PTree::TerminalNode)
          expect(leaf_node.symbol.name).to eq('STRING')
          expect(leaf_node.token.value).to eq('Hello, world!')
          expect(prnt_stmt.subnodes[2]).to be_kind_of(Rley::PTree::TerminalNode)
          expect(prnt_stmt.subnodes[2].symbol.name).to eq('SEMICOLON')
          expect(eof).to be_kind_of(Rley::PTree::TerminalNode)
          expect(eof.symbol.name).to eq('EOF')
        end
      end
    end # describe
  end # module
end # module
