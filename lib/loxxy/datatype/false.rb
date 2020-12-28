# frozen_string_literal: true

require 'singleton' # Use the Singleton design pattern
require_relative 'boolean'

module Loxxy
  module Datatype
    # Class for representing a Lox false value.
    class False < Boolean
      include Singleton # Make a singleton class
      
      # Build the sole instance
      def initialize
        super(false)
      end
    end # class
    
    False.instance.freeze  # Make the sole instance immutable
  end # module
end # module
