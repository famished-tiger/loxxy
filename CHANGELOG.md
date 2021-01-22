## [0.0.26] - 2021-01-22
- The interpreter implements `while` loops.

### Added
- Class `Ast::LoxWhileStmt` a node that represents a while statement
- Method `Ast::ASTBuilder#reduce_while_stmt` creates an `Ast::LoxWhileStmt` node
- Method `Ast::ASTVisitor#visit_while_stmt` for visiting an `Ast::LoxWhileStmt` node
- Method `BackEnd::Engine#after_while_stmt` implements the while looping structure

### Changed
- File `README.md` updated.

## [0.0.25] - 2021-01-21
- The interpreter implements blocks of code.

### Added
- Class `Ast::LoxBlockStmt` a node that represents a block of code
- Method `Ast::ASTBuilder#reduce_block_stmt` creates an `Ast::LoxBlockStmt` node
- Method `Ast::ASTVisitor#visit_block_stmt` for visiting an `Ast::LoxBlockStmt` node
- Method `BackEnd::Engine#before_block_stmt` creates an new enclosed Environment
- Method `BackEnd::Engine#after_block_stmt` close enclosed Environment and make parent Environment the current one

### Changed
- File `README.md` updated.

## [0.0.24] - 2021-01-20
- The interpreter implements the assignment of variables.

### Added
- Class `Ast::LoxAssignExpr` a node that represents the assignment of a value to a variable
- Method `Ast::ASTBuilder#reduce_assign_expr` creates an `Ast::LoxAssignExpr` node
- Method `Ast::ASTVisitor#visit_assign_expr` for visiting an `Ast::LoxAssignExpr` node
- Method `BackEnd::Engine#after_assign_expr` implementation of the assignment
- Method `BackEnd::Variable#assign` to assign a value to a variable 

## [0.0.23] - 2021-01-20
- Fix for variables without explicit initialization.

### Added
- Method `Ast::ASTVisitor#visit_builtin` for visiting `Datatype::BuiltinDatatype` value.
- Method `BackEnd::Engine#before_visit_builtin` push the data value onto the stack.

### Fixed
- Method `Ast::LoxVarStmt#initialize`: in case no explicit value provided then use `Datatype::Nil.instance`instead of Ruby `nil`

## [0.0.22] - 2021-01-17
- The interpreter can retrieve the value of a variable.

### Added
- Method `Ast::ASTBuilder#declaration_plus_more` and `Ast::ASTBuilder#declaration_plus_end` to allow multiple expressions/statements
- Method `Ast::ASTBuilder#reduce_var_expression` creates an `Ast::LoxVariableExpr` node
- Method `Ast::ASTVisitor#visit_var_expr` for visiting `Ast::LoxVariableExpr` nodes
- Class `Ast::LoxSeqDecl` a node that represents a sequence of declarations/statements
- Class `Ast::LoxVarExpr` a node that represents a variable occurrence in an expression
- Method `Engine::after_variable_expr`: retrieve the value of variable with given name

### Changed
- Method `Ast::ASTBuilder#reduce_lox_program` to support multiple statements/declarations
- File `README.md` updated.

## [0.0.21] - 2021-01-16
- The interpreter supports the declaration global variables.

### Added
- Class `BackEnd::Entry`, mixin module for objects put in the symbol table
- Class `BackEnd::Environment` that keeps track of variables in a given context.
- Class `BackEnd::SymbolTable` that keeps track of environments.
- Class `BackEnd::Variable` internal representation of a `Lox` variable
- Method `Ast::ASTBuilder#reduce_var_declaration` and `Ast::ASTBuilder#reduce_var_declaration`
- Method `Ast::ASTVisitor#visit_var_stmt` for visiting `LoxVarStmt` nodes
- Attribute `Engine::symbol_table`for keeping track of variables
- Method `Engine::after_var_stmt` for the implementation of variable declarations

## [0.0.20] - 2021-01-15
- The interpreter supports the `if` ... `else` statement.

### Added
- Class `Ast::LoxItStmt`, AST node specific for `if` `else` statements
- Method `Ast::ASTBuilder#reduce_if_stmt` as semantic action for if ... else
- Method `Ast::ASTVisitor#visit_if_stmt` for visiting `LoxIfStmt` nodes
- Method `Engine::after_if_stmt` implementation of the control flow

