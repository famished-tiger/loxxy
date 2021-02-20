# frozen_string_literal: true

require_relative '../datatype/all_datatypes'

module Loxxy
  module BackEnd
    # Representation of a Lox function.
    # It is a named slot that can be associated with a value at the time.
    class Function

      # @return [String]
      attr_reader :name

      # @return [Array<>] the parameters
      attr_reader :parameters
      
      attr_reader :body

      attr_reader :stack

      # Create a variable with given name and initial value
      # @param aName [String] The name of the variable
      # @param aValue [Datatype::BuiltinDatatype] the initial assigned value
      def initialize(aName, parameterList, aBody, aStack)
        @name = aName.dup
        @parameters = parameterList
        @body = aBody
        @stack = aStack
      end

      def accept(_visitor)
        stack.push self
      end

      def call(aVisitor)
        body.empty? ? Datatype::Nil.instance : body.accept(aVisitor)
      end

      # Text representation of a Lox function
      def to_str
        "<fn #{name}>"
      end
    end # class
  end # module
end # module
