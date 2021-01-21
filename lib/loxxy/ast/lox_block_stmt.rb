# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxBlockStmt < LoxCompoundExpr
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param operand [Loxxy::Ast::LoxSeqDecl]
      def initialize(aPosition, decls)
        super(aPosition, [decls])
        @operator = anOperator
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_block_stmt(self)
      end

      alias operands subnodes
    end # class
  end # module
end # module
