# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    class LoxNoopExpr < LoxNode
      # Abstract method.
      # Part of the 'visitee' role in Visitor design pattern.
      # @param _visitor [LoxxyTreeVisitor] the visitor
      def accept(_visitor)
        # Do nothing...
      end
    end # class
  end # module
end # module
