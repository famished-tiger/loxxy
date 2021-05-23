# frozen_string_literal: true

require_relative 'false'
require_relative 'true'

module Loxxy
  module Datatype
    # Class for representing a Lox string of characters value.
    class LXString < BuiltinDatatype
      # Check the equality of a Lox String with another Lox object.
      # @param other [Datatype::LxString, String, Object]
      # @return [Datatype::Boolean]
      def ==(other)
        case other
        when LXString
          (value == other.value) ? True.instance : False.instance
        when String
          (value == other) ? True.instance : False.instance
        else
          False.instance
        end
      end

      # Perform the concatenation of two Lox stings or
      # one Lox string and a Ruby String
      # @param other [Loxxy::Datatype::LXString, String]
      # @return [Loxxy::Datatype::LXString]
      def +(other)
        case other
        when LXString
          self.class.new(value + other.value)
        when Numeric
          self.class.new(value + other)
        else
          err_msg = "`+': #{other.class} can't be coerced into #{self.class} (TypeError)"
          raise TypeError, err_msg
        end
      end

      # Method called from Lox to obtain the text representation of the object.
      # @return [String]
      def to_str
        value
      end

      protected

      def validated_value(aValue)
        unless aValue.is_a?(String)
          raise StandardError, "Invalid string value #{aValue}"
        end

        aValue
      end
    end # class
  end # module
end # module
