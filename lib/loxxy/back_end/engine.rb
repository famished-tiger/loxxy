# frozen_string_literal: true

# Load all the classes implementing AST nodes
require_relative '../ast/all_lox_nodes'

module Loxxy
  module BackEnd
    # An instance of this class executes the statements as when they
    # occur during the abstract syntax tree walking.
    # @note WIP: very crude implementation.
    class Engine
      # @return [Hash] A set of configuration options
      attr_reader :config

      # @return [Array] Data stack used for passing data between statements
      attr_reader :stack

      # @param theOptions [Hash]
      def initialize(theOptions)
        @config = theOptions
        @ostream = config.include?(:ostream) ? config[:ostream] : $stdout
        @stack = []
      end

      # Given an abstract syntax parse tree visitor, luanch the visit
      # and execute the visit events in the output stream.
      # @param aVisitor [AST::ASTVisitor]
      def execute(aVisitor)
        aVisitor.subscribe(self)
        aVisitor.start
        aVisitor.unsubscribe(self)
        stack.empty? ? Datatype::Nil.instance : stack.pop
      end

      # Visit event handling

      def after_print_stmt(_printStmt)
        tos = stack.pop
        @ostream.print tos.to_str
      end

      # @param literalExpr [Ast::LoxLiteralExpr]
      def before_literal_expr(literalExpr)
        stack.push(literalExpr.literal)
      end
    end # class
  end # module
end # module
