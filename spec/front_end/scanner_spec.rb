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

      context 'Input tokenization:' do
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
          keywords = <<-LOX_END
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

        it 'should recognize a false boolean token' do
          subject.start_with('false')
          token_false = subject.tokens[0]
          expect(token_false).to be_kind_of(Literal)
          expect(token_false.terminal).to eq('FALSE')
          expect(token_false.lexeme).to eq('false')
          expect(token_false.value).to be_kind_of(Datatype::False)
          expect(token_false.value.value).to be_falsy
        end

        it 'should recognize a true boolean token' do
          subject.start_with('true')
          token_true = subject.tokens[0]
          expect(token_true).to be_kind_of(Literal)
          expect(token_true.terminal).to eq('TRUE')
          expect(token_true.lexeme).to eq('true')
          expect(token_true.value).to be_kind_of(Datatype::True)
          expect(token_true.value.value).to be_truthy
        end

        it 'should recognize number values' do
          input = <<-LOX_END
          123     987654
          0       -0
          123.456 -0.001
LOX_END

          expectations = [
            ['123', 123],
            ['987654', 987654],
            ['0', 0],
            ['-0', 0],
            ['123.456', 123.456],
            ['-0.001', -0.001]
          ]

          subject.start_with(input)
          subject.tokens[0..-2].each_with_index do |tok, i|
            expect(tok).to be_kind_of(Literal)
            expect(tok.terminal).to eq('NUMBER')
            (lexeme, val) = expectations[i]
            expect(tok.lexeme).to eq(lexeme)
            expect(tok.value).to be_kind_of(Datatype::Number)
            expect(tok.value.value).to eq(val)
          end
        end

        it 'should recognize leading and trailing dots as distinct tokens' do
          input = '.456 123.'

          subject.start_with(input)
          tokens = subject.tokens[0..-2]
          expect(tokens[0]).to be_kind_of(Rley::Lexical::Token)
          expect(tokens[0].terminal).to eq('DOT')
          expect(tokens[1]).to be_kind_of(Literal)
          expect(tokens[1].terminal).to eq('NUMBER')
          expect(tokens[1].value.value).to eq(456)
          expect(tokens[2]).to be_kind_of(Literal)
          expect(tokens[2].terminal).to eq('NUMBER')
          expect(tokens[2].value.value).to eq(123)
          expect(tokens[3]).to be_kind_of(Rley::Lexical::Token)
          expect(tokens[3].terminal).to eq('DOT')
        end

        it 'should recognize string values' do
          input = <<-LOX_END
          ""
          "string"
          "123"
LOX_END

          expectations = [
            '',
            'string',
            '123'
          ]

          subject.start_with(input)
          subject.tokens[0..-2].each_with_index do |str, i|
            expect(str).to be_kind_of(Literal)
            expect(str.terminal).to eq('STRING')
            val = expectations[i]
            expect(str.value).to be_kind_of(Datatype::LXString)
            expect(str.value.value).to eq(val)
          end
        end

        it 'should recognize escaped quotes' do
          embedded_quotes = %q{she said: \"Hello\"}
          result = subject.send(:unescape_string, embedded_quotes)
          expect(result).to eq('she said: "Hello"')
        end

        it 'should recognize escaped backslash' do
          embedded_backslash = 'backslash>\\\\'
          result = subject.send(:unescape_string, embedded_backslash)
          expect(result).to eq('backslash>\\')
        end

        # rubocop: disable Style/StringConcatenation
        it 'should recognize newline escape sequence' do
          embedded_newline = 'line1\\nline2'
          result = subject.send(:unescape_string, embedded_newline)
          expect(result).to eq('line1' + "\n" + 'line2')
        end
        # rubocop: enable Style/StringConcatenation

        it 'should recognize a nil token' do
          subject.start_with('nil')
          token_nil = subject.tokens[0]
          expect(token_nil).to be_kind_of(Literal)
          expect(token_nil.terminal).to eq('NIL')
          expect(token_nil.lexeme).to eq('nil')
          expect(token_nil.value).to be_kind_of(Datatype::Nil)
        end
      end # context

      context 'Handling comments:' do
        it 'should cope with one line comment only' do
          subject.start_with('// comment')

          # No token found, except eof marker
          eof_token = subject.tokens[0]
          expect(eof_token.terminal).to eq('EOF')
        end

        # rubocop: disable Lint/PercentStringArray
        it 'should skip end of line comments' do
          input = <<-LOX_END
            // first comment
            print "ok"; // second comment
            // third comment
LOX_END
          subject.start_with(input)
          expectations = [
            # [token lexeme]
            %w[PRINT print],
            %w[STRING "ok"],
            %w[SEMICOLON ;]
          ]
          match_expectations(subject, expectations)
        end
        # rubocop: enable Lint/PercentStringArray

        it 'should cope with single slash (divide) expression' do
          subject.start_with('8 / 2')

          expectations = [
            # [token lexeme]
            %w[NUMBER 8],
            %w[SLASH /],
            %w[NUMBER 2]
          ]
          match_expectations(subject, expectations)
        end

        it 'should complain if it finds an unterminated string' do
          subject.start_with('var a = "Unfinished;')
          err = Loxxy::ScanError
          err_msg = 'Error: [line 1:21]: Unterminated string.'
          expect { subject.tokens }.to raise_error(err, err_msg)
        end

        it 'should complain if it finds an unexpected character' do
          subject.start_with('var a = ?1?;')
          err = Loxxy::ScanError
          err_msg = 'Error: [line 1:9]: Unexpected character.'
          expect { subject.tokens }.to raise_error(err, err_msg)
        end
      end # context
    end # describe
  end # module
end # module
