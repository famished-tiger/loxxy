# frozen_string_literal: true

require_relative '../error'

module Loxxy
  module BackEnd
    # A Lox unary operator
    class UnaryOperator
      # @return [String] text representation of the operator
      attr_reader :name

      # @return [Array<Class>]
      attr_reader :signatures

      # @param aName [String] "name" of operator
      # @param theSignatures [Array<Class>] allowed signatures
      def initialize(aName, theSignatures)
        @name = aName
        @signatures = theSignatures
      end

      def validate_operand(operand1)
        compliant = signatures.find { |some_type| operand1.kind_of?(some_type) }

        unless compliant
          err = Loxxy::RuntimeError
          # if signatures.size == 1
          raise err, "Operand must be a #{datatype_name(signatures[0].first)}."
          # end
        end
      end

      private

      def datatype_name(aClass)
        # (?:(?:[^:](?!:|(?<=LX))))+$
        aClass.name.sub(/^.+(?=::)::(?:LX)?/, '').downcase
      end
    end # class
  end # module
end # module
