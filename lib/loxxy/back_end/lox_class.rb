# frozen_string_literal: true

require_relative '../datatype/all_datatypes'
require_relative 'lox_instance'

module Loxxy
  module BackEnd
    # Runtime representation of a Lox class.
    class LoxClass
      # @return [String] The name of the class
      attr_reader :name
      attr_reader :superclass

      # @return [Hash{String => LoxFunction}] the list of methods
      attr_reader :meths

      # @return [Loxxy::BackEnd::Engine]
      attr_reader :engine

      # Create a class with given name
      # @param aName [String] The name of the class
      def initialize(aName, aSuperclass, theMethods, anEngine)
        @name = aName.dup
        @superclass = aSuperclass
        @meths = {}
        theMethods.each do |func|
          meths[func.name] = func
        end
        @engine = anEngine
      end

      def accept(_visitor)
        engine.expr_stack.push self
      end

      def arity
        initializer = find_method('init')
        initializer ? initializer.arity : 0
      end

      def call(engine, visitor)
        instance = LoxInstance.new(self, engine)
        initializer = find_method('init')
        if initializer
          constructor = initializer.bind(instance)
          constructor.call(engine, visitor)
        else
          engine.expr_stack.push(instance)
        end
      end

      # @param aName [String] the method name to search for
      def find_method(aName)
        found = meths[aName]
        unless found || superclass.nil?
          found = superclass.find_method(aName)
        end

        found
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
