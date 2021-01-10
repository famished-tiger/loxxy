# frozen_string_literal: true

require 'singleton' # Use the Singleton design pattern
require_relative 'boolean'

module Loxxy
  module Datatype
    # Class for representing a Lox true value.
    class True < Boolean
      include Singleton # Make a singleton class

      # Build the sole instance
      def initialize
        super(true)
      end

      # Is this object representing the true value in Lox?
      # @return [TrueClass]
      def true?
        true
      end
    end # class

    True.instance.freeze # Make the sole instance immutable
  end # module
end # module
