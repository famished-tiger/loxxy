# loxxy
[![Gem Version](https://badge.fury.io/rb/loxxy.svg)](https://badge.fury.io/rb/loxxy)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/famished-tiger/loxxy/blob/main/LICENSE.txt)

### What is loxxy?
A Ruby implementation of the [Lox programming language](https://craftinginterpreters.com/the-lox-language.html ),
a simple language used in Bob Nystrom's online book [Crafting Interpreters](https://craftinginterpreters.com/ ).

### Purpose of this project:
- To deliver an open source example of a programming language fully implemented in Ruby  
  (from the scanner and parser to an interpreter).
- The implementation should be mature enough to run [LoxLox](https://github.com/benhoyt/loxlox),  
  a Lox interpreter written in Lox.

### Current status
The project is still in inception and the interpreter is being implemented...  
Currently it can execute a subset of __Lox__ language.

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
On one hand, the parser covers the complete Lox grammar and should therefore, in principle,
parse any valid Lox program.

On the other hand, the interpreter is under development and currently it can evaluate only a subset of __Lox__.
But the situation is changing almost daily, stay tuned...

Here are the language features currently supported by the interpreter:

- [Comments](#comments)
- [Keywords](#keywords)
- [Datatypes](#datatypes)
- [Statements](#statements)  
  -[Expressions](#expressions)  
- [Variable declarations](#var-statement) 
- [For statement](#for-statement)  
- [If Statement](#if-statement)   
- [Print Statement](#print-statement)
- [While Statement](#while-statement)  
- [Block Statement](#block-statement)

### Comments

Loxxy supports single line C-style comments.

```javascript
// single line comment
```

### Keywords
Loxxy implements the following __Lox__ reserved keywords:
```lang-none
and, false, nil, or, print, true
```

### Datatypes

loxxy supports  all the standard __Lox__ datatypes:
- `Boolean`: Can be `true` or `false`
- `Number`: Can be an integer or a floating-point numbers. For example: `123, 12.34, -45.67`
- `String`: Sequence of characters surrounded by `"`. For example: `"Hello!"`
- `Nil`: Used to define a null value, denoted by the `nil` keyword

### Statements

Loxxy supports the following statements:  
- [Expressions](#expressions)  
  -[Arithmetic expressions](#arithmetic-expressions)  
  -[String concatenation](#string-concatenation)  
  -[Comparison expressions](#comparison-expressions)  
  -[Logical expressions](#logical-expressions)  
  -[Grouping expressions](#grouping-expressions)  
  -[Variable expressions and assignments](#variable-expressions)
  
-[Variable declarations](#var-statement)  
-[If Statement](#if-statement)  
-[Print Statement](#print-statement)  
-[While Statement](#while-statement)
-[Block Statement](#block-statement)

#### Expressions

##### Arithmetic expressions
Loxxy supports the following operators for arithmetic expressions:

- `+`: Adds of two numbers. Both operands must be of the type Number  
  E.g. `37 + 5; // => 42`  
  `7 + -3; // => 4`
- `-`: (Binary) Subtracts right operand from left operand. Both operands must be numbers.  
  E.g. `47 - 5; // => 42`
- `-`: (Unary) Negates (= changes the sign) of the given number operand.  
  E.g. `- -3; // => 3`
- `*`: Multiplies two numbers  
  E.g. `2 * 3; // => 6`
- `/`: Divides two numbers  
  E.g. `8 / 2; // => 4`
  `5 / 2; // => 2.5`

##### String concatenation
- `+`: Concatenates two strings. Both operands must be of the String type.  
  E.g. `"Hello" + ", " + "world! // => "Hello, world!"`

##### Comparison expressions

- `==`: Returns `true` if left operand is equal to right operand, otherwise `false`  
  E.g. `false == false; // => true`  
  `5 + 2 == 3 + 4; // => true`  
  `"" == ""; // => true`
- `!=`: Returns `true` if left operand is not equal to right operand, otherwise `false`  
  E.g. `false != "false"; // => true`  
  `5 + 2 != 4 + 3; // => false`
- `<`: Returns `true` if left operand is less than right operand, otherwise `false`. Both operands must be numbers  
  E.g. `1 < 3; // => true`  
  `1 < 0; // => false`  
  `2 < 2; // => false`
- `<=`: Returns `true` if left operand is equal to right operand, otherwise `false`. Both operands must be numbers  
  E.g. `1 <= 3; // => true`  
  `1 <= 0; // => false`  
  `2 <= 2; // => true`
- `>`: Returns `true` if left operand is equal to right operand, otherwise `false`. Both operands must be numbers  
  E.g. `1 > 3; // => false`  
  `1 > 0; // => true`  
  `2 > 2; // => false`
- `>=`: Returns `true` if left operand is equal to right operand, otherwise `false`. Both operands must be numbers  
  E.g. `1 > 3; // => false`  
  `1 > 0; // => true`  
  `2 > 2; // => false`

##### Logical expressions

REMINDER: In __Lox__, `false` and `nil` are considered falsey, everything else is truthy.

- `and`: When both operands are booleans, then returns `true` if both left and right operands are truthy, otherwise `false`.   
  If at least one operand isn't a boolean then returns first falsey operand else (both operands are truthy) returns the second operand.
  truthy returns the second operand.  
  E.g. `false and true; // => false`  
  `true and nil; // => nil`  
  `0 and true and ""; // => ""`
- `or`: When both operands are booleans, then returns `true` if left or right operands are truthy, otherwise `false`.  
  If at least one operand isn't a boolean then returns first truthy operand else (both operands are truthy) returns the second operand.
  E.g. `false or true; // => true`  
  `true or nil; // => nil`  
  `false or nil; // => nil`  
  `0 or true or ""; // => 0`
- `!`: Performs a logical negation on its operand  
  E.g. `!false; // => true`  
  `!!true; // => true`  
  `!0; // => false`

####  Grouping expressions
Use parentheses `(` `)` for a better control in expression/operator precedence.

``` javascript
print 3 + 4 * 5;  // => 23
print (3 + 4) * 5; // => 35
```

####  Variable expressions and assignments
In __Lox__, a variable expression is nothing than retrieving the value of a variable.
``` javascript
var foo = "bar;" // Variable declaration
print foo;  // Variable expression (= use its value)
foo = "baz"; // Variable assignment
print foo; // Output: baz
```

#### Variable declarations
``` javascript
var iAmAVariable = "my-initial-value";
var iAmNil; // __Lox__ initializes variables to nil by default;
print iAmNil; // output: nil
```

#### For statement

Similar to the `for` statement in `C` language
``` javascript
for (var a = 1; a < 10; a = a + 1) {
  print a; // Output: 123456789
}
```

#### If statement

Based on a given condition, an if statement executes one of two statements:
``` javascript
if (condition) {
print "then-branch";
} else {
print "else-branch";
}
```

As for other languages, the `else` part is optional.
##### Warning: nested `if`...`else`
Call it a bug ... Nested `if` `else` control flow structure aren't yet supported by __Loxxy__.  
The culprit has a name: [the dangling else](https://en.wikipedia.org/wiki/Dangling_else). 

The problem in a nutshell: in a nested if ... else ... statement like this:
``` javascript
'if (true) if (false) print "bad"; else print "good";
```
... there is an ambiguity.  
Indeed, according to the __Lox__ grammar, the `else` could be bound 
either to the first `if` or to the second one.
This ambiguity is usually lifted by applying an ad-hoc rule: an `else` is aways bound to the most 
recent (rightmost) `if`.  
Being a generic parsing library, `Rley` doesn't apply any of these supplemental rules.  
As a consequence,it complains about the found ambiguity and stops the parsing...
Although `Rley` can cope with ambiguities, this requires the use of an advanced data structure
called `Shared Packed Parse Forest (SPPF)`.
SPPF are much more complex to handle than the "common" parse trees present in most compiler or interpreter books.
Therefore, a future version of `Rley` will incorporate the capability to define disambuiguation rules.  

In the meantime, the `Loxxy` will progress on other __Lox__ features like:
- Block structures...
- Iteration structures (`for` and `while` loops)


####  Print Statement

The statement print + expression + ; prints the result of the expression to stdout.

``` javascript
print "Hello, world!";  // Output: Hello, world!

```

####  While Statement

``` javascript
  var a = 1;
  while (a < 10) {
    print a;
    a = a + 1;
  } // Output: 123456789
```

#### Block Statement
__Lox__ has code blocks.
``` javascript
var a = "outer";

{
  var a = "inner";
  print a; // output: inner
}

print a; // output: outer
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
