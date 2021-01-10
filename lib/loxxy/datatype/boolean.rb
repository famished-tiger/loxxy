# frozen_string_literal: true

require_relative 'builtin_datatype'

module Loxxy
  module Datatype
    # Abstract class that generalizes a Lox boolean value.
    # An instance acts merely as a wrapper around a Ruby representation
    # of the value.
    class Boolean < BuiltinDatatype
      # Is this object representing a false value in Lox?
      # @return [FalseClass, TrueClass]
      def false?
        false
      end

      # Is this object representing the true value in Lox?
      # @return [FalseClass, TrueClass]
      def true?
        false
      end
    end # class
  end # module
end # module
