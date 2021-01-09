# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxPrintStmt < LoxCompoundExpr
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param anExpression [Ast::LoxNode] expression to output
      def initialize(aPosition, anExpression)
        super(aPosition, [anExpression])
      end

      # Abstract method.
      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_print_stmt(self)
      end
    end # class
  end # module
end # module
