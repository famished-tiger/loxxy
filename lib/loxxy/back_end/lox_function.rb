# frozen_string_literal: true

require_relative '../datatype/all_datatypes'

module Loxxy
  module BackEnd
    # rubocop: disable Style/AccessorGrouping
    # Representation of a Lox function.
    class LoxFunction
      # @return [String] The name of the function (if any)
      attr_reader :name

      # @return [Array<>] the parameters
      attr_reader :parameters
      attr_reader :body
      attr_reader :stack
      attr_reader :closure
      attr_accessor :is_initializer

      # Create a function with given name
      # @param aName [String] The name of the function
      def initialize(aName, parameterList, aBody, anEngine)
        @name = aName.dup
        @parameters = parameterList
        @body = aBody.kind_of?(Ast::LoxNoopExpr) ? aBody : aBody.subnodes[0]
        @stack = anEngine.stack
        @closure = anEngine.symbol_table.current_env
        @is_initializer = false
        anEngine.symbol_table.current_env.embedding = true
      end

      def arity
        parameters ? parameters.size : 0
      end

      def accept(_visitor)
        stack.push self
      end

      def call(engine, aVisitor)
        new_env = Environment.new(closure)
        engine.symbol_table.enter_environment(new_env)

        parameters&.each do |param_name|
          local = Variable.new(param_name, stack.pop)
          engine.symbol_table.insert(local)
        end

        catch(:return) do
          (body.nil? || body.kind_of?(Ast::LoxNoopExpr)) ? Datatype::Nil.instance : body.accept(aVisitor)
          throw(:return)
        end
        if is_initializer
          enclosing_env = engine.symbol_table.current_env.enclosing
          engine.stack.push(enclosing_env.defns['this'].value)
        end

        engine.symbol_table.leave_environment
      end

      def bind(anInstance)
        new_env = Environment.new(closure)
        this = Variable.new('this', anInstance)
        new_env.insert(this)
        bound_method = dup
        bound_method.instance_variable_set(:@closure, new_env)

        bound_method
      end

      # Logical negation.
      # As a function is a truthy thing, its negation is thus false.
      # @return [Datatype::False]
      def !
        Datatype::False.instance
      end

      # Text representation of a Lox function
      def to_str
        "<fn #{name}>"
      end
    end # class
    # rubocop: enable Style/AccessorGrouping
  end # module
end # module
