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

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_while_stmt(self)
      end

      # Accessor to the condition expression
      # @return [LoxNode]
      def condition
        subnodes[0]
      end
    end # class
  end # module
end # module
