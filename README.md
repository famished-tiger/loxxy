# loxxy
[![Gem Version](https://badge.fury.io/rb/loxxy.svg)](https://badge.fury.io/rb/loxxy)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/famished-tiger/loxxy/blob/main/LICENSE.txt)

### What is loxxy?
A Ruby implementation of the [Lox programming language](https://craftinginterpreters.com/the-lox-language.html ),
a simple language used in Bob Nystrom's online book [Crafting Interpreters](https://craftinginterpreters.com/ ).

### Purpose of this project:
- To deliver an open source example of a programming language fully implemented in Ruby  
  (from the scanner, parser, an interpreter).
- The implementation should be mature enough to run [LoxLox](https://github.com/benhoyt/loxlox),  
  a Lox interpreter written in Lox.

### Current status
The project is still in inception and the interpreter is being implemented...  
Currently it can execute a tiny subset of __Lox__ language.

But the __loxxy__ gem hosts also a parser class `RawPaser` that can parse, in principle, any valid Lox input.

## What's the fuss about Lox?
... Nothing...  
Bob Nystrom designed a language __simple__ enough so that he could present 
two implementations (an interpreter, then a compiler) in one single book.

Although __Lox__ is fairly simple, it is far from a toy language:
- Dynamically typed,
- Provides datatypes such as booleans, number, strings,
- Supports arithmetic operations (+, -, *, / ) and comparison ( >, >= , <, <=)
- Implements equality operators (==, !=) and the logical connectors `and` and `or`.
- Control flow statements `if`, `for` and `while`
- Functions and closures
- Object-orientation (classes, methods, inheritance).

In other words, __Lox__ contains interesting features expected from most general-purpose 
languages.

### What's missing in Lox?
__Lox__ was constrained by design and therefore was not aimed to be a language used in real-world applications.
Here are some missing parts to make it a _practical_ language:
- Collections (arrays, maps, ...)
- Modules (importing stuff from other packages/files)
- Error handling (e.g. exceptions)  
- Support for concurrency (e.g. threads, coroutines)

Also a decent standard library for IO, networking,... is lacking. 

For sure, the language has shortcomings but on the other hand, it exhibits the essential features 
to cover in an introduction to language implementation.

That's already fun... and if all this gives you the inspiration for creating your own
language, that might be even funnier... 

Last point: what's makes __Lox__ interesting is the fact that there are implementations in many [languages](https://github.com/munificent/craftinginterpreters/wiki/Lox-implementations)

## Hello world example
```ruby
require 'loxxy'

lox_program = <<LOX_END
  // Your first Lox program!
  print "Hello, world!";
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # Output: Hello, world!
```

## Retrieving the result from a Lox program
The __Loxxy__ interpreter returns the value of the last evaluated expression. 

```ruby
require 'loxxy'

lox = Loxxy::Interpreter.new

lox_program = '47 - 5; // THE answer'
result = lox.evaluate(lox_program) # => Loxxy::Datatype::Number

# `result` is a Ruby object, so let's use it...
puts result.value # Output: 42
```

## Example using RawParser class

```ruby
require 'loxxy'

lox_input = <<-LOX_END
  // Your first Lox program!
  print "Hello, world!";
LOX_END

# Show that the raw parser accepts the above program
base_parser = Loxxy::FrontEnd::RawParser.new

# Now parse the input into a concrete parse tree...
ptree = base_parser.parse(lox_input)

# Display the parse tree thanks to Rley formatters...
visitor = Rley::ParseTreeVisitor.new(ptree)
tree_formatter = Rley::Formatter::Asciitree.new($stdout)
tree_formatter.render(visitor)
```

This is the output produced by the above example:
```
program
+-- declaration_plus
|   +-- declaration
|       +-- statement
|           +-- printStmt
|               +-- PRINT: 'print'
|               +-- expression
|               |   +-- assignment
|               |       +-- logic_or
|               |           +-- logic_and
|               |               +-- equality
|               |                   +-- comparison
|               |                       +-- term
|               |                           +-- factor
|               |                               +-- unary
|               |                                   +-- call
|               |                                       +-- primary
|               |                                           +-- STRING: '"Hello, world!"'
|               +-- SEMICOLON: ';'
+-- EOF: ''
```

## Suppported Lox language features
Although the interpreter should parse almost any valid Lox program,
it currently can evaluate a tiny set of AST node (AST = Abstract Syntax Tree).

Here are the language features currently supported by the interpreter:

- [Comments](#comments)
- [Keywords](#keywords)
- [Operators and Special Chars](#operators-and-special-chars)
- [Datatypes](#datatypes)
- [Statements](#statements)

### Comments

Loxxy supports single line C-style comments.

```javascript
// single line comment
```

### Keywords

The parser knows all the __Lox__ reserved keywords:
```lang-none
and, class, else, false, fun, for, if, nil, or,
print, return, super, this, true, var, while
```
Of these, the interpreter implements: `false`, `nil`, `print`, `true`

### Operators and Special Chars
#### Operators
The __loxxy__ interpreter supports all the __Lox__ unary and binary operators:
- Arithmetic operators: `+`, `-`, `*`, `/`
- Comparison operators: `>`, `>=`, `<`, `<=`
- Equality operators: `==`, `!=`
- Unary negate (change sign): `-`
- Unary not: `!`

#### Delimiters
The parser knows all the __Lox__ grouping delimiters:  
(`, ), `{`, `}`

These aren't yet implemented in the interpreter.

The other characters that have a special meaning in __Lox__ are:
- `,` Used in parameter list
- `.` For the dot notation (i.e. calling a method)
- `;` The semicolon is used to terminates expressions
- `=` Assignment

The parser recognizes them all but the interpreter accepts the semicolons only.

### Datatypes

loxxy supports  all the standard __Lox__ datatypes:
- `Boolean`: Can be `true` or `false`
- `Number`: Can be an integer or a floating-point numbers. For example: `123, 12.34, -45.67`
- `String`: Sequence of characters surrounded by `"`. For example: `"Hello!"`
- `Nil`: Used to define a null value, denoted by the `nil` keyword

## Statements
### Implemented expressions
Loxxy implements expressions:
- Plain literals only; or,
- (In)equality testing between two values; or,   
- Basic arithmetic operations (`+`, `-`, `*`, `/`, `unary -`); or,  
- Comparison between two numbers; or,
- Concatenation of two strings,
- Negation `!`

### Implemented statements
Loxxy implements the following statements:
- Expressions (see above sub-section)
- Print statement

```javascript
// Print statement with nested string concatenation
print "Hello" + ", " + "world!";
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'loxxy'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install loxxy

## Usage

TODO: Write usage instructions here

## Other Lox implementations in Ruby

For Ruby, there is the [lox](https://github.com/rdodson41/ruby-lox) gem.
There are other Ruby-based projects as well:  
- [SlowLox](https://github.com/ArminKleinert/SlowLox), described as a "1-to-1 conversion of JLox to Ruby"
- [rulox](https://github.com/LevitatingBusinessMan/rulox)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/famished_tiger/loxxy.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
