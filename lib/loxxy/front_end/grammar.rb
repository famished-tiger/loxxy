# frozen_string_literal: true


require 'rley' # Load the gem

module Loxxy
  module FrontEnd
    ########################################
    # Grammar for Lox language
    # Authoritave grammar at:
    #   https://craftinginterpreters.com/appendix-i.html
    builder = Rley::Syntax::GrammarBuilder.new do
      # Punctuators, separators...
      add_terminals('LEFT_PAREN', 'RIGHT_PAREN', 'LEFT_BRACE', 'RIGHT_BRACE')
      add_terminals('COMMA', 'DOT', 'MINUS', 'PLUS')
      add_terminals('SEMICOLON', 'SLASH', 'STAR')
      add_terminals('BANG', 'BANG_EQUAL', 'EQUAL', 'EQUAL_EQUAL')
      add_terminals('GREATER', 'GREATER_EQUAL', 'LESS', 'LESS_EQUAL')

      # Keywords and literals
      add_terminals('AND', 'CLASS', 'ELSE', 'FALSE')
      add_terminals('FUN', 'FOR', 'IDENTIFIER', 'IF')
      add_terminals('NIL', 'NUMBER', 'OR', 'PRINT')
      add_terminals('RETURN', 'STRING', 'SUPER', 'THIS')
      add_terminals('TRUE', 'VAR', 'WHILE')
      add_terminals('EOF')

      # Top-level rule that matches an entire Lox program
      rule('program' => 'declaration_star EOF')

      # Declarations: bind an identifier to something
      rule('declaration_star' => 'declaration_star declaration')
      rule('declaration_star' => [])
      rule('declaration' => 'classDecl')
      rule('declaration' => 'funDecl')
      rule('declaration' => 'varDecl')
      rule('declaration' => 'statement')

      rule('classDecl' => 'CLASS classNaming class_body')
      rule('classNaming' => 'IDENTIFIER LESS IDENTIFIER')
      rule('classNaming' => 'IDENTIFIER')
      rule('class_body' => 'LEFT_BRACE function_star RIGHT_BRACE')
      rule('function_star' => 'function_star function')
      rule('function_star' => [])

      rule('funDecl' => 'FUN function')

      rule('varDecl' => 'VAR IDENTIFIER SEMICOLON')
      rule('varDecl' => 'VAR IDENTIFIER EQUAL expression SEMICOLON')

      # Statements: produce side effects, but don't introduce bindings
      rule('statement' => 'exprStmt')
      rule('statement' => 'forStmt')
      rule('statement' => 'ifStmt')
      rule('statement' => 'printStmt')
      rule('statement' => 'returnStmt')
      rule('statement' => 'whileStmt')
      rule('statement' => 'block')

      rule('exprStmt' => 'expression SEMICOLON')

      rule('forStmt' => 'FOR LEFT_PAREN forControl RIGHT_PAREN statement')
      rule('forControl' => 'forInitialization forTest forUpdate')
      rule('forInitialization' => 'varDecl')
      rule('forInitialization' => 'exprStmt')
      rule('forInitialization' => 'SEMICOLON')
      rule('forTest' => 'expression_opt SEMICOLON')
      rule('forUpdate' => 'expression_opt')

      rule('ifStmt' => 'IF ifCondition statement elsePart_opt')
      rule('ifCondition' => 'LEFT_PAREN expression RIGHT_PAREN')
      rule('elsePart_opt' => 'ELSE statement')
      rule('elsePart_opt' => [])

      rule('printStmt' => 'PRINT expression SEMICOLON')
      rule('returnStmt' => 'RETURN expression_opt SEMICOLON')
      rule('whileStmt' => 'WHILE LEFT_PAREN expression RIGHT_PAREN statement')
      rule('block' => 'LEFT_BRACE declaration_star RIGHT_BRACE')

      # Expressions: produce values
      rule('expression_opt' => 'expression')
      rule('expression_opt' => [])
      rule('expression' => 'assignment')
      rule('assignment' => 'owner_opt IDENTIFIER EQUAL assignment')
      rule('assignment' => 'logic_or')
      rule('owner_opt' => 'call DOT')
      rule('owner_opt' => [])
      rule('logic_or' => 'logic_and disjunct_star')
      rule('disjunct_star' => 'disjunct_star OR logic_and')
      rule('disjunct_star' => [])
      rule('logic_and' => 'equality conjunct_star')
      rule('conjunct_star' => 'conjunct_star AND equality')
      rule('conjunct_star' => [])
      rule('equality' => 'comparison equalityTest_star')
      rule('equalityTest_star' => 'equalityTest_star equalityTest comparison')
      rule('equalityTest_star' => [])
      rule('equalityTest' => 'BANG_EQUAL')
      rule('equalityTest' => 'EQUAL_EQUAL')
      rule('comparison' => 'term comparisonTest_star')
      rule('comparisonTest_star' => 'comparisonTest_star comparisonTest term')
      rule('comparisonTest_star' => [])
      rule('comparisonTest' => 'GREATER')
      rule('comparisonTest' => 'GREATER_EQUAL')
      rule('comparisonTest' => 'LESS')
      rule('comparisonTest' => 'LESS_EQUAL')
      rule('term' => 'factor additive_star')
      rule('additive_star' => 'additive_star additionOp factor')
      rule('additive_star' => [])
      rule('additionOp' => 'MINUS')
      rule('additionOp' => 'PLUS')
      rule('factor' => 'unary multiplicative_star')
      rule('multiplicative_star' => 'multiplicative_star multOp unary')
      rule('multiplicative_star' => [])
      rule('multOp' => 'SLASH')
      rule('multOp' => 'STAR')
      rule('unary' => 'unaryOp unary')
      rule('unary' => 'call')
      rule('unaryOp' => 'BANG')
      rule('unaryOp' => 'MINUS')
      rule('call' => 'primary refinement_star')
      rule('refinement_star' => 'refinement_star refinement')
      rule('refinement_star' => [])
      rule('refinement' => 'LEFT_PAREN arguments_opt RIGHT_PAREN')
      rule('refinement' => 'DOT IDENTIFIER')
      rule('primary' => 'TRUE')
      rule('primary' => 'FALSE')
      rule('primary' => 'NIL')
      rule('primary' => 'THIS')
      rule('primary' => 'NUMBER')
      rule('primary' => 'STRING')
      rule('primary' => 'IDENTIFIER')
      rule('primary' => 'LEFT_PAREN expression RIGHT_PAREN')
      rule('primary' => 'SUPER DOT IDENTIFIER')

      # Utility rules
      rule('function' => 'IDENTIFIER LEFT_PAREN params_opt RIGHT_PAREN block')
      rule('params_opt' => 'parameters')
      rule('params_opt' => [])
      rule('parameters' => 'parameters COMMA IDENTIFIER')
      rule('parameters' => 'IDENTIFIER')
      rule('arguments_opt' => 'arguments')
      rule('arguments_opt' => [])
      rule('arguments' => 'arguments COMMA expression')
      rule('arguments' => 'expression')
    end

    unless defined?(Grammar)
      # And now build the grammar and make it accessible via a constant
      # @return [Rley::Syntax::Grammar]
      Grammar = builder.grammar
    end
  end # module
end # module
