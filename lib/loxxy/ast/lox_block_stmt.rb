# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxBlockStmt < LoxCompoundExpr
      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param decls [Loxxy::Ast::LoxSeqDecl]
      def initialize(aPosition, decls)
        super(aPosition, [decls])
      end

      def empty?
        subnodes.size == 1 && subnodes[0].nil?
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_block_stmt(self)
      end
    end # class
  end # module
end # module
