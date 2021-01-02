# frozen_string_literal: true

require_relative 'scanner'
require_relative 'grammar'

module Loxxy
  module FrontEnd
    # A Lox parser that produce concrete parse trees.
    # Concrete parse trees are the default kind of parse tree
    # generated by the Rley library.
    # They consist of two node types only:
    # - NonTerminalNode
    # - TerminalNode
    # A NonTerminalNode has zero or more child nodes (called subnodes)
    # A TerminalNode is leaf node, that is, it has no child node.
    # While concrete parse tree nodes can be generated out of the box,
    # they have the following drawbacks:
    # - Generic node classes that aren't always suited for the needs of
    #     the language being processing.
    # - Concrete parse tree tend to be deeply nested, which may complicate
    #   further processing.
    class RawParser
      # @return [Rley::Engine] A facade object for the Rley parsing library
      attr_reader(:engine)

      def initialize
        # Create a Rley facade object
        @engine = Rley::Engine.new do |cfg|
          cfg.diagnose = true
        end

        # Step 1. Load Lox grammar
        @engine.use_grammar(Loxxy::FrontEnd::Grammar)
      end

      # Parse the given Lox program into a parse tree.
      # @param source [String] Lox program to parse
      # @return [Rley::ParseTree] A parse tree equivalent to the Lox input.
      def parse(source)
        lexer = Scanner.new(source)
        result = engine.parse(lexer.tokens)

        unless result.success?
          # Stop if the parse failed...
          line1 = "Parsing failed\n"
          line2 = "Reason: #{result.failure_reason.message}"
          raise StandardError, line1 + line2
        end

        return engine.convert(result) # engine.to_ptree(result)
      end
    end # class
  end # module
end # module
