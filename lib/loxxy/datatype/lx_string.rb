# frozen_string_literal: true

require_relative 'builtin_datatype'

module Loxxy
  module Datatype
    # Class for representing a Lox string of characters value.
    class LXString < BuiltinDatatype

      # Build the sole instance
      def initialize(aValue)
        super(aValue)
      end

      # Compare a Lox String with another Lox (or genuine Ruby) String
      # @param other [Datatype::LxString, String]
      # @return [Boolean]
      def ==(other)
        case other
          when LXString
            value == other.value
          when String
            value == other
        else
          raise StandardError, 'Cannot compare a #{self.class} with #{other.class}'
        end
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