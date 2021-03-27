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

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_grouping_expr(self)
      end
    end # class
  end # module
end # module
