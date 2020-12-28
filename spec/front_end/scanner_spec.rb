# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/front_end/scanner'

module Loxxy
  module FrontEnd
    describe Scanner do
      # Utility method for comparing actual and expected token
      # sequence. The final EOF is removed from the input sequence.
      def match_expectations(aScanner, theExpectations)
        tokens = aScanner.tokens
        eof_token = tokens.pop
        expect(eof_token.terminal).to eq('EOF')

        tokens.each_with_index do |token, i|
          terminal, lexeme = theExpectations[i]
          expect(token.terminal).to eq(terminal)
          expect(token.lexeme).to eq(lexeme)
        end
      end

      let(:sample_text) { 'print "Hello, world";' }
      subject { Scanner.new }

      context 'Initialization:' do
        it 'could be initialized with a text to tokenize or...' do
          expect { Scanner.new(sample_text) }.not_to raise_error
        end

        it 'could be initialized without argument...' do
          expect { Scanner.new }.not_to raise_error
        end

        it 'should have its scanner initialized' do
          expect(subject.scanner).to be_kind_of(StringScanner)
        end
      end # context

      context 'Single token recognition:' do
        it 'should recognize single special character token' do
          input = '(){},.-+;*/'
          subject.start_with(input)
          expectations = [
            # [token lexeme]
            %w[LEFT_PAREN (],
            %w[RIGHT_PAREN )],
            %w[LEFT_BRACE {],
            %w[RIGHT_BRACE }],
            %w[COMMA ,],
            %w[DOT .],
            %w[MINUS -],
            %w[PLUS +],
            %w[SEMICOLON ;],
            %w[STAR *],
            %w[SLASH /]
          ]
          match_expectations(subject, expectations)
        end

        it 'should recognize one or two special character tokens' do
          input = '! != = == > >= < <='
          subject.start_with(input)
          expectations = [
            # [token lexeme]
            %w[BANG !],
            %w[BANG_EQUAL !=],
            %w[EQUAL =],
            %w[EQUAL_EQUAL ==],
            %w[GREATER >],
            %w[GREATER_EQUAL >=],
            %w[LESS <],
            %w[LESS_EQUAL <=]
          ]
          match_expectations(subject, expectations)
        end

        it 'should recognize non-datatype keywords' do
          keywords =<<-LOX_END
            and class else fun for if or
            print return super this var while
LOX_END
          subject.start_with(keywords)
          expectations = [          
            # [token lexeme]
            %w[AND and],
            %w[CLASS class],
            %w[ELSE else],
            %w[FUN fun],
            %w[FOR for],
            %w[IF if],
            %w[OR or],
            %w[PRINT print],
            %w[RETURN return],
            %w[SUPER super],
            %w[THIS this],
            %w[VAR var],
            %w[WHILE while]
          ]
          match_expectations(subject, expectations)
        end
=begin
        it 'should tokenize integer values' do
          subject.scanner.string = ' 123 '
          token = subject.tokens.first
          expect(token).to be_kind_of(Rley::Lexical::Token)
          expect(token.terminal).to eq('INTEGER')
          expect(token.lexeme).to eq('123')
        end

        it 'should tokenize single digits' do
          subject.scanner.string = ' 1 '
          token = subject.tokens.first
          expect(token).to be_kind_of(Rley::Lexical::Token)
          expect(token.terminal).to eq('DIGIT_LIT')
          expect(token.lexeme).to eq('1')
        end
=end
      end # context


=begin
      context 'String literal tokenization:' do
        it "should recognize 'literally ...'" do
          input = 'literally "hello"'
          subject.scanner.string = input
          expectations = [
            %w[LITERALLY literally],
            %w[STRING_LIT hello]
          ]
          match_expectations(subject, expectations)
        end
      end # context

      context 'Character range tokenization:' do
        it "should recognize 'letter from ... to ...'" do
          input = 'letter a to f'
          subject.scanner.string = input
          expectations = [
            %w[LETTER letter],
            %w[LETTER_LIT a],
            %w[TO to],
            %w[LETTER_LIT f]
          ]
          match_expectations(subject, expectations)
        end

        it "should recognize 'letter from ... to ... followed by comma'" do
          input = 'letter a to f,'
          subject.scanner.string = input
          expectations = [
            %w[LETTER letter],
            %w[LETTER_LIT a],
            %w[TO to],
            %w[LETTER_LIT f],
            %w[COMMA ,]
          ]
          match_expectations(subject, expectations)
        end
      end # context
=end
    end # describe
  end # module
end # module