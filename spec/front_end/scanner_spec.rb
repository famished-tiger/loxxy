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

      subject(:scanner) { described_class.new }

      context 'Initialization:' do
        it 'could be initialized with a text to tokenize or...' do
          expect { described_class.new(sample_text) }.not_to raise_error
        end

        it 'could be initialized without argument...' do
          expect { described_class.new }.not_to raise_error
        end

        it 'has its scanner initialized' do
          expect(scanner.scanner).to be_a(StringScanner)
        end
      end # context

      context 'Input tokenization:' do
        it 'recognizes single special character token' do
          input = '(){},.-+;*/'
          scanner.start_with(input)
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
          match_expectations(scanner, expectations)
        end

        it 'recognizes one or two special character tokens' do
          input = '! != = == > >= < <='
          scanner.start_with(input)
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
          match_expectations(scanner, expectations)
        end

        it 'recognizes non-datatype keywords' do
          keywords = <<-LOX_END
            and class else fun for if or
            print return super this var while
LOX_END
          scanner.start_with(keywords)
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
          match_expectations(scanner, expectations)
        end

        it 'recognizes a false boolean token' do
          scanner.start_with('false')
          token_false = scanner.tokens[0]
          expect(token_false).to be_a(Rley::Lexical::Literal)
          expect(token_false.terminal).to eq('FALSE')
          expect(token_false.lexeme).to eq('false')
          expect(token_false.value).to be_a(Datatype::False)
          expect(token_false.value.value).to be_falsy
        end

        it 'recognizes a true boolean token' do
          scanner.start_with('true')
          token_true = scanner.tokens[0]
          expect(token_true).to be_a(Rley::Lexical::Literal)
          expect(token_true.terminal).to eq('TRUE')
          expect(token_true.lexeme).to eq('true')
          expect(token_true.value).to be_a(Datatype::True)
          expect(token_true.value.value).to be_truthy
        end

        it 'recognizes number values' do
          input = <<-LOX_END
            123     987654
            0       123.456
          LOX_END

          expectations = [
            ['123', 123],
            ['987654', 987654],
            ['0', 0],
            ['123.456', 123.456]
          ]

          scanner.start_with(input)
          scanner.tokens[0..-2].each_with_index do |tok, i|
            expect(tok).to be_a(Rley::Lexical::Literal)
            expect(tok.terminal).to eq('NUMBER')
            (lexeme, val) = expectations[i]
            expect(tok.lexeme).to eq(lexeme)
            expect(tok.value).to be_a(Datatype::Number)
            expect(tok.value.value).to eq(val)
          end
        end

        it 'recognizes negative number values' do
          input = <<-LOX_END
            -0
            -0.001
          LOX_END

          expectations = [
            ['-', '0'],
            ['-', '0.001']
          ].flatten

          scanner.start_with(input)
          tokens = scanner.tokens
          tokens.pop
          i = 0
          tokens.each_slice(2) do |(sign, lit)|
            expect(sign.terminal).to eq('MINUS')
            expect(sign.lexeme).to eq(expectations[i])
            expect(lit.terminal).to eq('NUMBER')
            expect(lit.lexeme).to eq(expectations[i + 1])
            i += 2
          end
        end

        it 'recognizes leading and trailing dots as distinct tokens' do
          input = '.456 123.'

          scanner.start_with(input)
          tokens = scanner.tokens[0..-2]
          expect(tokens[0]).to be_a(Rley::Lexical::Token)
          expect(tokens[0].terminal).to eq('DOT')
          expect(tokens[1]).to be_a(Rley::Lexical::Literal)
          expect(tokens[1].terminal).to eq('NUMBER')
          expect(tokens[1].value.value).to eq(456)
          expect(tokens[2]).to be_a(Rley::Lexical::Literal)
          expect(tokens[2].terminal).to eq('NUMBER')
          expect(tokens[2].value.value).to eq(123)
          expect(tokens[3]).to be_a(Rley::Lexical::Token)
          expect(tokens[3].terminal).to eq('DOT')
        end

        it 'recognizes string values' do
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

          scanner.start_with(input)
          scanner.tokens[0..-2].each_with_index do |str, i|
            expect(str).to be_a(Rley::Lexical::Literal)
            expect(str.terminal).to eq('STRING')
            val = expectations[i]
            expect(str.value).to be_a(Datatype::LXString)
            expect(str.value.value).to eq(val)
          end
        end

        it 'recognizes escaped quotes' do
          embedded_quotes = %q{"she said: \"Hello\""}
          scanner.start_with(embedded_quotes)
          result = scanner.tokens[0]
          expect(result.value).to eq('she said: "Hello"')
        end

        it 'recognizes escaped backslash' do
          embedded_backslash = '"backslash>\\\\"'
          scanner.start_with(embedded_backslash)
          result = scanner.tokens[0]
          expect(result.value).to eq('backslash>\\')
        end

        # rubocop: disable Style/StringConcatenation
        it 'recognizes newline escape sequence' do
          embedded_newline = '"line1\\nline2"'
          scanner.start_with(embedded_newline)
          result = scanner.tokens[0]
          expect(result.value).to eq('line1' + "\n" + 'line2')
        end
        # rubocop: enable Style/StringConcatenation

        it 'recognizes a nil token' do
          scanner.start_with('nil')
          token_nil = scanner.tokens[0]
          expect(token_nil).to be_a(Rley::Lexical::Literal)
          expect(token_nil.terminal).to eq('NIL')
          expect(token_nil.lexeme).to eq('nil')
          expect(token_nil.value).to be_a(Datatype::Nil)
        end

        it 'differentiates nil from variable spelled same' do
          scanner.start_with('Nil')
          similar = scanner.tokens[0]
          expect(similar.terminal).to eq('IDENTIFIER')
          expect(similar.lexeme).to eq('Nil')
        end
      end # context

      context 'Handling comments:' do
        it 'copes with one line comment only' do
          scanner.start_with('// comment')

          # No token found, except eof marker
          eof_token = scanner.tokens[0]
          expect(eof_token.terminal).to eq('EOF')
        end

        # rubocop: disable Lint/PercentStringArray
        it 'skips end of line comments' do
          input = <<-LOX_END
            // first comment
            print "ok"; // second comment
            // third comment
LOX_END
          scanner.start_with(input)
          expectations = [
            # [token lexeme]
            %w[PRINT print],
            %w[STRING "ok"],
            %w[SEMICOLON ;]
          ]
          match_expectations(scanner, expectations)
        end
        # rubocop: enable Lint/PercentStringArray

        it 'copes with single slash (divide) expression' do
          scanner.start_with('8 / 2')

          expectations = [
            # [token lexeme]
            %w[NUMBER 8],
            %w[SLASH /],
            %w[NUMBER 2]
          ]
          match_expectations(scanner, expectations)
        end

        it 'complains if it finds an unterminated string' do
          scanner.start_with('var a = "Unfinished;')
          err = Loxxy::ScanError
          err_msg = 'Error: [line 1:9]: Unterminated string.'
          expect { scanner.tokens }.to raise_error(err, err_msg)
        end

        it 'complains if it finds an unexpected character' do
          scanner.start_with('var a = ?1?;')
          err = Loxxy::ScanError
          err_msg = 'Error: [line 1:9]: Unexpected character.'
          expect { scanner.tokens }.to raise_error(err, err_msg)
        end
      end # context
    end # describe
  end # module
end # module
