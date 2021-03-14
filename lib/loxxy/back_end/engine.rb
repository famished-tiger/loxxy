# frozen_string_literal: true

# Load all the classes implementing AST nodes
require_relative '../ast/all_lox_nodes'
require_relative 'binary_operator'
require_relative 'lox_function'
require_relative 'symbol_table'
require_relative 'unary_operator'

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

      # @return [Array<Datatype::BuiltinDatatype>] Data stack for the expression results
      attr_reader :stack

     # @return [Hash { Symbol => UnaryOperator}]
      attr_reader :unary_operators

      # @return [Hash { Symbol => BinaryOperator}]
      attr_reader :binary_operators

      # @param theOptions [Hash]
      def initialize(theOptions)
        @config = theOptions
        @ostream = config.include?(:ostream) ? config[:ostream] : $stdout
        @symbol_table = SymbolTable.new
        @stack = []
        @unary_operators = {}
        @binary_operators = {}

        init_unary_operators
        init_binary_operators
        init_globals
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
        new_var = Variable.new(aVarStmt.name, stack.pop)
        symbol_table.insert(new_var)
      end

      def before_for_stmt(aForStmt)
        before_block_stmt(aForStmt)
      end

      def after_for_stmt(aForStmt, aVisitor)
        loop do
          aForStmt.test_expr.accept(aVisitor)
          condition = stack.pop
          break unless condition.truthy?

          aForStmt.body_stmt.accept(aVisitor)
          aForStmt.update_expr&.accept(aVisitor)
          stack.pop
        end
        after_block_stmt(aForStmt)
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
        @ostream.print tos ? tos.to_str : 'nil'
      end

      def after_return_stmt(_returnStmt, _aVisitor)
        throw(:return)
      end

      def after_while_stmt(aWhileStmt, aVisitor)
        loop do
          condition = stack.pop
          break unless condition.truthy?

          aWhileStmt.body.accept(aVisitor)
          aWhileStmt.condition.accept(aVisitor)
        end
      end

      def before_block_stmt(_aBlockStmt)
        new_env = Environment.new
        symbol_table.enter_environment(new_env)
      end

      def after_block_stmt(_aBlockStmt)
        symbol_table.leave_environment
      end

      def after_assign_expr(anAssignExpr)
        var_name = anAssignExpr.name
        variable = symbol_table.lookup(var_name)
        raise StandardError, "Unknown variable #{var_name}" unless variable

        value = stack.last # ToS remains since an assignment produces a value
        variable.assign(value)
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
        operand2 = stack.pop
        operand1 = stack.pop
        op = aBinaryExpr.operator
        operator = binary_operators[op]
        operator.validate_operands(operand1, operand2)
        if operand1.respond_to?(op)
          stack.push operand1.send(op, operand2)
        else
          msg1 = "`#{op}': Unimplemented operator for a #{operand1.class}."
          raise StandardError, msg1
        end
      end

      def after_unary_expr(anUnaryExpr)
        operand = stack.pop
        op = anUnaryExpr.operator
        operator = unary_operators[op]
        operator.validate_operand(operand)
        if operand.respond_to?(op)
          stack.push operand.send(op)
        else
          msg1 = "`#{op}': Unimplemented operator for a #{operand.class}."
          raise StandardError, msg1
        end
      end

      def after_call_expr(aCallExpr, aVisitor)
        # Evaluate callee part
        aCallExpr.callee.accept(aVisitor)
        callee = stack.pop
        aCallExpr.arguments.reverse_each { |arg| arg.accept(aVisitor) }

        case callee
        when NativeFunction
          stack.push callee.call # Pass arguments
        when LoxFunction
          arg_count = aCallExpr.arguments.size
          if arg_count != callee.arity
            msg = "Expected #{callee.arity} arguments but got #{arg_count}."
            raise Loxxy::RuntimeError, msg
          end
          callee.call(self, aVisitor)
        else
          raise Loxxy::RuntimeError, 'Can only call functions and classes.'
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

      # @param aValue [Ast::BuiltinDattype] the built-in datatype value
      def before_visit_builtin(aValue)
        stack.push(aValue)
      end

      def after_fun_stmt(aFunStmt, _visitor)
        function = LoxFunction.new(aFunStmt.name, aFunStmt.params, aFunStmt.body, self)
        new_var = Variable.new(aFunStmt.name, function)
        symbol_table.insert(new_var)
      end

      private

      NativeFunction = Struct.new(:callable, :interp) do
        def accept(_visitor)
          interp.stack.push self
        end

        def call
          callable.call
        end

        def to_str
          '<native fn>'
        end
      end

      def init_unary_operators
        negate_op = UnaryOperator.new('-', [Datatype::Number])
        unary_operators[:-@] = negate_op

        negation_op = UnaryOperator.new('!', [Datatype::BuiltinDatatype,
          BackEnd::LoxFunction])
        unary_operators[:!] = negation_op
      end

      def init_binary_operators
        plus_op = BinaryOperator.new('+', [[Datatype::Number, :idem],
          [Datatype::LXString, :idem]])
        binary_operators[:+] = plus_op

        minus_op = BinaryOperator.new('-', [[Datatype::Number, :idem]])
        binary_operators[:-] = minus_op

        star_op = BinaryOperator.new('*', [[Datatype::Number, :idem]])
        binary_operators[:*] = star_op

        slash_op = BinaryOperator.new('/', [[Datatype::Number, :idem]])
        binary_operators[:/] = slash_op

        equal_equal_op = BinaryOperator.new('==', [[Datatype::BuiltinDatatype, Datatype::BuiltinDatatype]])
        binary_operators[:==] = equal_equal_op

        not_equal_op = BinaryOperator.new('!=', [[Datatype::BuiltinDatatype, Datatype::BuiltinDatatype]])
        binary_operators[:!=] = not_equal_op

        less_op = BinaryOperator.new('<', [[Datatype::Number, :idem]])
        binary_operators[:<] = less_op

        less_equal_op = BinaryOperator.new('<=', [[Datatype::Number, :idem]])
        binary_operators[:<=] = less_equal_op

        greater_op = BinaryOperator.new('>', [[Datatype::Number, :idem]])
        binary_operators[:>] = greater_op

        greater_equal_op = BinaryOperator.new('>=', [[Datatype::Number, :idem]])
        binary_operators[:>=] = greater_equal_op
      end

      def init_globals
        add_native_fun('clock', native_clock)
      end

      def add_native_fun(aName, aProc)
        native_fun = Variable.new(aName, NativeFunction.new(aProc, self))
        symbol_table.insert(native_fun)
      end

      # Ruby-native function that returns (as float) the number of seconds since
      # a given time reference.
      def native_clock
        proc do
          now = Time.now.to_f
          Datatype::Number.new(now)
        end
      end
    end # class
  end # module
end # module
