# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxSetExpr < LoxCompoundExpr
      # @return [Ast::LoxNode] the object to which the property belongs to
      attr_reader :object

      # @return [String] Name of an object property
      attr_accessor :property

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param anObject [Ast::LoxNode] The object which the given property is being set
      def initialize(aPosition, anObject)
        super(aPosition, [])
        @object = anObject
      end

      # Part of the 'visitee' role in Visitor design pattern.
      # @param visitor [ASTVisitor] the visitor
      def accept(visitor)
        visitor.visit_set_expr(self)
      end
    end # class
  end # module
end # module
