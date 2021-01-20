# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    # This AST node represents the assignment of a value to a variable
    class LoxAssignExpr < LoxCompoundExpr
      # @return [String] variable name
      attr_reader :name

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aName [String] name of the variable
      # @param aValue [Loxxy::Ast::LoxNode, NilClass] value to assign
      def initialize(aPosition, aName, aValue)
        super(aPosition, [aValue])
        @name = aName
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_assign_expr(self)
      end
    end # class
  end # module
end # module
