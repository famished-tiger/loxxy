# frozen_string_literal: true

require 'strscan'
require 'rley'
require_relative '../error'
require_relative '../datatype/all_datatypes'

module Loxxy
  module FrontEnd
    # A scanner (tokenizer) for the Lox language.
    # Reference material:
    #   https://craftinginterpreters.com/the-lox-language.html
    #   Section 4.2.1 Token types
    #   Appendix A1.2 Lexical Grammar
    # Responsibility: break input into a sequence of token objects.
    # The tokenizer should recognize:
    # Identifiers,
    # Number literals including single digit
    # String literals (quote delimited)
    # Delimiters: e.g. parentheses '(',  ')'
    # Separators: e.g. comma
    class Scanner
      PATT_BLOCK_COMMENT_BEGIN = /\/\*/.freeze
      PATT_BLOCK_COMMENT_END = /\*\//.freeze
      PATT_COMPARISON = /[!=><]=?/.freeze
      PATT_IDENTIFIER = /[a-zA-Z_][a-zA-Z_0-9]*/.freeze
      PATT_LINE_COMMENT = /\/\/[^\r\n]*/.freeze
      PATT_NEWLINE = /(?:\r\n)|\r|\n/.freeze
      PATT_NUMBER = /\d+(?:\.\d+)?/.freeze
      PATT_WHITESPACE = /[ \t\f]+/.freeze

      # @return [StringScanner] Low-level input scanner
      attr_reader(:scanner)

      # @return [Integer] The current line number
      attr_reader(:lineno)

      # @return [Integer] Position of last start of line in the input
      attr_reader(:line_start)

      # One or two special character tokens.
      # These are enumerated in section 4.2.1 Token type
      Lexeme2name = {
        '(' => 'LEFT_PAREN',
        ')' => 'RIGHT_PAREN',
        '{' => 'LEFT_BRACE',
        '}' => 'RIGHT_BRACE',
        ',' => 'COMMA',
        '.' => 'DOT',
        '-' =>  'MINUS',
        '+' => 'PLUS',
        ';' => 'SEMICOLON',
        '/' => 'SLASH',
        '*' => 'STAR',
        '!' => 'BANG',
        '!=' => 'BANG_EQUAL',
        '=' => 'EQUAL',
        '==' => 'EQUAL_EQUAL',
        '>' => 'GREATER',
        '>=' => 'GREATER_EQUAL',
        '<' => 'LESS',
        '<=' => 'LESS_EQUAL'
      }.freeze

      # Here are all the implemented Lox keywords
      # These are enumerated in section 4.2.1 Token type
      @@keywords = %w[
        and class else false fun for if nil or
        print return super this true var while
      ].to_h { |x| [x, x] }

      # Single character that have a special meaning when escaped
      # @return [{Char => String}]
      @@escape_chars = {
        ?a => "\a",
        ?b => "\b",
        ?e => "\e",
        ?f => "\f",
        ?n => "\n",
        ?r => "\r",
        ?s => "\s",
        ?t => "\t",
        ?v => "\v"
      }.freeze

      # Constructor. Initialize a tokenizer for Lox input.
      # @param source [String] Lox text to tokenize.
      def initialize(source = nil)
        reset
        input = source || ''
        @scanner = StringScanner.new(input)
      end

      # Reset the tokenizer and make the given text, the current input.
      # @param source [String] Lox text to tokenize.
      def start_with(source)
        reset
        @scanner.string = source
      end

      # Scan the source and return an array of tokens.
      # @return [Array<Rley::Lexical::Token>] | Returns a sequence of tokens
      def tokens
        tok_sequence = []
        until @scanner.eos?
          token = _next_token
          tok_sequence << token unless token.nil?
        end
        tok_sequence << build_token('EOF', nil)

        tok_sequence
      end

      private

      def reset
        @state = :default
        @lineno = 1
        @line_start = 0
      end

      def _next_token
        nesting_level = 0
        token = nil

        # Loop until end of input reached or token found
        until token || scanner.eos?
          if scanner.skip(PATT_NEWLINE)
            next_line_scanned
            next
          end

          case @state
            when :default
              next if scanner.skip(PATT_WHITESPACE) # Skip whitespaces

              curr_ch = scanner.peek(1)

              token = if scanner.skip(PATT_LINE_COMMENT)
                next
              elsif scanner.skip(PATT_BLOCK_COMMENT_BEGIN)
                @state = :in_block_comment
                nesting_level = 1
                next
              elsif '(){},.;+-/*'.include? curr_ch
                # Single delimiter or separator character
                build_token(Lexeme2name[curr_ch], scanner.getch)
              elsif (lexeme = scanner.scan(PATT_COMPARISON))
                # One or two special character tokens
                build_token(Lexeme2name[lexeme], lexeme)
              elsif scanner.scan(/"/) # Start of string detected...
                build_string_token
              elsif (lexeme = scanner.scan(PATT_NUMBER))
                build_token('NUMBER', lexeme)
              elsif (lexeme = scanner.scan(PATT_IDENTIFIER))
                keyw = @@keywords[lexeme]
                tok_type = keyw ? keyw.upcase : 'IDENTIFIER'
                build_token(tok_type, lexeme)
              else # Unknown token
                col = scanner.pos - @line_start + 1
                _erroneous = curr_ch.nil? ? '' : scanner.scan(/./)
                raise ScanError, "Error: [line #{lineno}:#{col}]: Unexpected character."
              end

            when :in_block_comment
              comment_part = scanner.scan_until(/(?:\/\*)|(?:\*\/)|(?:(?:\r\n)|\r|\n)/)
              unterminated_comment unless comment_part

              case scanner.matched
                when PATT_NEWLINE
                  next_line_scanned
                when PATT_BLOCK_COMMENT_END
                  nesting_level -= 1
                  @state = :default if nesting_level.zero?
                when PATT_BLOCK_COMMENT_BEGIN
                  nesting_level += 1
              end
              next
          end # case
        end # until

        unterminated_comment unless nesting_level.zero?
        token
      end

      def build_token(aSymbolName, aLexeme)
        begin
          (value, symb) = convert_to(aLexeme, aSymbolName)
          lex_length = aLexeme ? aLexeme.size : 0
          col = scanner.pos - lex_length - @line_start + 1
          pos = Rley::Lexical::Position.new(@lineno, col)
          if value
            token = Rley::Lexical::Literal.new(value, aLexeme.dup, symb, pos)
          else
            token = Rley::Lexical::Token.new(aLexeme.dup, symb, pos)
          end
        rescue StandardError => e
          puts "Failing with '#{aSymbolName}' and '#{aLexeme}'"
          raise e
        end

        return token
      end

      def convert_to(aLexeme, aSymbolName)
        symb = aSymbolName
        case aSymbolName
          when 'FALSE'
            value = Datatype::False.instance
          when 'NIL'
            value = Datatype::Nil.instance
          when 'NUMBER'
            value = Datatype::Number.new(aLexeme)
          when 'TRUE'
            value = Datatype::True.instance
          else
            value = nil
        end

        return [value, symb]
      end

      # precondition: current position at leading quote
      def build_string_token
        scan_pos = scanner.pos
        line = @lineno
        column_start = scan_pos - @line_start
        literal = +''
        loop do
          substr = scanner.scan(/[^"\\\r\n]*/)
          if scanner.eos?
            pos_start = "line #{line}:#{column_start}"
            raise ScanError, "Error: [#{pos_start}]: Unterminated string."
          else
            literal << substr
            special = scanner.scan(/["\\\r\n]/)
            case special
            when '"' # Terminating quote found
              break
            when "\r"
              next_line
              special << scanner.scan(/./) if scanner.match?(/\n/)
              literal << special
            when "\n"
              next_line
              literal << special
            when '\\'
              ch = scanner.scan(/./)
              next unless ch

              escaped = @@escape_chars[ch]
              if escaped
                literal << escaped
              else
                literal << ch
              end
            end
          end
        end
        pos = Rley::Lexical::Position.new(line, column_start)
        lox_string = Datatype::LXString.new(literal)
        lexeme = scanner.string[scan_pos - 1..scanner.pos - 1]
        Rley::Lexical::Literal.new(lox_string, lexeme, 'STRING', pos)
      end

      def unterminated_comment
        msg = "Unterminated '/* ... */' block comment on line #{lineno}"
        raise ScanError, msg
      end

      def next_line_scanned
        @lineno += 1
        @line_start = scanner.pos
      end
    end # class
  end # module
end # module
# End of file
