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
      # @param subExpr [Loxxy::Ast::LoxNode]
      def initialize(aPosition, condExpr, thenStmt, elseStmt)
        super(aPosition, [condExpr])
        @then_stmt = thenStmt
        @else_stmt = elseStmt
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_if_stmt(self)
      end

      # Accessor to the condition expression
      # @return [LoxNode]
      def condition
        subnodes[0]
      end
    end # class
  end # module
end # module