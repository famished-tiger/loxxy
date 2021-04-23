# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    class LoxSuperExpr < LoxNode
      # @return [Ast::LoxNode] the object to which the property belongs to
      attr_accessor :object

      # @return [String] Name of a method name
      attr_reader :property

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aMethodName [String] Name of a method
      def initialize(aPosition, aMethodName)
        super(aPosition)
        @property = aMethodName
      end

      # Quack like a LoxVariableExpr
      # @return [String] the `super` keyword
      def name
        'super'
      end

      define_accept # Add `accept` method as found in Visitor design pattern
      alias callee= object=
    end # class
  end # module
end # module
