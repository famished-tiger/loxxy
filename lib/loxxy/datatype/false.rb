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

      # Is the value considered falsey in Lox?
      # Rule: false and nil are falsey and everything else is truthy.
      # This test used in conditional statements (i.e. if, while)
      def falsey?
        true
      end

      # Is the value considered truthy in Lox?
      # Rule: false and nil are falsey and everything else is truthy.
      # This test used in conditional statements (i.e. if, while)
      def truthy?
        false
      end

      # Check for equality of a Lox False with another Lox object
      # @param other [Datatype::BuiltinDatatype, FalseClass, Object]
      # @return [Datatype::Boolean]
      def ==(other)
        falsey = other.kind_of?(False) || other.kind_of?(FalseClass)
        falsey ? True.instance : False.instance
      end
    end # class

    False.instance.freeze # Make the sole instance immutable
  end # module
end # module
