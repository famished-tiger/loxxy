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
      rule('program' => 'EOF').as 'null_program'
      rule('program' => 'declaration_plus EOF').as 'lox_program'

      # Declarations: bind an identifier to something
      rule('declaration_plus' => 'declaration_plus declaration').as 'declaration_plus_more'
      rule('declaration_plus' => 'declaration').as 'declaration_plus_end'
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

      rule('funDecl' => 'FUN function').as 'fun_decl'

      rule('varDecl' => 'VAR IDENTIFIER SEMICOLON').as 'var_declaration'
      rule('varDecl' => 'VAR IDENTIFIER EQUAL expression SEMICOLON').as 'var_initialization'

      # Statements: produce side effects, but don't introduce bindings
      rule('statement' => 'exprStmt')
      rule('statement' => 'forStmt')
      rule('statement' => 'ifStmt')
      rule('statement' => 'printStmt')
      rule('statement' => 'returnStmt')
      rule('statement' => 'whileStmt')
      rule('statement' => 'block')

      rule('exprStmt' => 'expression SEMICOLON').as 'exprStmt'

      rule('forStmt' => 'FOR LEFT_PAREN forControl RIGHT_PAREN statement').as 'for_stmt'
      rule('forControl' => 'forInitialization forTest forUpdate').as 'for_control'
      rule('forInitialization' => 'varDecl')
      rule('forInitialization' => 'exprStmt')
      rule('forInitialization' => 'SEMICOLON').as 'empty_for_initialization'
      rule('forTest' => 'expression_opt SEMICOLON').as 'for_test'
      rule('forUpdate' => 'expression_opt')

      rule('ifStmt' => 'IF ifCondition statement elsePart_opt').as 'if_stmt'
      rule('ifCondition' => 'LEFT_PAREN expression RIGHT_PAREN').as 'keep_symbol2'
      rule('elsePart_opt' => 'ELSE statement').as 'keep_symbol2'
      rule('elsePart_opt' => [])

      rule('printStmt' => 'PRINT expression SEMICOLON').as 'print_stmt'
      rule('returnStmt' => 'RETURN expression_opt SEMICOLON').as 'return_stmt'
      rule('whileStmt' => 'WHILE LEFT_PAREN expression RIGHT_PAREN statement').as 'while_stmt'
      rule('block' => 'LEFT_BRACE declaration_plus RIGHT_BRACE').as 'block_stmt'
      rule('block' => 'LEFT_BRACE RIGHT_BRACE').as 'block_empty'

      # Expressions: produce values
      rule('expression_opt' => 'expression')
      rule('expression_opt' => [])
      rule('expression' => 'assignment')
      rule('assignment' => 'owner_opt IDENTIFIER EQUAL assignment').as 'assign_expr'
      rule('assignment' => 'logic_or')
      rule('owner_opt' => 'call DOT')
      rule('owner_opt' => [])
      rule('logic_or' => 'logic_and')
      rule('logic_or' => 'logic_and disjunct_plus').as 'logical_expr'
      rule('disjunct_plus' => 'disjunct_plus OR logic_and').as 'binary_plus_more'
      rule('disjunct_plus' => 'OR logic_and').as 'binary_plus_end'
      rule('logic_and' => 'equality')
      rule('logic_and' => 'equality conjunct_plus').as 'logical_expr'
      rule('conjunct_plus' => 'conjunct_plus AND equality').as 'binary_plus_more'
      rule('conjunct_plus' => 'AND equality').as 'binary_plus_end'
      rule('equality' => 'comparison')
      rule('equality' => 'comparison equalityTest_plus').as 'binary_operator'
      rule('equalityTest_plus' => 'equalityTest_plus equalityTest comparison').as 'binary_plus_more'
      rule('equalityTest_plus' => 'equalityTest comparison').as 'binary_plus_end'
      rule('equalityTest' => 'BANG_EQUAL')
      rule('equalityTest' => 'EQUAL_EQUAL')
      rule('comparison' => 'term')
      rule('comparison' => 'term comparisonTest_plus').as 'binary_operator'
      rule('comparisonTest_plus' => 'comparisonTest_plus comparisonTest term').as 'comparison_t_plus_more'
      rule('comparisonTest_plus' => 'comparisonTest term').as 'binary_plus_end'
      rule('comparisonTest' => 'GREATER')
      rule('comparisonTest' => 'GREATER_EQUAL')
      rule('comparisonTest' => 'LESS')
      rule('comparisonTest' => 'LESS_EQUAL')
      rule('term' => 'factor')
      rule('term' => 'factor additive_plus').as 'binary_operator'
      rule('additive_plus' => 'additive_plus additionOp factor').as 'binary_plus_more'
      rule('additive_plus' => 'additionOp factor').as 'binary_plus_end'
      rule('additionOp' => 'MINUS')
      rule('additionOp' => 'PLUS')
      rule('factor' => 'unary')
      rule('factor' => 'unary multiplicative_plus').as 'binary_operator'
      rule('multiplicative_plus' => 'multiplicative_plus multOp unary').as 'binary_plus_more'
      rule('multiplicative_plus' => 'multOp unary').as 'binary_plus_end'
      rule('multOp' => 'SLASH')
      rule('multOp' => 'STAR')
      rule('unary' => 'unaryOp unary').as 'unary_expr'
      rule('unary' => 'call')
      rule('unaryOp' => 'BANG')
      rule('unaryOp' => 'MINUS')
      rule('call' => 'primary')
      rule('call' => 'primary refinement_plus').as 'call_expr'
      rule('refinement_plus' => 'refinement_plus refinement') # .as 'refinement_plus_more'
      rule('refinement_plus' => 'refinement').as 'refinement_plus_end'
      rule('refinement' => 'LEFT_PAREN arguments_opt RIGHT_PAREN').as 'call_arglist'
      rule('refinement' => 'DOT IDENTIFIER')
      rule('primary' => 'TRUE').as 'literal_expr'
      rule('primary' => 'FALSE').as 'literal_expr'
      rule('primary' => 'NIL').as 'literal_expr'
      rule('primary' => 'THIS')
      rule('primary' => 'NUMBER').as 'literal_expr'
      rule('primary' => 'STRING').as 'literal_expr'
      rule('primary' => 'IDENTIFIER').as 'variable_expr'
      rule('primary' => 'LEFT_PAREN expression RIGHT_PAREN').as 'grouping_expr'
      rule('primary' => 'SUPER DOT IDENTIFIER')

      # Utility rules
      rule('function' => 'IDENTIFIER LEFT_PAREN params_opt RIGHT_PAREN block').as 'function'
      rule('params_opt' => 'parameters')
      rule('params_opt' => [])
      rule('parameters' => 'parameters COMMA IDENTIFIER').as 'parameters_plus_more'
      rule('parameters' => 'IDENTIFIER').as 'parameters_plus_end'
      rule('arguments_opt' => 'arguments')
      rule('arguments_opt' => [])
      rule('arguments' => 'arguments COMMA expression').as 'arguments_plus_more'
      rule('arguments' => 'expression').as 'arguments_plus_end'
    end

    unless defined?(Grammar)
      # And now build the grammar and make it accessible via a constant
      # @return [Rley::Syntax::Grammar]
      Grammar = builder.grammar
    end
  end # module
end # module
