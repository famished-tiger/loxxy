# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxWhileStmt < LoxCompoundExpr
      # @return [LoxNode] body of the while loop (as a statement)
      attr_reader :body

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param condExpr [Loxxy::Ast::LoxNode] iteration condition
      # @param theBody [Loxxy::Ast::LoxNode]
      def initialize(aPosition, condExpr, theBody)
        super(aPosition, [condExpr])
        @body = theBody
      end

      # Accessor to the condition expression
      # @return [LoxNode]
      def condition
        subnodes[0]
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
