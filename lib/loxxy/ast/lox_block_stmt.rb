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

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
