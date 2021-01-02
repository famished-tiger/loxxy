# frozen_string_literal: true

require_relative 'builtin_datatype'

module Loxxy
  module Datatype
    # Class for representing a Lox numeric value.
    class Number < BuiltinDatatype
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
