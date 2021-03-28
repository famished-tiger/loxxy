# frozen_string_literal: true

require_relative '../datatype/all_datatypes'

module Loxxy
  module BackEnd
    # rubocop: disable Style/AccessorGrouping
    # Representation of a Lox function.
    # It is a named slot that can be associated with a value at the time.
    class LoxFunction
      # @return [String] The name of the function (if any)
      attr_reader :name

      # @return [Array<>] the parameters
      attr_reader :parameters
      attr_reader :body
      attr_reader :stack
      attr_reader :closure

      # Create a function with given name
      # @param aName [String] The name of the variable
      def initialize(aName, parameterList, aBody, anEngine)
        @name = aName.dup
        @parameters = parameterList
        @body = aBody.kind_of?(Ast::LoxNoopExpr) ? aBody : aBody.subnodes[0]
        @stack = anEngine.stack
        @closure = anEngine.symbol_table.current_env
        anEngine.symbol_table.current_env.embedding = true
      end

      def arity
        parameters ? parameters.size : 0
      end

      def accept(_visitor)
        stack.push self
      end

      def call(engine, aVisitor)
        # new_env = Environment.new(engine.symbol_table.current_env)
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

        engine.symbol_table.leave_environment
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