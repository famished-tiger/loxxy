# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    class LoxGetExpr < LoxNode
      # @return [Ast::LoxNode] the object to which the property belongs to
      attr_accessor :object

      # @return [String] Name of an object property
      attr_reader :property

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aPropertyName [String] Name of an object property
      def initialize(aPosition, aPropertyName)
        super(aPosition)
        @property = aPropertyName
      end

      define_accept # Add `accept` method as found in Visitor design pattern
      alias callee= object=
    end # class
  end # module
end # module
