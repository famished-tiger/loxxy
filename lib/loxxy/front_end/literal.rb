# frozen_string_literal: true

require 'rley'

module Loxxy
  module FrontEnd
    # The superclass for all tokens that have a data value.
    class Literal < Rley::Lexical::Token
      # @return [Datatype] The value expressed in one of the Lox datatype.
      attr_reader :value

      # Constructor.
      # @param aValue [Datatype::BuiltinDatatype] the Lox data value
      # @param aLexeme [String] the lexeme (= piece of text from input)
      # @param aTerminal [Rley::Syntax::Terminal, String]
      #   The terminal symbol corresponding to the lexeme.
      # @param aPosition [Rley::Lexical::Position] The position of lexeme
      #   in input text.
      def initialize(aValue, aLexeme, aTerminal, aPosition)
        super(aLexeme, aTerminal, aPosition)
        @value = aValue
      end
    end # class
  end # module
end # module
