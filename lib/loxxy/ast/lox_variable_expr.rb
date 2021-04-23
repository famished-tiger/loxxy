# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    # This AST node represents a mention of a variable
    class LoxVariableExpr < LoxNode
      # @return [String] variable name
      attr_reader :name

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aName [String] name of the variable
      def initialize(aPosition, aName)
        super(aPosition)
        @name = aName
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
