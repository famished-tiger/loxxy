# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxClassStmt < LoxCompoundExpr
      attr_reader :name

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param condExpr [Loxxy::Ast::LoxNode] iteration condition
      # @param theBody [Loxxy::Ast::LoxNode]
      def initialize(aPosition, aName, theMethods)
        super(aPosition, theMethods)
        @name = aName.dup
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_class_stmt(self)
      end

      alias body subnodes
    end # class
  end # module
end # module
