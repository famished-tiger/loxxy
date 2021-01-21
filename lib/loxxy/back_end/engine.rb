# frozen_string_literal: true

# Load all the classes implementing AST nodes
require_relative '../ast/all_lox_nodes'
require_relative 'symbol_table'

module Loxxy
  module BackEnd
    # An instance of this class executes the statements as when they
    # occur during the abstract syntax tree walking.
    # @note WIP: very crude implementation.
    class Engine
      # @return [Hash] A set of configuration options
      attr_reader :config

      # @return [BackEnd::SymbolTable]
      attr_reader :symbol_table

      # @return [Array<Datatype::BuiltinDatatyp>] Stack for the values of expr
      attr_reader :stack

      # @param theOptions [Hash]
      def initialize(theOptions)
        @config = theOptions
        @ostream = config.include?(:ostream) ? config[:ostream] : $stdout
        @symbol_table = SymbolTable.new
        @stack = []
      end

      # Given an abstract syntax parse tree visitor, launch the visit
      # and execute the visit events in the output stream.
      # @param aVisitor [AST::ASTVisitor]
      # @return [Loxxy::Datatype::BuiltinDatatype]
      def execute(aVisitor)
        aVisitor.subscribe(self)
        aVisitor.start
        aVisitor.unsubscribe(self)
        stack.empty? ? Datatype::Nil.instance : stack.pop
      end

      ##########################################################################
      # Visit event handling
      ##########################################################################

      def after_seq_decl(aSeqDecls)
        # Do nothing, subnodes were already evaluated
      end

      def after_var_stmt(aVarStmt)
        new_var = Variable.new(aVarStmt.name, aVarStmt.subnodes[0])
        symbol_table.insert(new_var)
      end

      def after_if_stmt(anIfStmt, aVisitor)
        # Retrieve the result of the condition evaluation
        condition = stack.pop
        if condition.truthy?
          anIfStmt.then_stmt.accept(aVisitor)
        elsif anIfStmt.else_stmt
          anIfStmt.else_stmt.accept(aVisitor)
        end
      end

      def after_print_stmt(_printStmt)
        tos = stack.pop
        @ostream.print tos.to_str
      end

      def after_assign_expr(anAssignExpr)
        var_name = anAssignExpr.name
        variable = symbol_table.lookup(var_name)
        raise StandardError, "Unknown variable #{var_name}" unless variable

        value = stack.pop
        variable.assign(value)
        stack.push value # An expression produces a value
      end

      def after_logical_expr(aLogicalExpr, visitor)
        op = aLogicalExpr.operator
        operand1 = stack.pop # only first operand was evaluated
        result = nil
        if ((op == :and) && operand1.falsey?) || ((op == :or) && operand1.truthy?)
          result = operand1
        else
          raw_operand2 = aLogicalExpr.subnodes[1]
          raw_operand2.accept(visitor) # Visit means operand2 is evaluated
          operand2 = stack.pop
          result = logical_2nd_arg(operand2)
        end

        stack.push result
      end

      def logical_2nd_arg(operand2)
        case operand2
           when false
             False.instance # Convert to Lox equivalent
           when nil
             Nil.instance # Convert to Lox equivalent
           when true
             True.instance # Convert to Lox equivalent
           when Proc
             # Second operand wasn't yet evaluated...
             operand2.call
           else
             operand2
        end
      end

      def after_binary_expr(aBinaryExpr)
        op = aBinaryExpr.operator
        operand2 = stack.pop
        operand1 = stack.pop
        if operand1.respond_to?(op)
          stack.push operand1.send(op, operand2)
        else
          msg1 = "`#{op}': Unimplemented operator for a #{operand1.class}."
          raise StandardError, msg1
        end
      end

      def after_unary_expr(anUnaryExpr)
        op = anUnaryExpr.operator
        operand = stack.pop
        if operand.respond_to?(op)
          stack.push operand.send(op)
        else
          msg1 = "`#{op}': Unimplemented operator for a #{operand1.class}."
          raise StandardError, msg1
        end
      end

      def after_grouping_expr(_groupingExpr)
        # Do nothing: work was already done by visiting /evaluating the subexpression
      end

      def after_variable_expr(aVarExpr, aVisitor)
        var_name = aVarExpr.name
        var = symbol_table.lookup(var_name)
        raise StandardError, "Unknown variable #{var_name}" unless var

        var.value.accept(aVisitor) # Evaluate the variable value
      end

      # @param literalExpr [Ast::LoxLiteralExpr]
      def before_literal_expr(literalExpr)
        stack.push(literalExpr.literal)
      end

      # @param aNonTerminalNode [Ast::BuiltinDattype] the built-in datatype value
      def before_visit_builtin(aValue)
        stack.push(aValue)
      end
    end # class
  end # module
end # module
