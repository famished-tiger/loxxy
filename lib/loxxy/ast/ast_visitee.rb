# frozen_string_literal: true

module Loxxy
  module Ast
    # Mix-in module that relies on meta-programming to add a method
    # called `accept` to the host class (an AST node).
    # That method fulfills the expected behavior of the `visitee` in
    # the Visitor design pattern.
    module ASTVisitee
      # Convert the input string into a snake case string.
      # Example: ClassExpr => class_expr
      # @param aName [String] input name to convert
      # @return [String] the name converted into snake case
      def snake_case(aName)
        converted = +''
        down = false
        aName.each_char do |ch|
          lower = ch.downcase
          if lower == ch
            converted << ch
            down = true
          else
            converted << '_' if down && converted[-1] != '_'
            converted << lower
            down = false
          end
        end

        converted
      end

      # This method adds a method named `accept` that takes a visitor
      # The visitor is expected to implement a method named:
      # visit + class name (without the Lox prefix) in snake case
      # Example: class name = LoxClassStmt => visit method = visit_class_stmt
      def define_accept
        return if instance_methods(false).include?(:accept)

        base_name = name.split('::').last
        name_suffix = snake_case(base_name).sub(/^lox/, '')
        accept_body = <<-MTH_END
          # Part of the 'visitee' role in Visitor design pattern.
          # @param visitor [Ast::ASTVisitor] the visitor
          def accept(aVisitor)
            aVisitor.visit#{name_suffix}(self)
          end
        MTH_END

        class_eval(accept_body)
      end
    end # module
  end # module
end # module
