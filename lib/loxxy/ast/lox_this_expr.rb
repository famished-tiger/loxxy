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

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
