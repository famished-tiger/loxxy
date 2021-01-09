# frozen_string_literal: true

require 'singleton' # Use the Singleton design pattern
require_relative 'builtin_datatype'

module Loxxy
  module Datatype
    # Class for representing a Lox nil "value".
    class Nil < BuiltinDatatype
      include Singleton # Make a singleton class

      # Build the sole instance
      def initialize
        super(nil)
      end

      # Method called from Lox to obtain the text representation of nil.
      # @return [String]
      def to_str
        'nil'
      end
    end # class

    Nil.instance.freeze # Make the sole instance immutable
  end # module
end # module
