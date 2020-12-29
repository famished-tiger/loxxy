# frozen_string_literal: true

require_relative 'builtin_datatype'

module Loxxy
  module Datatype
    # Abstract class that generalizes a Lox boolean value.
    # An instance acts merely as a wrapper around a Ruby representation
    # of the value.
    class Boolean < BuiltinDatatype
    end # class
  end # module
end # module
