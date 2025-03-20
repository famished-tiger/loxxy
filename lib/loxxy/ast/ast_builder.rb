# frozen_string_literal: true

require_relative '../datatype/all_datatypes'
require_relative 'all_lox_nodes'
require_relative 'lox_binary_expr'

module Loxxy
  module Ast
    # The purpose of ASTBuilder is to build piece by piece an AST
    # (Abstract Syntax Tree) from a sequence of input tokens and
    # visit events produced by walking over a GFGParsing object.
    class ASTBuilder < Rley::ParseRep::ASTBaseBuilder
      unless defined?(Name2special)
        # Mapping Token name => operator | separator | delimiter characters
        # @return [Hash{String => String}]
        Name2special = {
          'AND' => 'and',
          'BANG_EQUAL' => '!=',
          'COMMA' =>  ',',
          'DOT' => '.',
          'EQUAL' => '=',
          'EQUAL_EQUAL' => '==',
          'GREATER' => '>',
          'GREATER_EQUAL' => '>=',
          'LEFT_BRACE' =>  '{',
          'LEFT_PAREN' => '(',
          'LESS' => '<',
          'LESS_EQUAL' => '<=',
          'MINUS' => '-',
          'OR' => 'or',
          'PLUS' => '+',
          'RIGHT_BRACE' => '}',
          'RIGHT_PAREN' => ')',
          'SEMICOLON' => ';',
          'SLASH' =>  '/',
          'STAR' => '*'
        }.freeze

        Name2unary = {
          'BANG' => '!',
          'MINUS' => '-@'
        }.freeze
      end # defined

      attr_reader :strict

      # Create a new AST builder instance.
      # @param theTokens [Array<Rley::Lexical::Token>] The sequence of input tokens.
      def initialize(theTokens)
        super
        @strict = false
      end

      protected

      def terminal2node
        Terminal2NodeClass
      end

      # Method override
      def new_leaf_node(_production, _terminal, aTokenPosition, aToken)
        Rley::PTree::TerminalNode.new(aToken, aTokenPosition)
      end

      # Factory method for creating a parent node object.
      # @param aProduction [Production] Production rule
      # @param aRange [Range] Range of tokens matched by the rule
      # @param theTokens [Array] The input tokens
      # @param theChildren [Array] Children nodes (one per rhs symbol)
      def new_parent_node(aProduction, aRange, theTokens, theChildren)
        mth_name = method_name(aProduction.name)
        if respond_to?(mth_name, true)
          node = send(mth_name, aProduction, aRange, theTokens, theChildren)
        else
          # Default action...
          node = case aProduction.rhs.size
                 when 0
                   return_epsilon(aRange, theTokens, theChildren)
                 when 1
                   return_first_child(aRange, theTokens, theChildren)
                 else
                   if strict
                     msg = "Don't know production '#{aProduction.name}'"
                     raise StandardError, msg
                   else
                     node = Rley::PTree::NonTerminalNode.new(aProduction.lhs, aRange)
                     theChildren&.reverse_each do |child|
                       node.add_subnode(child) if child
                     end

                     node
                   end
                 end
        end

        node
      end

      def reduce_logical_expr(_production, _range, tokens, theChildren)
        operand1 = theChildren[0]

        # Second child is array with couples [operator, operand2]
        theChildren[1].each do |(operator, operand2)|
          operand1 = LoxLogicalExpr.new(tokens[0].position, operator, operand1, operand2)
        end

        operand1
      end

      # rule('lhs' => 'nonterm_i nonterm_k_plus')
      def reduce_binary_operator(_production, _range, tokens, theChildren)
        operand1 = theChildren[0]

        # Second child is array with couples [operator, operand2]
        theChildren[1].each do |(operator, operand2)|
          operand1 = LoxBinaryExpr.new(tokens[0].position, operator, operand1, operand2)
        end

        operand1
      end

      # rule('something_plus' => 'something_plus operator symbol')
      def reduce_binary_plus_more(_production, _range, _tokens, theChildren)
        result = theChildren[0]
        operator = Name2special[theChildren[1].symbol.name].to_sym
        operand2 = theChildren[2]
        result << [operator, operand2]
      end

      # rule('something_plus' => 'something_plus symbol')
      def reduce_binary_plus_end(_production, _range, _tokens, theChildren)
        operator = Name2special[theChildren[0].symbol.name].to_sym
        operand2 = theChildren[1]
        [[operator, operand2]]
      end

      # Return the AST node corresponding to the second symbol in the rhs
      def reduce_keep_symbol2(_production, _range, _tokens, theChildren)
        theChildren[1]
      end

      #####################################
      #  SEMANTIC ACTIONS
      #####################################

      # rule('program' => 'declaration+ EOF').as ''
      def reduce_lox_program(_production, _range, tokens, theChildren)
        if theChildren[0].empty?
          Ast::LoxNoopExpr.new(tokens[0].position)
        else
          LoxSeqDecl.new(tokens[0].position, theChildren[0])
        end
      end

      # rule('classDecl' => 'CLASS classNaming class_body')
      def reduce_class_decl(_production, _range, _tokens, theChildren)
        name = theChildren[1].first
        parent = theChildren[1].last
        Ast::LoxClassStmt.new(tokens[1].position, name, parent, theChildren[2])
      end

      # rule('classNaming' => 'IDENTIFIER (LESS IDENTIFIER)?')
      def reduce_class_naming(_production, _range, _tokens, theChildren)
        if theChildren[1].nil?
          super_var = nil
        else
          super_token = theChildren[1].last.token
          super_var = LoxVariableExpr.new(super_token.position, super_token.lexeme)
        end
        [theChildren[0].token.lexeme, super_var]
      end

      # rule('class_body' => 'LEFT_BRACE function* RIGHT_BRACE')
      def reduce_class_body(_production, _range, _tokens, theChildren)
        theChildren[1]
      end

      # rule('funDecl' => 'FUN function')
      def reduce_fun_decl(_production, _range, _tokens, theChildren)
        theChildren[1]
      end

      # rule('exprStmt' => 'expression SEMICOLON')
      def reduce_exprStmt(_production, range, tokens, theChildren)
      return_first_child(range, tokens, theChildren) # Discard the semicolon
      end

      # rule('varDecl' => 'VAR IDENTIFIER (EQUAL expression)? SEMICOLON')
      def reduce_var_declaration(_production, _range, tokens, theChildren)
        var_name = theChildren[1].token.lexeme.dup
        init_val = theChildren[2]&.last
        Ast::LoxVarStmt.new(tokens[1].position, var_name, init_val)
      end

      # rule('forStmt' => 'FOR LEFT_PAREN forControl RIGHT_PAREN statement')
      def reduce_for_stmt(_production, _range, tokens, theChildren)
        # Following 'Crafting Interpreters', we replace the for statement by a while loop
        return theChildren[4] if theChildren[2].compact.empty? # for(;;) => execute body once

        (init, test, update) = theChildren[2]
        if update
          new_body = LoxSeqDecl.new(tokens[0].position, [theChildren[4], update])
          stmt = Ast::LoxBlockStmt.new(tokens[1].position, new_body)
        else
          stmt = theChildren[4]
        end
        while_stmt = Ast::LoxWhileStmt.new(tokens[0].position, test, stmt)

        if init
          block_body = LoxSeqDecl.new(tokens[0].position, [init, while_stmt])
          for_stmt = Ast::LoxBlockStmt.new(tokens[1].position, block_body)
        else
          for_stmt = while_stmt
        end

        for_stmt
      end

      # rule('forControl' => 'forInitialization forTest expression?')
      def reduce_for_control(_production, _range, tokens, theChildren)
        (init, test, update) = theChildren
        if test.nil? && update
          # when test expr is nil but update expr is not, then force test to be true
          test = LoxLiteralExpr.new(tokens[0].position, Datatype::True.instance)
        end
        [init, test, update&.first]
      end

      # rule('forInitialization' => 'SEMICOLON')
      def reduce_empty_for_initialization(_production, _range, _tokens, _theChildren)
        nil
      end

      # rule('forTest' => 'expression? SEMICOLON')
      def reduce_for_test(_production, _range, _tokens, theChildren)
        theChildren[0]&.first
      end

      # rule('ifStmt' => 'IF ifCondition statement ELSE statement')
      # rule('unbalancedStmt' => 'IF ifCondition statement ELSE unbalancedStmt')
      def reduce_if_else_stmt(_production, _range, tokens, theChildren)
        condition = theChildren[1]
        then_stmt = theChildren[2]
        else_stmt = theChildren[4]
        LoxIfStmt.new(tokens[0].position, condition, then_stmt, else_stmt)
      end

      # rule('unbalancedStmt' => 'IF ifCondition stmt').as ''
      def reduce_if_stmt(_production, _range, tokens, theChildren)
        condition = theChildren[1]
        then_stmt = theChildren[2]
        else_stmt = nil
        LoxIfStmt.new(tokens[0].position, condition, then_stmt, else_stmt)
      end

      # rule('printStmt' => 'PRINT expression SEMICOLON')
      def reduce_print_stmt(_production, _range, tokens, theChildren)
        Ast::LoxPrintStmt.new(tokens[1].position, theChildren[1])
      end

      # rule('returnStmt' => 'RETURN expression? SEMICOLON')
      def reduce_return_stmt(_production, _range, tokens, theChildren)
        ret_expr = theChildren[1]&.first
        Ast::LoxReturnStmt.new(tokens[1].position, ret_expr)
      end

      # rule('whileStmt' => 'WHILE LEFT_PAREN expression RIGHT_PAREN statement').as ''
      def reduce_while_stmt(_production, _range, tokens, theChildren)
        Ast::LoxWhileStmt.new(tokens[1].position, theChildren[2], theChildren[4])
      end

      # rule('block' => 'LEFT_BRACE declaration* RIGHT_BRACE')
      def reduce_block_stmt(_production, _range, tokens, theChildren)
        decls = nil
        if theChildren[1]
          pos = tokens[1].position
          decls = LoxSeqDecl.new(pos, theChildren[1].flatten)
        else
          pos = tokens[0].position
        end
        Ast::LoxBlockStmt.new(pos, decls)
      end

      # rule('assignment' => '(call DOT)? IDENTIFIER EQUAL assignment')
      def reduce_assign_expr(_production, _range, tokens, theChildren)
        name_assignee = theChildren[1].token.lexeme.dup
        if theChildren[0]
          set_expr = Ast::LoxSetExpr.new(tokens[1].position, theChildren[0].first)
          set_expr.property = name_assignee
          set_expr.value = theChildren[3]
          set_expr
        else
          Ast::LoxAssignExpr.new(tokens[1].position, name_assignee, theChildren[3])
        end
      end


      # rule('comparisonTest_plus' => 'comparisonTest_plus comparisonTest term').as 'comparison_t_plus_more'
      # TODO: is it meaningful to implement this rule?

      # rule('unary' => 'unaryOp unary')
      def reduce_unary_expr(_production, _range, tokens, theChildren)
        operator = Name2unary[theChildren[0].symbol.name].to_sym
        operand = theChildren[1]
        LoxUnaryExpr.new(tokens[0].position, operator, operand)
      end

      # rule('call' => 'primary refinement_plus').as 'call_expr'
      def reduce_call_expr(_production, _range, _tokens, theChildren)
        # return theChildren[0] unless theChildren[1]
        members = theChildren.flatten
        call_expr = nil
        loop do
          (callee, call_expr) = members.shift(2)
          call_expr.callee = callee
          members.unshift(call_expr)
          break if members.size == 1
        end

        call_expr
      end

      # rule('refinement_plus' => 'refinement_plus refinement')
      def reduce_refinement_plus_more(_production, _range, _tokens, theChildren)
        theChildren[0] << theChildren[1]
      end

      # rule('refinement_plus' => 'refinement').
      def reduce_refinement_plus_end(_production, _range, _tokens, theChildren)
        theChildren
      end

      # rule('refinement' => 'LEFT_PAREN arguments? RIGHT_PAREN')
      def reduce_call_arglist(_production, _range, tokens, theChildren)
        args = theChildren[1] || []
        if args.size > 255
          raise Loxxy::RuntimeError, "Can't have more than 255 arguments."
        end

        LoxCallExpr.new(tokens[0].position, args)
      end

      # rule('refinement' => 'DOT IDENTIFIER').as 'get_expr'
      def reduce_get_expr(_production, _range, tokens, theChildren)
        LoxGetExpr.new(tokens[0].position, theChildren[1].token.lexeme)
      end

      # rule('primary' => 'LEFT_PAREN expression RIGHT_PAREN')
      def reduce_grouping_expr(_production, _range, tokens, theChildren)
        subexpr = theChildren[1]
        LoxGroupingExpr.new(tokens[0].position, subexpr)
      end

      # rule('primary' => 'FALSE' | TRUE').as 'literal_expr'
      def reduce_literal_expr(_production, _range, _tokens, theChildren)
        first_child = theChildren.first
        pos = first_child.token.position
        literal = first_child.token.value
        LoxLiteralExpr.new(pos, literal)
      end

      # rule('primary' => 'IDENTIFIER')
      def reduce_variable_expr(_production, _range, _tokens, theChildren)
        var_name = theChildren[0].token.lexeme
        pos = theChildren[0].token.position
        LoxVariableExpr.new(pos, var_name)
      end

      # rule('primary' => 'THIS')
      def reduce_this_expr(_production, _range, tokens, _children)
        LoxThisExpr.new(tokens[0].position)
      end

      # rule('primary' => 'SUPER DOT IDENTIFIER')
      def reduce_super_expr(_production, _range, _tokens, theChildren)
        LoxSuperExpr.new(theChildren[0].token.position, theChildren[2].token.lexeme)
      end

      # rule('function' => 'IDENTIFIER LEFT_PAREN parameters? RIGHT_PAREN block').as 'function'
      def reduce_function(_production, _range, _tokens, theChildren)
        first_child = theChildren.first
        pos = first_child.token.position
        params = theChildren[2] ? theChildren[2].flatten : []
        if params.size > 255
          msg = "Can't have more than 255 parameters."
          raise Loxxy::SyntaxError, msg
        end
        LoxFunStmt.new(pos, first_child.token.lexeme, params, theChildren[4])
      end

      # rule('parameters' => 'IDENTIFIER (COMMA IDENTIFIER)*').as 'parameters'
      def reduce_parameters(_production, _range, _tokens, theChildren)
        first_lexeme = theChildren[0].token.lexeme
        return [first_lexeme] unless theChildren[1]

        successors = theChildren[1].map { |seq_node| seq_node.last.token.lexeme }
        successors.unshift(first_lexeme)
      end

      # rule('arguments' => 'expression (COMMA expression)*')
      def reduce_arguments(_production, _range, _tokens, theChildren)
        return [theChildren[0]] if theChildren[1].empty?

        successors = theChildren[1].map(&:last)
        successors.unshift(theChildren[0])
      end
    end # class
  end # module
end # module
