## [0.2.03] - 2021-04-24
- Fixes for the set (field) expressions, `accept` methods for AST nodes are meta-programmed 

### New
- Module `Ast::Visitee` provides the `define_accept` method that generate `accept` method with meta-programming

### Fixed
- Method `BackEnd::Engine#before_set_expr` methos method that ensure that the receiver is evaluated first, then the assigned value
- Method `BackEnd::Engine`#after_set_expr` now pushes the value assigned to the field also onto the stack
- Class `BackEnd::Engine` a number of StnadardError exceptions are replaced by Loxxy::RuntimeError


## [0.2.02] - 2021-04-21
- Improvements in the scanner class (escape sequence for quotes and newlines), error messages closer to jlox.

### Changed
- File `loxxy` executable doesn't show a stack trace for scanner errors
- Class `ScannerError` is now a subclass of `Loxxy::Error`
- Class `Scanner` now returns a specific error message for unterminated strings
- Class `Scanner` error messages are closer to the ones from jlox
- Class `Scanner` supports now escape sequences \" for double quotes, \n for newlines
- File `README.md` Reshuffled some text

## [0.2.01] - 2021-04-18
- Minor improvements in CLI, starting re-documenting `README.md`.

### New
- Class `Loxxy::CLIParser` parser for the command-line options

### Changed
- File `loxxy` executable now uses commad-line parsing
- File `.rubocop.yml` updated with new cops
- File `README.md` Added examples for command-line interface
- File `loxxy.gemspec` expanded description of gem

## [0.2.00] - 2021-04-17
- `Loxxy` implements the complete `Lox` language including its object-oriented features.

### New
- Class `Ast::LoxSuperExpr` an AST node that represents the occurrence of `super` in source code.
- Method `Ast::ASTBuilder#reduce_class_subclassing` action launched by the parser when detecting inheritance
- Method `Ast::ASTBuilder#reduce_super_expr` action launched by the parser when detecting the super keyword
- Method `Ast::Visitor#visit_super_expr` visit of an `Ast::LoxSuperExpr` node
- Method `BackEnd::Engine#after_super_stmt` does the lookup of an inherited method.
- Method `BackEnd::Resolver#after_super_stmt` checks for correct context for super occurrence


### Changed
- Method `Ast::ASTBuilder#reduce_class_decl` expanded in order to support superclass
- Class `Ast::LoxClassStmt` added `superclass` attribute, expanded constructor signature.
- Method `BackEnd::Engine#after_class_stmt` adds an environment for super variable.
- Class `BackEnd::LoxClass` added `superclass` attribute, expanded constructor signature.
- Method `BackEnd::LoxClass#find_method` now does the lookup in superclass(es)
- Method `BackEnd::Resolver#after_class_stmt` super variable resolution
- File `grammar.rb` changed rules to cope with superclass name and super keyword
- File `README.md` updated to reflect current implementation level

## [0.1.17] - 2021-04-11
- `Loxxy` now support custom initializer.

### Changed
- Method `BackEnd::Class#call` updated for custom initializer.
- Class `BackEnd::LoxFunction` added an attribute `is_initializer`
- Class `BackEnd::Resolver#before_return_stmt` added a check that return in initializer may not return a value

### Fixed
- Method `BackEnd::Engine#after_call_expr` now does arity checking also for initalizer.
- Method `BackEnd::LoxInstance#set` removed the check of field existence that prevented the creation of ... fields

## [0.1.16] - 2021-04-10
- Fixed an issue in name lookup. All the `this` test suite is passing.

### Changed
- Method `BackEnd::Engine#after_var_stmt` now it creates the variable and pouts it in the symbol table

### Removed
- Method `BackEnd::Engine#before_var_stmt` it generated bug when assigning a value to a var, when that var name occurred elsewhere

## [0.1.15] - 2021-04-08
- Fixed the `dangling else`by tweaking the grammar rules

### Changed
- Method `Ast::ASTBuilder#reduce_if__else_stmt` parse action specific for if with else branch

### Fixed
- File `grammar.rb` changed rules to cope with `dangling else` issue

### Changed
- Method `Ast::ASTBuilder#reduce_if_stmt` parse action for if without else branch
- File `README.md` removed the section about the `dangling else` issue.


## [0.1.14] - 2021-04-05
- `Loxxy` now implements the 'this' keyword

### New
- Class `Ast::LoxThisExpr` a syntax node that represents an occurrence of the `this` keyword
- Method `Ast::ASTBuilder#reduce_this_expr` parse action for this keyword
- Method `Ast::Visitor#visit_this_expr` visit of an `Ast::LoxThisExpr` node
- Method `BackEnd::Engine#after_this_expr` runtime action for this keyword (i.e. refers to current instance)
- Method `BackEnd::LoxFunction#bind` implementation of bound method

### Changed
- Class `BackEnd::Resolver` implementing semantic actions for `this` keyword
- File `grammar.rb` added name to a syntax rule

## [0.1.13] - 2021-04-05
- `Loxxy` now implements method calls