## [0.0.19] - 2021-01-14
- The interpreter supports expressions between parentheses (grouping).

### Added
- Class `Ast::LoxLogicalExpr`
- Method `Ast::ASTBuilder#reduce_grouping_expr` as semantic action for grouping expression
- Method `Ast::ASTVisitor#visit_grouping_expr` for visiting grouping expressions
- Method `Engine::after_grouping_expr`for the evaluation of grouping expressions

### Changed
- File `grammar.rb` rules for if ... else were given names in order to activate semantic actions.
- File `README.md` updated with little `if ... else` documentation.

## [0.0.18] - 2021-01-13
- The interpreter can evaluate `and`, `or`expressions.

### Added
- Class `Ast::LoxLogicalExpr`
- Method `Ast::ASTBuilder#reduce_logical_expr` for the semantic action require for `and`, `or`
- Method `Ast::ASTVisitor#visit_logical_expr` for visiting logical expressions
- Method `Backend::Engine#after_logical_expr` implements the evaluation of the logical expressions

## [0.0.17] - 2021-01-12
- The interpreter can evaluate all arithmetic and comparison operations.
- It implements `==`, `!=` and the unary operations `!`, `-`

### Added
- Class `Ast::LoxUnaryExpr`
- Method `Ast::ASTBuilder#reduce_unary_expr` to support the evaluation of `!` and ``-@`
- Method `Ast::ASTVisitor#visit_unnary_expr` for visiting unary expressions
- Method `Backend::Engine#after_unary_expr` evaluating an unary expression
- In class `Datatype::BuiltinDatatype` the methods `falsey?`, `truthy?`, `!`, `!=`
- In class `Datatype::Number`the methods `<`, `<=`, ´>´, `>=` and `-@`

### Changed
- File `README.md` updated.

## [0.0.16] - 2021-01-11
- The interpreter can evaluate product and division of two numbers.
- It also implements equality `==` and inequality `!=` operators

### Added
- Method `Datatype::False#==` for equality testing
- Method `Datatype::False#!=` for inequality testing
- Method `Datatype::LXString#==` for equality testing
- Method `Datatype::LXString#!=` for inequality testing
- Method `Datatype::Nil#==` for equality testing
- Method `Datatype::Nil#!=` for inequality testing
- Method `Datatype::Number#==` for equality testing
- Method `Datatype::Number#!=` for inequality testing
- Method `Datatype::Number#*` for multiply operator
- Method `Datatype::Number#/` for divide operator
- Method `Datatype::True#==` for equality testing
- Method `Datatype::True#!=` for inequality testing

### Changed
- Method `BackEnd::Engine#after_binary_expr` to allow `*`, `/`, `==`, `!=` operators
- File `README.md` updated for the newly implemented operators

## [0.0.15] - 2021-01-11
- The interpreter can evaluate substraction between two numbers.

### Added
- Method `Datatype::Number#-` implmenting the subtraction operation

### Changed
- File `README.md` minor editorial changes.
- File `lx_string_spec.rb` Added test for string concatentation
- File `number_spec.rb` Added tests for addition and subtraction operations
- File `interpreter_spec.rb` Added tests for subtraction operation

## [0.0.14] - 2021-01-10
- The interpreter can evaluate addition of numbers and string concatenation

### Added
- Method `Ast::ASTVisitor#visit_binary_expr` for visiting binary expressions
- Method `Ast::LoxBinaryExpr#accept` for visitor pattern
- Method `BackEnd::Engine#after_binary_expr` to trigger execution of binary operator
- `Boolean` class hierarchy: added methos `true?` and `false?` to ease spec test writing
- Method `Datatype::LXString#+` implementation of the string concatenation
- Method `Datatype::Number#+` implementation of the addition of numbers

### Changed
- File `interpreter_spec.rb` Added tests for addition operation and string concatenation


## [0.0.13] - 2021-01-10
- The interpreter can evaluate directly simple literals.

### Changed
- Class `AST::ASTBuilder` added `reduce_exprStmt` to support the evaluation of literals.
- File `README.md` added one more example.
- File `parser_spec.rb` Updated the tests to reflect the change in the AST.
- File `interpreter_spec.rb` Added a test for literal expression.

### Fixed
- File `loxxy.rb`: shorthand method `lox_true` referenced the ... false object (oops).

