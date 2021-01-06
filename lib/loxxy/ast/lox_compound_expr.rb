# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    class LoxCompoundExpr < LoxNode
      # @return [Array<Ast::LoxNode>]
      attr_reader :subnodes

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param theSubnodes [Array<Ast::LoxNode>]
      def initialize(aPosition, theSubnodes)
        super(aPosition)
        @subnodes = theSubnodes
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_compound_expr(self)
      end
    end # class
  end # module
end # module
