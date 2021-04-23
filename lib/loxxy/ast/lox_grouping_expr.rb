# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxGroupingExpr < LoxCompoundExpr
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param subExpr [Loxxy::Ast::LoxNode]
      def initialize(aPosition, subExpr)
        super(aPosition, [subExpr])
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
