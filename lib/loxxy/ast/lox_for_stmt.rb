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
      def initialize(aPosition, initialization, testExpr, updateExpr)
        child = initialization ? [initialization] : []
        super(aPosition, child)
        @test_expr = testExpr
        @update_expr = updateExpr
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
