# frozen_string_literal: true

require_relative '../error'

module Loxxy
  module BackEnd
    Signature = Struct.new(:parameter_types)

    # A Lox binary operator
    class BinaryOperator
      # @return [String] text representation of the operator
      attr_reader :name

      # @return [Array<Class>]
      attr_reader :signatures

      # @param aName [String] "name" of operator
      # @param theSignatures [Array<Signature>] allowed signatures
      def initialize(aName, theSignatures)
        @name = aName
        @signatures = theSignatures
      end

      # rubocop: disable Style/ClassEqualityComparison
      def validate_operands(operand1, operand2)
        compliant = signatures.find do |(type1, type2)|
          next unless operand1.kind_of?(type1)

          if type2 == :idem
            (operand2.class == operand1.class)
          else
            operand2.kind_of?(type2)
          end
        end
        # rubocop: enable Style/ClassEqualityComparison

        unless compliant
          err = Loxxy::RuntimeError
          if signatures.size == 1 && signatures[0].last == :idem
            raise err, "Operands must be #{datatype_name(signatures[0].first)}s."
          elsif signatures.size == 2 && signatures.all? { |(_, second)| second == :idem }
            type1 = datatype_name(signatures[0].first)
            type2 = datatype_name(signatures[1].first)
            raise err, "Operands must be two #{type1}s or two #{type2}s."
          end
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
