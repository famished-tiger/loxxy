# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxReturnStmt < LoxCompoundExpr
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param anExpression [Ast::LoxNode, NilClass] expression to return
      def initialize(aPosition, anExpression)
        expr = anExpression || Datatype::Nil.instance
        super(aPosition, [expr])
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
