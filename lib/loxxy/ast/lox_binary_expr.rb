# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxBinaryExpr < LoxCompoundExpr
      # @return [Symbol]
      attr_reader :operator

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param operand1 [Loxxy::Ast::LoxNode]
      # @param operand2 [Loxxy::Ast::LoxNode]
      def initialize(aPosition, anOperator, operand1, operand2)
        super(aPosition, [operand1, operand2])
        @operator = anOperator
      end

      alias operands subnodes
    end # class
  end # module
end # module
