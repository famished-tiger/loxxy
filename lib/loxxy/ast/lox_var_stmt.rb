# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    # This AST node represents a variable declaration
    class LoxVarStmt < LoxCompoundExpr
      # @return [String] variable name
      attr_reader :name

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aName [String] name of the variable
      # @param aValue [Loxxy::Ast::LoxNode, NilClass] initial value for the variable
      def initialize(aPosition, aName, aValue)
        initial_value = aValue ? [aValue] : []
        super(aPosition, initial_value)
        @name = aName
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_var_stmt(self)
      end
    end # class
  end # module
end # module
