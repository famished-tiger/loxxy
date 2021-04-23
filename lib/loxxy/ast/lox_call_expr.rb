# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxCallExpr < LoxCompoundExpr
      attr_accessor :callee
      attr_reader :arguments

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param argList [Array<Loxxy::Ast::LoxNode>]
      def initialize(aPosition, argList)
        super(aPosition, [])
        @arguments = argList
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
