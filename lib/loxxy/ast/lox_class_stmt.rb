# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    # A parse tree node that represents a Lox class declaration.
    class LoxClassStmt < LoxNode
      # @return [String] the class name
      attr_reader :name

      # @return [Ast::LoxVariableExpr] variable referencing the superclass (if any)
      attr_reader :superclass

      # @return [Array<Ast::LoxFunStmt>] the methods
      attr_reader :body

      # Constructor for a parse node that represents a Lox function declaration
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aName [String] the class name
      # @param aSuperclassName [String] the super class name
      # @param theMethods [Array<Loxxy::Ast::LoxFunStmt>] the methods
      def initialize(aPosition, aName, aSuperclassName, theMethods)
        super(aPosition)
        @name = aName.dup
        @superclass = aSuperclassName
        @body = theMethods
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
