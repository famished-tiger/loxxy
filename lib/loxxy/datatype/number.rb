# frozen_string_literal: true

require_relative 'false'
require_relative 'true'

module Loxxy
  module Datatype
    # Class for representing a Lox numeric value.
    class Number < BuiltinDatatype
      # Compare a Lox Number with another Lox (or genuine Ruby) Number
      # @param other [Datatype::Number, Numeric]
      # @return [Datatype::Boolean]
      def ==(other)
        case other
        when Number
          (value == other.value) ? True.instance : False.instance
        when Numeric
          (value == other) ? True.instance : False.instance
        else
          err_msg = "Cannot compare a #{self.class} with #{other.class}"
          raise StandardError, err_msg
        end
      end

      # Perform the addition of two Lox numbers or
      # one Lox number and a Ruby Numeric
      # @param numeric [Loxxy::Datatype::Number, Numeric]
      # @return [Loxxy::Datatype::Number]
      def +(numeric)
        case numeric
        when Number
          self.class.new(value + numeric.value)
        when Numeric
          self.class.new(value + numeric)
        else
          err_msg = "`+': #{numeric.class} can't be coerced into #{self.class} (TypeError)"
          raise TypeError, err_msg
        end
      end

      protected

      def validated_value(aValue)
        case aValue
          when Integer, Numeric
            result = aValue
          when /^-?\d+$/
            result = aValue.to_i
          when /^-?\d+\.\d+$/
            result = aValue.to_f
          else
            raise StandardError, "Invalid number value #{aValue}"
        end

        result
      end
    end # class
  end # module
end # module
