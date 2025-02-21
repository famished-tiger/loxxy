# frozen_string_literal: true

# Load all the classes implementing AST nodes
require_relative '../ast/all_lox_nodes'
require_relative 'binary_operator'
require_relative 'lox_function'
require_relative 'symbol_table'
require_relative 'unary_operator'

module Loxxy
  module BackEnd
    # A class aimed to perform variable resolution when it visits the parse tree.
    # Resolving means retrieve the declaration of a variable/function everywhere it
    # is referenced.
    class Resolver
      # A stack of Hashes of the form String => Boolean
      # @return [Array<Hash{String => Boolean}>]
      attr_reader :scopes

      # A map from a LoxNode involving a variable and the number of enclosing scopes
      # where it is declared.
      # @return [Hash {LoxNode => Integer}]
      attr_reader :locals

      # An indicator that tells we're in the middle of a function declaration
      # @return [Symbol] must be one of: :none, :function
      attr_reader :current_function

      # An indicator that tells we're in the middle of a class declaration
      # @return [Symbol] must be one of: :none, :class
      attr_reader :current_class

      def initialize
        @scopes = []
        @locals = {}
        @current_function = :none
        @current_class = :none
      end

      # Given an abstract syntax parse tree visitor, launch the visit
      # and execute the visit events in the output stream.
      # @param aVisitor [AST::ASTVisitor]
      # @return [Loxxy::Datatype::BuiltinDatatype]
      def analyze(aVisitor)
        begin_scope
        aVisitor.subscribe(self)
        aVisitor.start
        aVisitor.unsubscribe(self)
        end_scope
      end

      # block statement introduces a new scope
      def before_block_stmt(_aBlockStmt)
        begin_scope
      end

      def after_block_stmt(_aBlockStmt)
        end_scope
      end

      # A class declaration adds a new variable to current scope
      def before_class_stmt(aClassStmt)
        declare(aClassStmt.name)
      end

      def after_class_stmt(aClassStmt, aVisitor)
        previous_class = current_class
        @current_class = :class
        define(aClassStmt.name)
        if aClassStmt.superclass
          if aClassStmt.name == aClassStmt.superclass.name
            raise Loxxy::RuntimeError, "'A class can't inherit from itself."
          end

          @current_class = :subclass
          aClassStmt.superclass.accept(aVisitor)
          begin_scope
          define('super')
        end
        begin_scope
        define('this')
        aClassStmt.body.each do |fun_stmt|
          mth_type = fun_stmt.name == 'init' ? :initializer : :method
          resolve_function(fun_stmt, mth_type, aVisitor)
        end
        end_scope
        end_scope if aClassStmt.superclass
        @current_class = previous_class
      end

      def after_if_stmt(anIfStmt, aVisitor)
        anIfStmt.then_stmt.accept(aVisitor)
        anIfStmt.else_stmt&.accept(aVisitor)
      end

      def before_return_stmt(returnStmt)
        if scopes.size < 2
          msg = "Error at 'return': Can't return from top-level code."
          raise Loxxy::RuntimeError, msg
        end

        if current_function == :none
          msg = "Error at 'return': Can't return from outside a function."
          raise Loxxy::RuntimeError, msg
        end

        if current_function == :initializer
          msg = "Error at 'return': Can't return a value from an initializer."
          raise Loxxy::RuntimeError, msg unless returnStmt.subnodes[0].kind_of?(Datatype::Nil)
        end
      end

      def after_while_stmt(aWhileStmt, aVisitor)
        aWhileStmt.body.accept(aVisitor)
        aWhileStmt.condition&.accept(aVisitor)
      end

      # A variable declaration adds a new variable to current scope
      def before_var_stmt(aVarStmt)
        # Oddly enough, Lox allows the re-definition of a variable at top-level scope
        return if scopes.size == 1 && scopes.last[aVarStmt.name]

        declare(aVarStmt.name)
      end

      def after_var_stmt(aVarStmt)
        define(aVarStmt.name)
      end

      # Assignment expressions require their variables resolved
      def after_assign_expr(anAssignExpr, aVisitor)
        resolve_local(anAssignExpr, aVisitor)
      end

      def after_set_expr(aSetExpr, aVisitor)
        aSetExpr.value.accept(aVisitor)
        # Evaluate object part
        aSetExpr.object.accept(aVisitor)
      end

      def after_logical_expr(aLogicalExpr, aVisitor)
        # Force the visit of second operand (resolver should ignore shortcuts)
        aLogicalExpr.operands.last.accept(aVisitor)
      end

      # Variable expressions require their variables resolved
      def before_variable_expr(aVarExpr)
        var_name = aVarExpr.name
        if !scopes.empty? && (scopes.last[var_name] == false)
          raise Loxxy::RuntimeError, "Can't read variable #{var_name} in its own initializer"
        end
      end

      def after_variable_expr(aVarExpr, aVisitor)
        resolve_local(aVarExpr, aVisitor)
      end

      def after_call_expr(aCallExpr, aVisitor)
        # Evaluate callee part
        aCallExpr.callee.accept(aVisitor)
        aCallExpr.arguments.reverse_each { |arg| arg.accept(aVisitor) }
      end

      def after_get_expr(aGetExpr, aVisitor)
        # Evaluate object part
        aGetExpr.object.accept(aVisitor)
      end

      def before_this_expr(_thisExpr)
        if current_class == :none
          msg = "Error at 'this': Can't use 'this' outside of a class."
          raise Loxxy::RuntimeError, msg
        end
      end

      def after_this_expr(aThisExpr, aVisitor)
        # 'this' behaves closely to a local variable
        resolve_local(aThisExpr, aVisitor)
      end

      # rubocop: disable Style/StringConcatenation
      def after_super_expr(aSuperExpr, aVisitor)
        msg_prefix = "Error at 'super': Can't use 'super' "
        if current_class == :none
          err_msg = msg_prefix + 'outside of a class.'
          raise Loxxy::RuntimeError, err_msg

        elsif current_class == :class
          err_msg = msg_prefix + 'in a class without superclass.'
          raise Loxxy::RuntimeError, err_msg

        end
        # 'super' behaves closely to a local variable
        resolve_local(aSuperExpr, aVisitor)
      end
      # rubocop: enable Style/StringConcatenation

      # function declaration creates a new scope for its body & binds its parameters for that scope
      def before_fun_stmt(aFunStmt, aVisitor)
        declare(aFunStmt.name)
        define(aFunStmt.name)
        resolve_function(aFunStmt, :function, aVisitor)
      end

      private

      def begin_scope
        scopes.push({})
      end

      def end_scope
        scopes.pop
      end

      def declare(aVarName)
        return if scopes.empty?

        curr_scope = scopes.last
          # Oddly enough, Lox allows variable re-declaration at top-level
        if curr_scope.include?(aVarName)
          msg = "Error at '#{aVarName}': Already a variable with this name in this scope."
          raise Loxxy::RuntimeError, msg
        elsif curr_scope.size == 255 && current_function != :none
          msg = "Error at '#{aVarName}': Too many local variables in function."
          raise Loxxy::RuntimeError, msg
        end

        # The initializer is not yet processed.
        # Mark the variable as 'not yet ready' = exists but may not be referenced yet
        curr_scope[aVarName] = false
      end

      def define(aVarName)
        return if scopes.empty?

        curr_scope = scopes.last

        # The initializer (if any) was processed.
        # Mark the variable as alive (= can be referenced in an expression)
        curr_scope[aVarName] = true
      end

      def resolve_local(aVarExpr, _visitor)
        max_i = i = scopes.size - 1
        scopes.reverse_each do |scp|
          if scp.include?(aVarExpr.name)
            # Keep track of the difference of nesting levels between current scope
            # and the scope where the variable is declared
            @locals[aVarExpr] = max_i - i
            break
          end
          i -= 1
        end
      end

      def resolve_function(aFunStmt, funVisitState, aVisitor)
        enclosing_function = current_function
        @current_function = funVisitState
        begin_scope

        aFunStmt.params&.each do |param_name|
          declare(param_name)
          define(param_name)
        end

        body = aFunStmt.body
        unless body.nil? || body.kind_of?(Ast::LoxNoopExpr)
          body.subnodes.first&.accept(aVisitor)
        end

        end_scope
        @current_function = enclosing_function
      end
    end # class
  end # mmodule
end # module
