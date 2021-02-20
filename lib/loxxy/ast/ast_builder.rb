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
        super(theTokens)
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

      # rule('program' => 'EOF').as 'null_program'
      def reduce_null_program(_production, _range, _tokens, _theChildren)
        Ast::LoxNoopExpr.new(tokens[0].position)
      end

      # rule('program' => 'declaration_plus EOF').as ''
      def reduce_lox_program(_production, _range, tokens, theChildren)
        LoxSeqDecl.new(tokens[0].position, theChildren[0])
      end

      # rule('declaration_plus' => 'declaration_plus declaration').as ''
      def reduce_declaration_plus_more(_production, _range, _tokens, theChildren)
        theChildren[0] << theChildren[1]
      end

      # rule('declaration_plus' => 'declaration')
      def reduce_declaration_plus_end(_production, _range, _tokens, theChildren)
        [theChildren[0]]
      end

      # rule('funDecl' => 'FUN function')
      def reduce_fun_decl(_production, _range, _tokens, theChildren)
        theChildren[1]
      end

      # rule('exprStmt' => 'expression SEMICOLON')
      def reduce_exprStmt(_production, range, tokens, theChildren)
      return_first_child(range, tokens, theChildren) # Discard the semicolon
      end

      # rule('varDecl' => 'VAR IDENTIFIER SEMICOLON')
      def reduce_var_declaration(_production, _range, tokens, theChildren)
        var_name = theChildren[1].token.lexeme.dup
        Ast::LoxVarStmt.new(tokens[1].position, var_name, nil)
      end

      # rule('varDecl' => 'VAR IDENTIFIER EQUAL expression SEMICOLON')
      def reduce_var_initialization(_production, _range, tokens, theChildren)
        var_name = theChildren[1].token.lexeme.dup
        Ast::LoxVarStmt.new(tokens[1].position, var_name, theChildren[3])
      end

      # rule('forStmt' => 'FOR LEFT_PAREN forControl RIGHT_PAREN statement')
      def reduce_for_stmt(_production, _range, _tokens, theChildren)
        for_stmt = theChildren[2]
        for_stmt.body_stmt = theChildren[4]
        for_stmt
      end

      # rule('forControl' => 'forInitialization forTest forUpdate')
      def reduce_for_control(_production, _range, tokens, theChildren)
        (init, test, update) = theChildren
        Ast::LoxForStmt.new(tokens[0].position, init, test, update)
      end

      # rule('forInitialization' => 'SEMICOLON')
      def reduce_empty_for_initialization(_production, _range, _tokens, _theChildren)
        nil
      end

      # rule('forTest' => 'expression_opt SEMICOLON')
      def reduce_for_test(_production, range, tokens, theChildren)
        return_first_child(range, tokens, theChildren)
      end

      # rule('ifStmt' => 'IF ifCondition statement elsePart_opt')
      def reduce_if_stmt(_production, _range, tokens, theChildren)
        condition = theChildren[1]
        then_stmt = theChildren[2]
        else_stmt = theChildren[3]
        LoxIfStmt.new(tokens[0].position, condition, then_stmt, else_stmt)
      end

      # rule('printStmt' => 'PRINT expression SEMICOLON')
      def reduce_print_stmt(_production, _range, tokens, theChildren)
        Ast::LoxPrintStmt.new(tokens[1].position, theChildren[1])
      end

      # rule('whileStmt' => 'WHILE LEFT_PAREN expression RIGHT_PAREN statement').as ''
      def reduce_while_stmt(_production, _range, tokens, theChildren)
        Ast::LoxWhileStmt.new(tokens[1].position, theChildren[2], theChildren[4])
      end

      # rule('block' => 'LEFT_BRACE declaration_plus RIGHT_BRACE')
      def reduce_block_stmt(_production, _range, tokens, theChildren)
        decls = LoxSeqDecl.new(tokens[1].position, theChildren[1])
        Ast::LoxBlockStmt.new(tokens[1].position, decls)
      end

      # rule('block' => 'LEFT_BRACE RIGHT_BRACE').as 'block_empty'
      def reduce_block_empty(_production, _range, tokens, _children)
        Ast::LoxBlockStmt.new(tokens[0].position, nil)
      end

      # rule('assignment' => 'owner_opt IDENTIFIER EQUAL assignment')
      def reduce_assign_expr(_production, _range, tokens, theChildren)
        var_name = theChildren[1].token.lexeme.dup
        Ast::LoxAssignExpr.new(tokens[1].position, var_name, theChildren[3])
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
        theChildren[1].callee = theChildren[0]
        theChildren[1]
      end

      # rule('refinement_plus' => 'refinement').
      def reduce_refinement_plus_end(_production, _range, _tokens, theChildren)
        theChildren[0]
      end

      # rule('refinement' => 'LEFT_PAREN arguments_opt RIGHT_PAREN')
      def reduce_call_arglist(_production, _range, tokens, theChildren)
        args = theChildren[1] || []
        if args.size > 255
          raise StandardError, "Can't have more than 255 arguments."
        end

        LoxCallExpr.new(tokens[0].position, args)
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
      def reduce_variable_expr(_production, _range, tokens, theChildren)
        var_name = theChildren[0].token.lexeme
        LoxVariableExpr.new(tokens[0].position, var_name)
      end

      # rule('function' => 'IDENTIFIER LEFT_PAREN params_opt RIGHT_PAREN block').as 'function'
      def reduce_function(_production, _range, _tokens, theChildren)
        first_child = theChildren.first
        pos = first_child.token.position
        LoxFunStmt.new(pos, first_child.token.lexeme, theChildren[2], theChildren[4])
      end

      # rule('parameters' => 'parameters COMMA IDENTIFIER')
      def reduce_parameters_plus_more(_production, _range, _tokens, theChildren)
        theChildren[0] << theChildren[2].token.lexeme
      end

      # rule('parameters' => 'IDENTIFIER')
      def reduce_parameters_plus_end(_production, _range, _tokens, theChildren)
        [theChildren[0].token.lexeme]
      end

      # rule('arguments' => 'arguments COMMA expression')
      def reduce_arguments_plus_more(_production, _range, _tokens, theChildren)
        theChildren[0] << theChildren[2]
      end

      # rule('arguments' => 'expression')
      def reduce_arguments_plus_end(_production, _range, _tokens, theChildren)
        theChildren
      end
    end # class
  end # module
end # module
