# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxIfStmt < LoxCompoundExpr
      # @return [LoxNode] code of then branch
      attr_reader :then_stmt

      # @return [LoxNode, NilClass] code of else branch
      attr_reader :else_stmt

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param condExpr [Loxxy::Ast::LoxNode]
      # @param thenStmt [Loxxy::Ast::LoxNode]
      # @param elseStmt [Loxxy::Ast::LoxNode]
      def initialize(aPosition, condExpr, thenStmt, elseStmt)
        super(aPosition, [condExpr])
        @then_stmt = thenStmt
        @else_stmt = elseStmt
      end

      # Accessor to the condition expression
      # @return [LoxNode]
      def condition
        subnodes[0]
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
