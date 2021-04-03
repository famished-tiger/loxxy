# frozen_string_literal: true

require_relative '../datatype/all_datatypes'

module Loxxy
  module BackEnd
    # Runtime representation of a Lox object (instance).
    class LoxInstance
      # @return BackEnd::LoxClass] the class this this object belong
      attr_reader :klass

      attr_reader :stack

      # Create an instance from given class
      # @param aClass [BackEnd::LoxClass] the class this this object belong
      def initialize(aClass, anEngine)
        @klass = aClass
        @stack = anEngine.stack
      end

      def accept(_visitor)
        stack.push self
      end

      # Text representation of a Lox instance
      def to_str
        "#{klass.to_str} instance"
      end
    end # class
  end # module
end # module
