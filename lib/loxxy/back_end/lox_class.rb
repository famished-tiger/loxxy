# frozen_string_literal: true

require_relative '../datatype/all_datatypes'

module Loxxy
  module BackEnd
    # Representation of a Lox class.
    class LoxClass
      # @return [String] The name of the class
      attr_reader :name

      # @return [Array<>] the list of methods
      attr_reader :methods
      attr_reader :stack

      # Create a class with given name
      # @param aName [String] The name of the class
      def initialize(aName, theMethods, anEngine)
        @name = aName.dup
        @methods = theMethods
        @stack = anEngine.stack
      end

      def accept(_visitor)
        stack.push self
      end

      # Logical negation.
      # As a function is a truthy thing, its negation is thus false.
      # @return [Datatype::False]
      def !
        Datatype::False.instance
      end

      # Text representation of a Lox function
      def to_str
        name
      end
    end # class
  end # module
end # module
