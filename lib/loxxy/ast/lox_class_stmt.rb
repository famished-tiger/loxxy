# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxClassStmt < LoxCompoundExpr
      # @return [String] the class name
      attr_reader :name

      # @return [Ast::LoxVariableExpr] variable referencing the superclass (if any)
      attr_reader :superclass

      # @return [Array<Ast::LoxFunStmt>] the methods
      attr_reader :body

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param condExpr [Loxxy::Ast::LoxNode] iteration condition
      # @param theBody [Array<Loxxy::Ast::LoxNode>]
      def initialize(aPosition, aName, aSuperclassName, theMethods)
        super(aPosition, [])
        @name = aName.dup
        @superclass = aSuperclassName
        @body = theMethods
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
