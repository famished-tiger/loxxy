# frozen_string_literal: true

require_relative 'false'
require_relative 'true'

module Loxxy
  module Datatype
    # Class for representing a Lox numeric value.
    class Number < BuiltinDatatype
      # Perform the addition of two Lox numbers or
      # one Lox number and a Ruby Numeric
      # @param other [Loxxy::Datatype::Number, Numeric]
      # @return [Loxxy::Datatype::Number]
      def +(other)
        case other
        when Number
          self.class.new(value + other.value)
        when Numeric
          self.class.new(value + other)
        else
          err_msg = "`+': #{other.class} can't be coerced into #{self.class} (TypeError)"
          raise TypeError, err_msg
        end
      end

      # Perform the subtraction of two Lox numbers or
      # one Lox number and a Ruby Numeric
      # @param other [Loxxy::Datatype::Number, Numeric]
      # @return [Loxxy::Datatype::Number]
      def -(other)
        case other
        when Number
          self.class.new(value - other.value)
        when Numeric
          self.class.new(value - other)
        else
          err_msg = "`-': #{other.class} can't be coerced into #{self.class} (TypeError)"
          raise TypeError, err_msg
        end
      end

      # Perform the multiplication of two Lox numbers or
      # one Lox number and a Ruby Numeric
      # @param other [Loxxy::Datatype::Number, Numeric]
      # @return [Loxxy::Datatype::Number]
      def *(other)
        case other
        when Number
          self.class.new(value * other.value)
        when Numeric
          self.class.new(value * other)
        else
          err_msg = "'*': Operands must be numbers."
          raise TypeError, err_msg
        end
      end

      # Perform the division of two Lox numbers or
      # one Lox number and a Ruby Numeric
      # @param other [Loxxy::Datatype::Number, Numeric]
      # @return [Loxxy::Datatype::Number]
      def /(other)
        case other
        when Number
          self.class.new(value / other.value)
        when Numeric
          self.class.new(value / other)
        else
          err_msg = "'/': Operands must be numbers."
          raise TypeError, err_msg
        end
      end

      # Check the equality of a Lox number object with another object
      # @param other [Datatype::BuiltinDatatype, Numeric, Object]
      # @return [Datatype::Boolean]
      def ==(other)
        case other
        when Number
          (value == other.value) ? True.instance : False.instance
        when Numeric
          (value == other) ? True.instance : False.instance
        else
          False.instance
        end
      end

      # Check the inequality of a Lox number object with another object
      # @param other [Datatype::BuiltinDatatype, Numeric, Object]
      # @return [Datatype::Boolean]
      def !=(other)
        case other
        when Number
          (value != other.value) ? True.instance : False.instance
        when Numeric
          (value != other) ? True.instance : False.instance
        else
          True.instance
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
