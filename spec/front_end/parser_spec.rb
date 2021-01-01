# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework
require_relative '../../lib/loxxy/front_end/parser' # Load the class under test

module Loxxy
  module FrontEnd
    describe Parser do
      subject { Parser.new }

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
    end # describe
  end # module
end # module