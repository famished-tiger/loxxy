# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxReturnStmt < LoxCompoundExpr
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param anExpression [Ast::LoxNode] expression to return
      def initialize(aPosition, anExpression)
        super(aPosition, [anExpression])
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_return_stmt(self)
      end
    end # class
  end # module
end # module
