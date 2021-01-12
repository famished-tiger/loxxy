# frozen_string_literal: true

module Loxxy
  module Datatype
    # Abstract class that generalizes a value from a Lox built-in data types.
    # An instance acts merely as a wrapper around a Ruby representation
    # of the value.
    class BuiltinDatatype
      # @return [Object] The Ruby representation
      attr_reader :value

      # Constructor. Initialize a Lox value from one of its built-in data type.
      def initialize(aValue)
        @value = validated_value(aValue)
      end

      # Is the value considered falsey in Lox?
      # Rule: false and nil are falsey and everything else is truthy.
      # This test used in conditional statements (i.e. if, while)
      def falsey?
        false # Default implementation
      end

      # Is the value considered truthy in Lox?
      # Rule: false and nil are falsey and everything else is truthy.
      # This test used in conditional statements (i.e. if, while)
      def truthy?
        true # Default implementation
      end

      # Negation ('not')
      # Returns a boolean with opposite truthiness value.
      # @return [Datatype::Boolean]
      def !
        falsey? ? True.instance : False.instance
      end

      # Check for inequality of this object with another Lox object
      # @param other [Datatype::BuiltinDatatype, Object]
      # @return [Datatype::Boolean]
      def !=(other)
        !(self == other)
      end

      # Method called from Lox to obtain the text representation of the boolean.
      # @return [String]
      def to_str
        value.to_s # Default implementation...
      end

      protected

      def validated_value(aValue)
        aValue
      end
    end # class
  end # module
end # module