### New
- Class `Ast::LoxGetExpr` a syntax node that represents a read access to an object property
- Class `Ast::LoxSetExpr` a syntax node that represents a write access to an object property
- Method `Ast::ASTBuilder#reduce_set_expr` parse action for write access to an object property
- Method `Ast::ASTBuilder#reduce_get_expr` parse action for read access to an object property
- Method `Ast::Visitor#visit_set_expr` visit of an `Ast::LoxSetExpr` node
- Method `Ast::Visitor#visit_get_expr` visit of an `Ast::LoxGetExpr` node
- Method `BackEnd::Engine#after_set_expr` runtime action for property setting
- Method `BackEnd::Engine#after_get_expr` runtime action for property getting
- Method `BackEnd::LoxInstance#set` implementation of write accessor
- Method `BackEnd::LoxInstance#get` implementation of read accessor
- Method `BackEnd::Resolver#after_set_expr` resolve action for property setting
- Method `BackEnd::Resolver#after_get_expr` resolve action for property getting

### Changed
- Method `Ast::ASTBuilder#reduce_assign_expr` expanded to support write access to an object property
- Class `LoxClassStmt`: methods are now aggregate under the `body` attribute
- Class `LoxFunStmt`: has a new attribute `is_method` and inherits from `Ast::LoxNode`
- Method `BackEnd::Engine#after_class_stmt` methods are aggregated into the classes
- Method `BackEnd::Engine#after_fun_stmt` extension for method
- File `grammar.rb` added names to two syntax rules


## [0.1.12] - 2021-04-03
- Intermediate version: `Loxxy` does instance creation (default constructor)

### New
- Method `BackEnd::LoxClass#call` made class callable (for invoking the constructor)
- Class `BackEnd::LoxInstance` runtime representation of a Lox instance (object).

### Changed
- Method `BackEnd::Engine#after_call_expr` Added Lox class as callable thing.

### Fixed
- Method `Ast::ASTBuilder#reduce_class_body` couldn't handle properly empty classes

## [0.1.11] - 2021-04-03
- Intermediate version: `Loxxy` does class declarations

### New
- Class `Ast::LoxClassStmt` a syntax node that represents a class declaration
- Method `Ast::ASTBuilder#reduce_class_decl` creates a `LoxClassStmt` instance
- Method `Ast::ASTBuilder#reduce_class_name`
- Method `Ast::ASTBuilder#reduce_reduce_class_body` collect the methods of the class
- Method `Ast::ASTBuilder#reduce_method_plus_more` for dealing with methods
- Method `Ast::ASTBuilder#reduce_method_plus_end`
- Method `Ast::ASTVisitor#visit_class_stmt` for visiting an `Ast::LoxClassStmt` node
- Method `Ast::LoxBlockStmt#empty?` returns true if the code block is empty
- Method `BackEnd::Engine#after_class_stmt`
- Method `BackEnd::Resolver#after_class_stmt`
- Method `BackEnd::Resolver#before_class_stmt`
- Class `BackEnd::LoxClass` runtime representation of a Lox class.

### Changed
- File `grammar.rb` refactoring of class declaration syntax rules

## [0.1.10] - 2021-03-31
- Flag return statements occurring outside functions as an error

### Changed
- Class `BackEnd::Resolver` Added attribute `current_function` to know whether the visited parse node is located inside a function


## [0.1.09] - 2021-03-28
- Fix and test suite for return statements

### CHANGED
- `Loxxy` reports an error when a return statement occurs in top-level scope 

### Fixed
- A return without explicit value genrated an exception in some cases.

## [0.1.08] - 2021-03-27
- `Loxxy` implements variable resolving and binding as described in Chapter 11 of "Crafting Interpreters" book.

### New
- Class `BackEnd::Resolver` implements the variable resolution (whenever a variable is in use, locate the declaration of that variable)

### CHANGED
- Class `Ast::Visitor` changes in some method signatures
- Class `BackEnd::Engine` new attribute `resolver` that points to a `BackEnd::Resolver` instance
- Class `BackEnd::Engine` several methods dealing with variables have been adapted to take the resolver into account.

## [0.1.07] - 2021-03-14
- `Loxxy` now supports nested functions and closures

### Changed
- Method `Ast::AstBuilder#reduce_call_expr` now supports nested call expressions (e.g. `getCallback()();` )
- Class `BackEnd::Environment`: added the attributes `predecessor` and `embedding` to support closures.
- Class `BackeEnd::LoxFunction`: added the attribute `closure` that is equal to the environment where the function is declared.
- Constructor `BackEnd::LoxFunction#new` now takes a `BackEnd::Engine`as its fourth parameter
- Methods `BackEnd::SymbolTable#enter_environment`, `BackEnd::SymbolTable#leave_environment` take into account closures. 

### Fixed
- Method `Ast::AstBuilder#after_var_stmt` now takes into account the value from the top of stack


## [0.1.06] - 2021-03-06
- Parameters/arguments checks in function declaration and call

