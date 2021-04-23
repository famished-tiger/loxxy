# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxPrintStmt < LoxCompoundExpr
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param anExpression [Ast::LoxNode] expression to output
      def initialize(aPosition, anExpression)
        super(aPosition, [anExpression])
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
