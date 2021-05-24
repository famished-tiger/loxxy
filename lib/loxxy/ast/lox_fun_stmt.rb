# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    # A parse tree node that represents a Lox function declaration.
    class LoxFunStmt < LoxNode
      # @return [String] the function name
      attr_reader :name

      # @return [Array<String>] the parameter names
      attr_reader :params

      # @return [Ast::LoxBlockStmt] the parse tree representing the function's body
      attr_reader :body

      # @return [Boolean] true if the function is a method
      attr_accessor :is_method

      # Constructor for a parse node that represents a Lox function declaration
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aName [String] the function name
      # @param paramList [Array<String>] the parameter names
      # @param aBody [Ast::LoxBlockStmt] the parse tree representing the function's body
      def initialize(aPosition, aName, paramList, aBody)
        super(aPosition)
        @name = aName.dup
        @params = paramList
        @body = aBody
        @is_method = false
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
