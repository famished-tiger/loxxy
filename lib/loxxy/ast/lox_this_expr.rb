# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    # A node in a parse tree that represents the occurrence of 'this' keyword.
    class LoxThisExpr < LoxNode
      # Duck-typing: behaves like a LoxVarExpr
      # @return [String] return the this keyword
      def name
        'this'
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param _visitor [LoxxyTreeVisitor] the visitor
      def accept(aVisitor)
        aVisitor.visit_this_expr(self)
      end
    end # class
  end # module
end # module
