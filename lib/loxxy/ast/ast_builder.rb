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
      # Terminal2NodeClass = {
      #   'FALSE' => Datatype::False,
      #   'NIL' => Datatype::Nil,
      #   'NUMBER' => Datatype::Number,
      #   'STRING' => Datatype::LXString,
      #   'TRUE' => Datatype::True
      # }.freeze

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

      # rule('term' => 'factor additive_plus')
      def reduce_term_additive(_production, _range, tokens, theChildren)
        operand1 = theChildren[0]

        # Second child is anray with couples [operator, operand2]
        theChildren[1].each do |(operator, operand2)|
          operand1 = LoxBinaryExpr.new(tokens[0].position, operator, operand1, operand2)
        end

        operand1
      end

      # rule('additive_star' => 'additive_star additionOp factor').as 'additionOp_expr'
      def reduce_additive_plus_more(_production, _range, _tokens, theChildren)
        result = theChildren[0]
        operator = theChildren[1].symbol.name == 'MINUS' ? :- : :+
        operand2 = theChildren[2]
        result << [operator, operand2]
      end

      # rule('additive_plus' => 'additionOp factor')
      def reduce_additive_plus_end(_production, _range, _tokens, theChildren)
        operator = theChildren[0].symbol.name == 'MINUS' ? :- : :+
        operand2 = theChildren[1]
        [[operator, operand2]]
      end

      # rule('factor' => 'multiplicative_plus')
      def reduce_factor_multiplicative(_production, _range, tokens, theChildren)
        operand1 = theChildren[0]

        # Second child is anray with couples [operator, operand2]
        theChildren[1].each do |(operator, operand2)|
          operand1 = LoxBinaryExpr.new(tokens[0].position, operator, operand1, operand2)
        end

        operand1
      end

      # rule('multiplicative_plus' => 'multiplicative_plus multOp unary')
      def reduce_multiplicative_plus_more(_production, _range, _tokens, theChildren)
        result = theChildren[0]
        operator = theChildren[1].symbol.name == 'SLASH' ? :/ : :*
        operand2 = theChildren[2]
        result << [operator, operand2]
      end

      # rule('multiplicative_plus' => 'multOp unary')
      def reduce_multiplicative_plus_end(_production, _range, _tokens, theChildren)
        operator = theChildren[0].symbol.name == 'SLASH' ? :/ : :*
        operand2 = theChildren[1]
        [[operator, operand2]]
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
