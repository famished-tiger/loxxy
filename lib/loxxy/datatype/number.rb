# frozen_string_literal: true

require_relative 'false'
require_relative 'true'

module Loxxy
  module Datatype
    # Class for representing a Lox numeric value.
    class Number < BuiltinDatatype
      def zero?
        value.zero?
      end

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
        when Number, Numeric
          if other.zero?
            if zero?
              # NaN case detected
              self.class.new(0.0 / 0.0)
            else
              raise ZeroDivisionError
            end
          elsif other.kind_of?(Number)
            self.class.new(value / other.value)
          else
            self.class.new(value / other)
          end
        else
          err_msg = "'/': Operands must be numbers."
          raise TypeError, err_msg
        end
      end

      # Unary minus (return value with changed sign)
      # @return [Loxxy::Datatype::Number]
      def -@
        self.class.new(-value)
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

      # Check whether this Lox number has a greater value than given argument.
      # @param other [Datatype::Number, Numeric]
      # @return [Datatype::Boolean]
      def >(other)
        case other
        when Number
          (value > other.value) ? True.instance : False.instance
        when Numeric
          (value > other) ? True.instance : False.instance
        else
          msg = "'>': Operands must be numbers."
          raise StandardError, msg
        end
      end

      # Check whether this Lox number has a greater or equal value
      # than given argument.
      # @param other [Datatype::Number, Numeric]
      # @return [Datatype::Boolean]
      def >=(other)
        case other
        when Number
          (value >= other.value) ? True.instance : False.instance
        when Numeric
          (value >= other) ? True.instance : False.instance
        else
          msg = "'>': Operands must be numbers."
          raise StandardError, msg
        end
      end

      # Check whether this Lox number has a lesser value than given argument.
      # @param other [Datatype::Number, Numeric]
      # @return [Datatype::Boolean]
      def <(other)
        !(self >= other)
      end

      # Check whether this Lox number has a lesser or equal value
      # than given argument.
      # @param other [Datatype::Number, Numeric]
      # @return [Datatype::Boolean]
      def <=(other)
        !(self > other)
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
