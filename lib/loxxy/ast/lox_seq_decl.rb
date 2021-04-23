# frozen_string_literal: true

require_relative 'lox_compound_expr'

module Loxxy
  module Ast
    class LoxSeqDecl < LoxCompoundExpr
      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
  end # module
end # module
