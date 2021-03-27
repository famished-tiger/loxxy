# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    # rubocop: disable Style/AccessorGrouping
    class LoxFunStmt < LoxCompoundExpr
      attr_reader :name
      attr_reader :params
      attr_reader :body

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aName [String]
      # @param arguments [Array<String>]
      # @param body [Ast::LoxBlockStmt]
      def initialize(aPosition, aName, paramList, aBody)
        super(aPosition, [])
        @name = aName
        @params = paramList
        @body = aBody
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [Ast::ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_fun_stmt(self)
      end
    end # class
    # rubocop: enable Style/AccessorGrouping
  end # module
end # module