## [0.0.12] - 2021-01-09
- Initial interpreter capable of evaluating a tiny subset of Lox language.

### Added
- Class `AST::LoxNoopExpr`
- Class `AST::LoxPrintStmt`
- Class `BackEnd::Engine` implementation of the print statement logic
- Class `Interpreter`

### Changed
- Class `Ast::ASTVisitor` Added visit method
- File `README.md` added Hello world example.

## [0.0.11] - 2021-01-08
- AST node generation for logical expression (and, or).

### Changed
- Class `AST::ASTBuilder` added `reduce_` methods for logical operations.
- File `grammar.rb`added name to logical expression rules
- File `README.md` added gem version and license badges, expanded roadmap section.

### Fixed
- File `grammar.rb`: a rule had incomplete non-terminal name `conjunct_` in its lhs.


## [0.0.10] - 2021-01-08
- AST node generation for equality expression.

### Changed
- Class `AST::ASTBuilder` refactoring and added `reduce_` methods for equality operations.
- File `grammar.rb`added name to equality rules
- File `README.md` added gem version and license badges, expanded roadmap section.

### Fixed
- File `grammar.rb`: a rule had still the discarded non-terminal `equalityTest_star` in its lhs.

## [0.0.9] - 2021-01-07
- AST node generation for comparison expression.

### Changed
- Class `AST::ASTBuilder` added `reduce_` methods for comparison operations.
- File `grammar.rb`added name to comparison rules

## [0.0.8] - 2021-01-07
- AST node generation for arithmetic operations of number literals.

### Changed
- Class `AST::ASTBuilder` added `reduce_` methods for arithmetic operations.
- File `grammar.rb`added name to arithmetic rules

### Fixed
- File `grammar.rb`: second rule for `factor` had a missing member in rhs.

## [0.0.7] - 2021-01-06
- Lox grammar reworked, initial AST classes created.

### Added
- Class `Parser` this one generates AST's (Abstract Syntax Tree)
- Class `AST::ASTVisitor` draft initial implementation.
- Class `AST::BinaryExpr` draft initial implementation.
- Class `AST::LoxCompoundExpr` draft initial implementation.
- Class `AST::LiteralExpr` draft initial implementation.
- Class `AST::LoxNode` draft initial implementation.

### Changed
- File `spec_helper.rb`: removed Bundler dependency
- Class `AST::ASTBuilder` added initial `reduce_` methods.
- File `README.md` Removed example with AST generation since this is in flux.

## [0.0.6] - 2021-01-03
- First iteration of a parser with AST generation.

### Added
- Class `Parser` this one generates AST's (Abstract Syntax Tree)
- Class `AST::ASTBuilder` default code to generate an AST.

### Changed
- File `spec_helper.rb`: removed Bundler dependency
- File `README.md` Added example with AST visualization.

### Fixed
- File `grammar.rb` ensure that the constant `Grammar` is created once only.

## [0.0.5] - 2021-01-02
- Improved example in `README.md`, code re-styling to please `Rubocop` 1.7

### Changed
- Code re-styling to please `Rubocop` 1.7
- File `README.md` Improved example with better parse tree visualization.

## [0.0.4] - 2021-01-01
- A first parser implementation able to parse Lox source code.

### Added
- Method `LXString::==` equality operator.

### Changed
- class `Parser` renamed to `RawParser`
- File `README.md` Added an example showing the use of `RawParser` class.

## [0.0.3] - 2020-12-29
- Scanner can recognize strings and nil tokens
### Added
- class `Datatype::Nil` for representing nil tokens in Lox
- class `Datatype::LXString` for representing Lox strings

### Changed
- Method `BuilinDatatype::validated_value` now accepts the input value as is.
- `Frontend::Scanner` updated code to recognize strings and nil
- File `scanner_spec.rb` Added tests for strings, nil scanning

## [0.0.2] - 2020-12-28
- Scanner can recognize keywords, boolean and numbers
### Added
- `Datatype` module and classes

### Changed
- `Frontend::Scanner` updated code to recognize booleans and numbers
- File `scanner_spec.rb` Added tests for keywords, booleans and number scanning
- File `README.md` fixed a couple of typos.

## [0.0.1] - 2020-12-27
### Added
- Initial Github commit