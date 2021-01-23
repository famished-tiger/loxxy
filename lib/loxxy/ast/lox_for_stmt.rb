# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxForStmt < LoxCompoundExpr
      # @return [LoxNode] test expression
      attr_reader :test_expr
      
      # @return [LoxNode] update expression
      attr_reader :update_expr      

      # @return [LoxNode] body statement
      attr_accessor :body_stmt

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param initialization [Loxxy::Ast::LoxNode]
      # @param testExpr [Loxxy::Ast::LoxNode]
      # @param updateExpr [Loxxy::Ast::LoxNode]      
      # @param body [Loxxy::Ast::LoxNode]      
      def initialize(aPosition, initalization, testExpr, updateExpr)
        super(aPosition, [initialization])
        @test_expr = testExpr
        @update_expr = updateExpr
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_for_stmt(self)
      end

      # Accessor to the condition expression
      # @return [LoxNode]
      def condition
        subnodes[0]
      end
    end # class
  end # module
end # module
