# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    class LoxLiteralExpr < LoxNode
      # @return [Loxxy::Datatype::BuiltinDatatype]
      attr_reader :literal

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aLiteral [Loxxy::Datatype::BuiltinDatatype]
      def initialize(aPosition, aLiteral)
        super(aPosition)
        @literal = aLiteral
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_literal_expr(self)
      end
    end # class
  end # module
end # module
