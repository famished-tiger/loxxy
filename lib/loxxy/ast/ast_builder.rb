# frozen_string_literal: true

require_relative '../datatype/all_datatypes'
require_relative 'lox_literal_expr'
require_relative 'lox_binary_expr'

module Loxxy
  module Ast
    # The purpose of ASTBuilder is to build piece by piece an AST
    # (Abstract Syntax Tree) from a sequence of input tokens and
    # visit events produced by walking over a GFGParsing object.
    class ASTBuilder < Rley::ParseRep::ASTBaseBuilder
      # Mapping Token name => operator | separator | delimiter characters
      # @return [Hash{String => String}]
      Name2special = {
        'AND' => 'and',
        'BANG' => '!',
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

      # rule('equality' => 'comparison equalityTest_plus')
      def reduce_equality_plus(production, range, tokens, theChildren)
        reduce_binary_operator(production, range, tokens, theChildren)
      end

      # rule('equalityTest_plus' => 'equalityTest_plus equalityTest comparison')
      def reduce_equality_t_plus_more(production, range, tokens, theChildren)
        reduce_binary_plus_more(production, range, tokens, theChildren)
      end

      # rule('equalityTest_star' => 'equalityTest comparison')
      def reduce_equality_t_plus_end(production, range, tokens, theChildren)
        reduce_binary_plus_end(production, range, tokens, theChildren)
      end

      # rule('comparison' => 'term comparisonTest_plus')
      def reduce_comparison_plus(production, range, tokens, theChildren)
        reduce_binary_operator(production, range, tokens, theChildren)
      end

      # rule('comparisonTest_plus' => 'comparisonTest_plus comparisonTest term').as 'comparison_t_plus_more'
      # TODO: is it meaningful to implement this rule?

      # rule('comparisonTest_plus' => 'comparisonTest term')
      def reduce_comparison_t_plus_end(production, range, tokens, theChildren)
        reduce_binary_plus_end(production, range, tokens, theChildren)
      end

      # rule('term' => 'factor additive_plus')
      def reduce_term_additive(production, range, tokens, theChildren)
        reduce_binary_operator(production, range, tokens, theChildren)
      end

      # rule('additive_star' => 'additive_star additionOp factor').as 'additionOp_expr'
      def reduce_additive_plus_more(production, range, tokens, theChildren)
        reduce_binary_plus_more(production, range, tokens, theChildren)
      end

      # rule('additive_plus' => 'additionOp factor')
      def reduce_additive_plus_end(production, range, tokens, theChildren)
        reduce_binary_plus_end(production, range, tokens, theChildren)
      end

      # rule('factor' => 'multiplicative_plus')
      def reduce_factor_multiplicative(production, range, tokens, theChildren)
        reduce_binary_operator(production, range, tokens, theChildren)
      end

      # rule('multiplicative_plus' => 'multiplicative_plus multOp unary')
      def reduce_multiplicative_plus_more(production, range, tokens, theChildren)
        reduce_binary_plus_more(production, range, tokens, theChildren)
      end

      # rule('multiplicative_plus' => 'multOp unary')
      def reduce_multiplicative_plus_end(production, range, tokens, theChildren)
        reduce_binary_plus_end(production, range, tokens, theChildren)
      end

      # rule('primary' => 'FALSE' | TRUE').as 'literal_expr'
      def reduce_literal_expr(_production, _range, _tokens, theChildren)
        first_child = theChildren.first
        pos = first_child.token.position
        literal = first_child.token.value
        LoxLiteralExpr.new(pos, literal)
      end
    end # class
  end # module
end # module