### Changed
- Method `Ast::AstBuilder#reduce_call_arglist` raises a `Loxxy::RuntimeError` when more than 255 arguments are used.
- Method `BackEnd::Engine#after_call_expr` raises a `Loxxy::RuntimeError` when argument count doesn't match the arity of function.

- Class `BackEnd::Function` renamed to `LoxFunction`

## [0.1.05] - 2021-03-05
- Test for Fibbonacci recursive function is now passing.

### Fixed
- Method `BackEnd::Function#call` a call doesn't no more generate of TWO scopes

## [0.1.04] - 2021-02-28

### Added
- Class `Ast::LoxReturnStmt` a node that represents a return statement
- Method `Ast::ASTBuilder#reduce_return_stmt`
- Method `Ast::ASTVisitor#visit_return_stmt` for visiting an `Ast::LoxReturnStmt` node
- Method `BackEnd::Engine#after_return_stmt` to handle return statement
- Method `BackEnd::Function#!` implementing the logical negation of a function (as value).
- Test suite for logical operators (in project repository)
- Test suite for block code
- Test suite for call and function declaration (initial)

### Changed
- Method `BackEnd::Engine#after_call_expr` now generate a `catch` and `throw` events

## [0.1.03] - 2021-02-26
- Runtime argument checking for arithmetic and comparison operators

### Added
- Test suite for arithmetic and comparison operators (in project repository)
- Class `BackEnd::UnaryOperator`:  runtime argument validation
- Class `BackEnd::BinaryOperator`: runtime argument validation

### Changed
- File `console` renamed to `loxxy`. Very basic command-line interface.
- Custom exception classes 
- File `README.md` updated list of supported `Lox` keywords.


## [0.1.02] - 2021-02-21
- Function definition and call documented in `README.md`

### Changed
- File `README.md` updated description of function definition and function call.

### Fixed
- Method `BackEnd::Engine#after_print_stmt` now handles of empty stack or nil data.
- Method `BackEnd::Engine#after_call_expr` was pushing one spurious item onto data stack.

## [0.1.01] - 2021-02-20
### Fixed
- Fixed most offences for Rubocop.


## [0.1.00] - 2021-02-20
- Version number bumped, `Loxxy` supports function definitions

### Added
- Class `Ast::LoxFunStmt` a node that represents a function declaration
- Method `Ast::ASTBuilder#reduce_fun_decl`
- Method `Ast::ASTBuilder#reduce_function` creates a `LoxFunStmt` instance
- Method `Ast::ASTBuilder#reduce_parameters_plus_more` for dealing with function parameters
- Method `Ast::ASTBuilder#reduce_parameters_plus_end`
- Method `Ast::ASTVisitor#visit_fun_stmt` for visiting an `Ast::LoxFunStmt` node
- Method `Ast::LoxBlockStmt#empty?` returns true if the code block is empty
- Method `BackEnd::Engine#after_fun_stmt`
- Method `BackEnd::NativeFunction#call` 
- Method `BackEnd::NativeFunction#to_str` 
- Method `BackEnd::LoxFunction` runtime representation of a Lox function.

### Changed
- Method `BackEnd::Engine#after_call_expr`

### Fixed
- Fixed inconsistencies in documentation comments.

## [0.0.28] - 2021-02-15
- The interpreter implements function calls (to a native function).

### Added
- Class `Ast::LoxCallExpr` a node that represents a function call expression
- Method `Ast::ASTBuilder#reduce_call_expr`
- Method `Ast::ASTBuilder#reduce_refinement_plus_end`
- Method `Ast::ASTBuilder#reduce_call_arglist` creates a `LoxCallExpr` node
- Method `Ast::ASTBuilder#reduce_arguments_plus_more` builds the function argument array
- Method `Ast::ASTVisitor#visit_call_expr` for visiting an `Ast::LoxCallExpr` node
- Method `BackEnd::Engine#after_call_expr`implements the evaluation of a function call.
- Method `BackEnd::Engine#after_for_stmt` implements most of the `for` control flow

## [0.0.27] - 2021-01-24
- The interpreter implements `while` loops.

### Added
- Class `Ast::LoxForStmt` a node that represents a `for` statement
- Method `Ast::ASTBuilder#reduce_for_stmt`
- Method `Ast::ASTBuilder#reduce_for_control` creates an `Ast::LoxForStmt` node
- Method `Ast::ASTVisitor#visit_for_stmt` for visiting an `Ast::LoxWhileStmt` node
- Method `BackEnd::Engine#before_for_stmt` builds a new environment for the loop variable
- Method `BackEnd::Engine#after_for_stmt` implements most of the `for` control flow

### Changed
- File `README.md` updated.

## [0.0.26] - 2021-01-22
- The interpreter implements `while` loops.

### Added
- Class `Ast::LoxWhileStmt` a node that represents a `while` statement
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
- Method `Datatype::Number#-` implementing the subtraction operation

### Changed
- File `README.md` minor editorial changes.
- File `lx_string_spec.rb` Added test for string concatenation
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