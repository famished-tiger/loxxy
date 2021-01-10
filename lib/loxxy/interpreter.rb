# frozen_string_literal: true

require_relative './front_end/parser'
require_relative './ast/ast_visitor'
require_relative './back_end/engine'

module Loxxy
  # A Lox tree-walking interpreter.
  # It acts as a facade object that:
  # - hides the internal plumbings of the front-end and back-end parts.
  # - delegates all the core work to its subordinate objects.
  # @note WIP: very crude implementation.
  class Interpreter
    # return [Hash]
    attr_reader :config

    # @param theOptions [Hash]
    def initialize(theOptions = {})
      @config = theOptions
    end

    # Evaluate the given Lox program.
    # Return the result of the last executed expression (if any)
    # @param lox_input [String] Lox program to evaluate
    # @return [Loxxy::Datatype::BuiltinDatatype]
    def evaluate(lox_input)
      # Front-end scans, parses the input and blurps an AST...
      parser = FrontEnd::Parser.new

      # The AST is the data object passed to the back-end
      ast_tree = parser.parse(lox_input)
      visitor = Ast::ASTVisitor.new(ast_tree)

      # Back-end launches the tree walking & reponds to visit events
      # by executing the code determined by the visited AST node.
      engine = BackEnd::Engine.new(config)
      engine.execute(visitor)
    end
  end # class
end # module
