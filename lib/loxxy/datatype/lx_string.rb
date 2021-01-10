# frozen_string_literal: true

require_relative 'false'
require_relative 'true'

module Loxxy
  module Datatype
    # Class for representing a Lox string of characters value.
    class LXString < BuiltinDatatype
      # Compare a Lox String with another Lox (or genuine Ruby) String
      # @param other [Datatype::LxString, String]
      # @return [Datatype::Boolean]
      def ==(other)
        case other
        when LXString
          (value == other.value) ? True.instance : False.instance
        when String
          (value == other) ? True.instance : False.instance
        else
          err_msg = "Cannot compare a #{self.class} with #{other.class}"
          raise StandardError, err_msg
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
          raise StandardError, "Invalid number value #{aValue}"
        end

        # Remove double quotes delimiter
        aValue.gsub(/(^")|("$)/, '')
      end
    end # class
  end # module
end # module
