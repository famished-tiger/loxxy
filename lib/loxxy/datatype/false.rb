# frozen_string_literal: true

require 'singleton' # Use the Singleton design pattern
require_relative 'boolean'

module Loxxy
  module Datatype
    # Class for representing a Lox false value.
    class False < Boolean
      include Singleton # Make a singleton class

      # Build the sole instance
      def initialize
        super(false)
      end

      # Is this object representing a false value in Lox?
      # @return [TrueClass]
      def false?
        true
      end

      # Check for equality of a Lox False with another Lox object
      # @param other [Datatype::BuiltinDatatype, FalseClass, Object]
      # @return [Datatype::Boolean]
      def ==(other)
        falsey = other.kind_of?(False) || other.kind_of?(FalseClass)
        falsey ? True.instance : False.instance
      end

      # Check for inequality of a Lox False with another Lox object
      # @param other [Datatype::BuiltinDatatype, FalseClass, Object]
      # @return [Datatype::Boolean]
      def !=(other)
        falsey = other.kind_of?(False) || other.kind_of?(FalseClass)
        falsey ? False.instance : True.instance
      end
    end # class

    False.instance.freeze # Make the sole instance immutable
  end # module
end # module
