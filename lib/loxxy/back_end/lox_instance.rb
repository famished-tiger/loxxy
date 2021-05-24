# frozen_string_literal: true

require_relative '../datatype/all_datatypes'

module Loxxy
  module BackEnd
    # Runtime representation of a Lox object (instance).
    class LoxInstance
      # @return BackEnd::LoxClass] the class that this object is an instance of
      attr_reader :klass

      attr_reader :engine

      # @return [Hash{String => BuiltinDatatype | LoxFunction | LoxInstance }]
      attr_reader :fields

      # Create an instance from given class
      # @param aClass [BackEnd::LoxClass] the class this this object belong
      def initialize(aClass, anEngine)
        @klass = aClass
        @engine = anEngine
        @fields = {}
      end

      # In Lox, only false and Nil have false value...
      # @return [FalseClass]
      def falsey?
        false # Default implementation
      end

      # Any instance is truthy
      # @return [TrueClass]
      def truthy?
        true # Default implementation
      end

      # Text representation of a Lox instance
      def to_str
        "#{klass.to_str} instance"
      end

      def accept(_visitor)
        engine.expr_stack.push self
      end

      # Look up the value of property with given name
      # aName [String] name of object property
      def get(aName)
        return fields[aName] if fields.include? aName

        method = klass.find_method(aName)
        unless method
          raise Loxxy::RuntimeError, "Undefined property '#{aName}'."
        end

        method.bind(self)
      end

      # Set the value of property with given name
      # aName [String] name of object property
      def set(aName, aValue)
        fields[aName] = aValue
      end
    end # class
  end # module
end # module
