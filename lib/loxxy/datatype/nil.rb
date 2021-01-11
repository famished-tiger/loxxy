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

      # Check the equality with another object.
      # @param other [Datatype::BuiltinDatatype, NilClass, Object]
      # @return [Datatype::Boolean]
      def ==(other)
        is_nil = other.kind_of?(Nil) || other.kind_of?(NilClass)
        is_nil ? True.instance : False.instance
      end

      # Check the inequality with another object.
      # @param other [Datatype::BuiltinDatatype, NilClass, Object]
      # @return [Datatype::Boolean]
      def !=(other)
        is_nil = other.kind_of?(Nil) || other.kind_of?(NilClass)
        is_nil ? False.instance : True.instance
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
