# frozen_string_literal: true

require_relative 'entry'
require_relative '../datatype/all_datatypes'

module Loxxy
  module BackEnd
    # Representation of a Lox variable.
    # It is a named slot that can be associated with a value at the time.
    class Variable
      include Entry # Add expected behaviour for symbol table entries
      
      # @return [Datatype::BuiltinDatatype] the value assigned to the variable
      attr_accessor :value

      # Create a variable with given name and initial value
      # @param aName [String] The name of the variable
      # @param aValue [Datatype::BuiltinDatatype] the initial assigned value
      def initialize(aName, aValue = Datatype::Nil.instance)
        init_name(aName)
        @value = aValue
      end
    end # class
  end # module
end # module
