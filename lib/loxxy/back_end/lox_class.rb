# frozen_string_literal: true

require_relative '../datatype/all_datatypes'
require_relative 'lox_instance'

module Loxxy
  module BackEnd
    # Runtime representation of a Lox class.
    class LoxClass
      # @return [String] The name of the class
      attr_reader :name

      # @return [Hash{String => LoxFunction}] the list of methods
      attr_reader :meths
      attr_reader :stack

      # Create a class with given name
      # @param aName [String] The name of the class
      def initialize(aName, theMethods, anEngine)
        @name = aName.dup
        @meths = {}
        theMethods.each do |func|
          meths[func.name] = func
        end
        @stack = anEngine.stack
      end

      def accept(_visitor)
        stack.push self
      end

      def arity
        0
      end

      def call(engine, _visitor)
        instance = LoxInstance.new(self, engine)
        engine.stack.push(instance)
      end

      # @param aName [String] the method name to search for
      def find_method(aName)
        meths[aName]
      end

      # Logical negation.
      # As a function is a truthy thing, its negation is thus false.
      # @return [Datatype::False]
      def !
        Datatype::False.instance
      end

      # Text representation of a Lox class
      def to_str
        name
      end
    end # class
  end # module
end # module
