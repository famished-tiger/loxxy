# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxSetExpr < LoxNode
      # @return [Ast::LoxNode] the object to which the property belongs to
      attr_reader :object

      # @return [String] Name of an object property
      attr_accessor :property

      # @return [LoxNode, Datatype] value to assign
      attr_accessor :value

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param anObject [Ast::LoxNode] The object which the given property is being set
      def initialize(aPosition, anObject)
        super(aPosition)
        @object = anObject
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
