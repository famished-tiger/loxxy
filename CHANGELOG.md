## [0.0.13] - 2021-01-10
- The interpreter can evaluate directly simple literals.

## Changed
- Class `AST::ASTBuilder` added `reduce_exprStmt` to support the evaluation of literals.
- File `README.md` added one more example.
- File `parser_spec.rb` Updated the tests to reflect the change in the AST.
- File `interpreter_spec.rb` Added a test for literal expression.

## Fixed
- File `loxxy.rb`: shorthand method `lox_true` referenced the ... false object (oops).

## [0.0.12] - 2021-01-09
- Initial interpreter capable of evaluating a tiny subset of Lox language.

## Added
- Class `AST::LoxNoopExpr`
- Class `AST::LoxPrintStmt`
- Class `BackEnd::Engine` implementation of the print statement logic
- Class `Interpreter`

## Changed
- Class `Ast::ASTVisitor` Added visit method
- File `README.md` added Hello world example.

## [0.0.11] - 2021-01-08
- AST node generation for logical expression (and, or).

## Changed
- Class `AST::ASTBuilder` added `reduce_` methods for logical operations.
- File `grammar.rb`added name to logical expression rules
- File `README.md` added gem version and license badges, expanded roadmap section.

## Fixed
- File `grammar.rb`: a rule had incomplete non-terminal name `conjunct_` in its lhs.


## [0.0.10] - 2021-01-08
- AST node generation for equality expression.

## Changed
- Class `AST::ASTBuilder` refactoring and added `reduce_` methods for equality operations.
- File `grammar.rb`added name to equality rules
- File `README.md` added gem version and license badges, expanded roadmap section.

## Fixed
- File `grammar.rb`: a rule had still the discarded non-terminal `equalityTest_star` in its lhs.

## [0.0.9] - 2021-01-07
- AST node generation for comparison expression.

## Changed
- Class `AST::ASTBuilder` added `reduce_` methods for comparison operations.
- File `grammar.rb`added name to comparison rules

## [0.0.8] - 2021-01-07
- AST node generation for arithmetic operations of number literals.

## Changed
- Class `AST::ASTBuilder` added `reduce_` methods for arithmetic operations.
- File `grammar.rb`added name to arithmetic rules

## Fixed
- File `grammar.rb`: second rule for `factor` had a missing member in rhs.

## [0.0.7] - 2021-01-06
- Lox grammar reworked, initial AST classes created.

## Added
- Class `Parser` this one generates AST's (Abstract Syntax Tree)
- Class `AST::ASTVisitor` draft initial implementation.
- Class `AST::BinaryExpr` draft initial implementation.
- Class `AST::LoxCompoundExpr` draft initial implementation.
- Class `AST::LiteralExpr` draft initial implementation.
- Class `AST::LoxNode` draft initial implementation.

## Changed
- File `spec_helper.rb`: removed Bundler dependency
- Class `AST::ASTBuilder` added initial `reduce_` methods.
- File `README.md` Removed example with AST generation since this is in flux.

## [0.0.6] - 2021-01-03
- First iteration of a parser with AST generation.

## Added
- Class `Parser` this one generates AST's (Abstract Syntax Tree)
- Class `AST::ASTBuilder` default code to generate an AST.

## Changed
- File `spec_helper.rb`: removed Bundler dependency
- File `README.md` Added example with AST visualization.

## Fixed
- File `grammar.rb` ensure that the constant `Grammar` is created once only.

## [0.0.5] - 2021-01-02
- Improved example in `README.md`, code re-styling to please `Rubocop` 1.7

## Changed
- Code re-styling to please `Rubocop` 1.7
- File `README.md` Improved example with better parse tree visualization.

## [0.0.4] - 2021-01-01
- A first parser implementation able to parse Lox source code.

## Added
- Method `LXString::==` equality operator.

## Changed
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