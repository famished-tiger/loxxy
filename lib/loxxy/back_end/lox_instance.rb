# frozen_string_literal: true

require_relative '../datatype/all_datatypes'

module Loxxy
  module BackEnd
    # Runtime representation of a Lox object (instance).
    class LoxInstance
      # @return BackEnd::LoxClass] the class that this object is an instance of
      attr_reader :klass

      attr_reader :stack

      # @return [Hash{String => BuiltinDatatype | LoxFunction | LoxInstance }]
      attr_reader :fields

      # Create an instance from given class
      # @param aClass [BackEnd::LoxClass] the class this this object belong
      def initialize(aClass, anEngine)
        @klass = aClass
        @stack = anEngine.stack
        @fields = {}
      end

      def accept(_visitor)
        stack.push self
      end

      # Text representation of a Lox instance
      def to_str
        "#{klass.to_str} instance"
      end

      # Look up the value of property with given name
      # aName [String] name of object property
      def get(aName)
        return fields[aName] if fields.include? aName

        method = klass.find_method(aName)
        unless method
          raise StandardError, "Undefined property '#{aName}'."
        end

        method
      end

      # Set the value of property with given name
      # aName [String] name of object property
      def set(aName, aValue)
        unless fields.include? aName
          raise StandardError, "Undefined property '#{aName}'."
        end

        fields[aName] = aValue
      end
    end # class
  end # module
end # module
