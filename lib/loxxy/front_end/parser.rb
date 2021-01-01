# frozen_string_literal: true

require_relative 'scanner'
require_relative 'grammar'

module Loxxy
  module FrontEnd
    class Parser
      attr_reader(:engine)

      def initialize
        # Create a Rley facade object
        @engine = Rley::Engine.new do |cfg|
          cfg.diagnose = true
          # cfg.repr_builder = SkmBuilder
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