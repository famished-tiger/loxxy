# frozen_string_literal: true

# Load all the classes implementing AST nodes
require_relative '../ast/all_lox_nodes'
require_relative 'binary_operator'
require_relative 'lox_class'
require_relative 'lox_function'
require_relative 'resolver'
require_relative 'symbol_table'
require_relative 'unary_operator'

module Loxxy
  module BackEnd
    # An instance of this class executes the statements as when they
    # occur during the abstract syntax tree walking.
    class Engine
      # @return [Hash] A set of configuration options
      attr_reader :config

      # @return [BackEnd::SymbolTable]
      attr_reader :symbol_table

      # @return [Array<Datatype::BuiltinDatatype>] Data stack for arguments and return results
      attr_reader :stack

     # @return [Hash { Symbol => UnaryOperator}]
      attr_reader :unary_operators

      # @return [Hash { Symbol => BinaryOperator}]
      attr_reader :binary_operators

      # @return [BackEnd::Resolver]
      attr_reader :resolver

      # @param theOptions [Hash]
      def initialize(theOptions)
        @config = theOptions
        @istream = config.include?(:istream) ? config[:istream] : $stdin
        @ostream = config.include?(:ostream) ? config[:ostream] : $stdout
        @symbol_table = SymbolTable.new
        @stack = []

        reset_expr_stack
        init_unary_operators
        init_binary_operators
        init_globals
      end

      # Returns the current environment
      # @return [Loxxy::BackEnd::Environment]
      def current_env
        symbol_table.current_env
      end

      def expr_stack
        current_env.expr_stack
      end

      def reset_expr_stack
        current_env.expr_stack.clear
      end

      # Given an abstract syntax parse tree visitor, launch the visit
      # and execute the visit events in the output stream.
      # @param aVisitor [AST::ASTVisitor]
      # @return [Loxxy::Datatype::BuiltinDatatype]
      def execute(aVisitor)
        # Do variable resolution pass first
        @resolver = BackEnd::Resolver.new
        resolver.analyze(aVisitor)

        aVisitor.subscribe(self)
        aVisitor.start
        aVisitor.unsubscribe(self)
        expr_stack.empty? ? Datatype::Nil.instance : expr_stack.pop
      end

      ##########################################################################
      # Visit event handling
      ##########################################################################

      def after_seq_decl(aSeqDecls)
        # Do nothing, subnodes were already evaluated
      end

      def before_class_stmt(_class_stmt)
        reset_expr_stack
      end

      def after_class_stmt(aClassStmt, aVisitor)
        if aClassStmt.superclass
          aClassStmt.superclass.accept(aVisitor)
          parent = expr_stack.pop
          unless parent.kind_of?(LoxClass)
            raise Loxxy::RuntimeError, 'Superclass must be a class.'
          end
        else
          parent = nil
        end

        if parent # Create an environment specific for 'super'
          super_env = Environment.new(symbol_table.current_env)
          symbol_table.enter_environment(super_env)
        end

        # Convert LoxFunStmt into LoxFunction
        meths = aClassStmt.body.map do |func_node|
          func_node.is_method = true
          func_node.accept(aVisitor)
          mth = expr_stack.pop
          mth.is_initializer = true if mth.name == 'init'
          mth
        end

        klass = LoxClass.new(aClassStmt.name, parent, meths, self)
        if parent
          super_var = Variable.new('super', klass)
          symbol_table.insert(super_var)
          symbol_table.leave_environment
        end
        new_var = Variable.new(aClassStmt.name, klass)
        symbol_table.insert(new_var)
      end

      def before_var_stmt(_var_stmt)
        reset_expr_stack
      end

      def after_var_stmt(aVarStmt)
        new_var = Variable.new(aVarStmt.name, Datatype::Nil.instance)
        symbol_table.insert(new_var)

        value = expr_stack.pop
        new_var.assign(value)
      end

      def before_for_stmt(aForStmt)
        before_block_stmt(aForStmt)
      end

      def before_if_stmt(_if_stmt)
        reset_expr_stack
      end

      def after_if_stmt(anIfStmt, aVisitor)
        # Retrieve the result of the condition evaluation
        # condition = stack.pop
        condition = expr_stack.pop
        if condition.truthy?
          anIfStmt.then_stmt.accept(aVisitor)
        elsif anIfStmt.else_stmt
          anIfStmt.else_stmt.accept(aVisitor)
        end
      end

      def before_print_stmt(_print_stmt)
        reset_expr_stack
      end

      def after_print_stmt(_printStmt)
        tos = expr_stack.pop
        @ostream.print tos ? tos.to_str : 'nil'
      end

      def before_return_stmt(_return_stmt)
        reset_expr_stack
      end

      def after_return_stmt(_returnStmt, _aVisitor)
        stack.push(expr_stack.pop)
        throw(:return)
      end

      def before_while_stmt(_while_stmt)
        reset_expr_stack
      end

      def after_while_stmt(aWhileStmt, aVisitor)
        loop do
          condition = expr_stack.pop
          break unless condition.truthy?

          aWhileStmt.body.accept(aVisitor)
          aWhileStmt.condition&.accept(aVisitor)
        end
      end

      def before_block_stmt(_aBlockStmt)
        reset_expr_stack
        new_env = Environment.new
        symbol_table.enter_environment(new_env)
      end

      def after_block_stmt(_aBlockStmt)
        symbol_table.leave_environment
      end

      def after_assign_expr(anAssignExpr, _visitor)
        var_name = anAssignExpr.name
        variable = variable_lookup(anAssignExpr)
        raise Loxxy::RuntimeError, "Undefined variable '#{var_name}'." unless variable

        value = expr_stack.last # ToS remains since an assignment produces a value
        variable.assign(value)
      end

      def before_set_expr(_set_expr, _visitor)
        reset_expr_stack
      end

      def after_set_expr(aSetExpr, aVisitor)
        # Evaluate receiver object part (i.e. 'this')
        aSetExpr.object.accept(aVisitor)
        assignee = expr_stack.pop
        unless assignee.kind_of?(LoxInstance)
          raise Loxxy::RuntimeError, 'Only instances have fields.'
        end

        aSetExpr.value.accept(aVisitor)
        value = expr_stack.pop

        assignee.set(aSetExpr.property, value)
        expr_stack.push value
      end

      def after_logical_expr(aLogicalExpr, visitor)
        op = aLogicalExpr.operator
        operand1 = expr_stack.pop # only first operand was evaluated
        result = nil
        if ((op == :and) && operand1.falsey?) || ((op == :or) && operand1.truthy?)
          result = operand1
        else
          raw_operand2 = aLogicalExpr.subnodes[1]
          raw_operand2.accept(visitor) # Visit means operand2 is evaluated
          operand2 = expr_stack.pop
          result = logical_2nd_arg(operand2)
        end
        expr_stack.push result
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
        operand2 = expr_stack.pop
        operand1 = expr_stack.pop
        op = aBinaryExpr.operator
        operator = binary_operators[op]
        operator.validate_operands(operand1, operand2)
        if operand1.respond_to?(op)
          result = operand1.send(op, operand2)
          expr_stack.push convert2lox_datatype(result)
        else
          msg1 = "`#{op}': Unimplemented operator for a #{operand1.class}."
          raise StandardError, msg1
        end
      end

      def after_unary_expr(anUnaryExpr)
        operand = expr_stack.pop
        op = anUnaryExpr.operator
        operator = unary_operators[op]
        operator.validate_operand(operand)
        if operand.respond_to?(op)
          result = operand.send(op)
          expr_stack.push convert2lox_datatype(result)
        else
          msg1 = "`#{op}': Unimplemented operator for a #{operand.class}."
          raise StandardError, msg1
        end
      end

      def after_call_expr(aCallExpr, aVisitor)
        # Evaluate callee part
        aCallExpr.callee.accept(aVisitor)
        callee = expr_stack.pop
        before_size = expr_stack.size
        aCallExpr.arguments.reverse_each { |arg| arg.accept(aVisitor) }
        after_size = expr_stack.size
        if after_size > before_size
          stack.concat(expr_stack.pop(after_size - before_size))
        end

        case callee
        when NativeFunction
          expr_stack.push callee.call # Pass arguments
        when LoxFunction, LoxClass
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

      def after_get_expr(aGetExpr, aVisitor)
        aGetExpr.object.accept(aVisitor)
        instance = expr_stack.pop
        unless instance.kind_of?(LoxInstance)
          raise Loxxy::RuntimeError, 'Only instances have properties.'
        end

        expr_stack.push instance.get(aGetExpr.property)
      end

      def after_grouping_expr(_groupingExpr)
        # Do nothing: work was already done by visiting /evaluating the subexpression
      end

      def after_variable_expr(aVarExpr, aVisitor)
        var_name = aVarExpr.name
        var = variable_lookup(aVarExpr)
        raise Loxxy::RuntimeError, "Undefined variable '#{var_name}'." unless var

        var.value.accept(aVisitor) # Evaluate variable value then push on stack
      end

      # @param literalExpr [Ast::LoxLiteralExpr]
      def before_literal_expr(literalExpr)
        expr_stack.push(literalExpr.literal)
      end

      def after_this_expr(aThisExpr, aVisitor)
        var = variable_lookup(aThisExpr)
        var.value.accept(aVisitor) # Evaluate this value then push on stack
      end

      def after_super_expr(aSuperExpr, aVisitor)
        offset = resolver.locals[aSuperExpr]
        env = symbol_table.current_env
        (offset - 1).times { env = env.enclosing }
        instance = env.defns['this'].value.accept(aVisitor)[0]
        superklass = variable_lookup(aSuperExpr).value.superclass
        method = superklass.find_method(aSuperExpr.property)
        unless method
          raise Loxxy::RuntimeError, "Undefined property '#{aSuperExpr.property}'."
        end

        expr_stack.push method.bind(instance)
      end

      # @param aValue [Ast::BuiltinDattype] the built-in datatype value
      def before_visit_builtin(aValue)
        expr_stack.push(aValue)
      end

      def before_fun_stmt(_fun_stmt, _visitor)
        reset_expr_stack
      end

      def after_fun_stmt(aFunStmt, _visitor)
        function = LoxFunction.new(aFunStmt.name, aFunStmt.params, aFunStmt.body, self)
        if aFunStmt.is_method
          expr_stack.push function
        else
          new_var = Variable.new(aFunStmt.name, function)
          symbol_table.insert(new_var)
        end
      end

      private

      def variable_lookup(aVarNode)
        env = nil
        offset = resolver.locals[aVarNode]
        if offset.nil?
          env = symbol_table.root
        else
          env = symbol_table.current_env
          offset.times { env = env.enclosing }
        end

        env.defns[aVarNode.name]
      end

      def init_unary_operators
        @unary_operators = {}

        negate_op = UnaryOperator.new('-', [Datatype::Number])
        unary_operators[:-@] = negate_op

        negation_op = UnaryOperator.new('!', [Datatype::BuiltinDatatype,
          BackEnd::LoxInstance, BackEnd::LoxFunction, BackEnd::LoxClass])
        unary_operators[:!] = negation_op
      end

      def init_binary_operators
        @binary_operators = {}

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
        add_native_fun('getc', native_getc)
        add_native_fun('chr', native_chr)
        add_native_fun('exit', native_exit)
        add_native_fun('print_error', native_print_error)
      end

      NativeFunction = Struct.new(:callable, :interp) do
        def accept(_visitor)
          interp.expr_stack.push self
        end

        def call
          callable.call
        end

        def to_str
          '<native fn>'
        end
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

      # Read a single character and return the character code as an integer.
      def native_getc
        proc do
          ch = @istream.getc
          Datatype::Number.new(ch.codepoints[0])
        end
      end

      # chr(ch): Convert given character code number to a single-character string.
      def native_chr
        proc do
          codepoint = stack.pop
          Datatype::LXString.new(codepoint.value.chr)
        end
      end

      # exit(status): Exit with given status code.
      def native_exit
        proc do
          status = stack.pop
          exit(status.value)
        end
      end

      # print_error(message): Print message string on stderr.
      def native_print_error
        proc do
          message = stack.pop
          $stderr.print message.value
        end
      end

      def convert2lox_datatype(item)
        case item
        when TrueClass then Datatype::True.instance
        when FalseClass then Datatype::False.instance
        else
          item
        end
      end
    end # class
  end # module
end # module
