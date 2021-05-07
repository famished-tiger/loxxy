# loxxy
[![Gem Version](https://badge.fury.io/rb/loxxy.svg)](https://badge.fury.io/rb/loxxy)
[![Build status](https://ci.appveyor.com/api/projects/status/8e5p7dgjanm0qjkp?svg=true)](https://ci.appveyor.com/project/famished-tiger/loxxy)
[![License](https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat)](https://github.com/famished-tiger/loxxy/blob/main/LICENSE.txt)

## What is loxxy?
A Ruby implementation of the [Lox programming language](https://craftinginterpreters.com/the-lox-language.html ),
a simple language defined in Bob Nystrom's excellent online book [Crafting Interpreters](https://craftinginterpreters.com/ ).

Although __Lox__ is fairly simple, it is far from being a toy language:
- Dynamically typed,
- Provides data types such as booleans, number, strings,
- Supports arithmetic operations (+, -, *, / ) and comparison ( >, >= , <, <=)
- Implements equality operators (==, !=) and the logical connectors `and` and `or`.
- Control flow statements `if`, `for` and `while`
- Functions and closures
- Object-orientation (classes, methods, inheritance).

### Loxxy gem features
- Complete tree-walking interpreter including lexer, parser and resolver
- 100% pure Ruby with clean design (not a port from some other language)
- Passes the `jox` (THE reference `Lox` implementation) test suite  
- Minimal runtime dependency (Rley gem). Won't drag a bunch of gems...  
- Ruby API for integrating a Lox interpreter with your code.
- A command-line interpreter `loxxy`
- Open for your language extensions...

### Why `Loxxy` ?
- If programming languages are one of your subject interest...
- ... and you wanted learn how to implement one in Ruby...
- ... then `Loxxy` can help to understand and experiment in this rewarding craft.

## How to start in 1, 2, 3...?
... in less than 3 minutes...

### 1. Installing
__Loxxy__'s  installation is pretty standard:


    $ gem install loxxy

Alternatively, you can install `loxxy` with Bundler.  
Add this line to your application's Gemfile:

    gem 'loxxy'

And then execute:

    $ bundle



### 2. Your first `Lox`  program
Create a text file and enter the following lines:
```javascript
// Your firs Lox program
print "Hello, world.";
```

### 3. Running your program...
Assuming that you named the file `hello.lox`, launch the `Loxxy` interpreter in same directory:

    $ loxxy hello.lox

Lo and behold! The output device displays the famous greeting:

    Hello, world.
 

Congrats! You ran your first `Lox` program thanks __Loxxy__ gem. 
For a less superficial encounter with the language jump to the next section.

## So you want something beefier?...
Let's admit it, the hello world example was unimpressive.   
To a get a taste of `Lox` object-oriented capabilities, let's try another `Hello world` variant:

```javascript
// Object-oriented hello world
class Greeter {
  // in Lox, initializers/constructors are named `init`
  init(who) {
    this.interjection = "Hello";
    this.subject = who;
  }

  greeting() {
    this.interjection + ", " + this.subject + ".";
  }
}

var greeter = Greeter("world"); // an instance is created here...
print greeter.greeting();
```

Running this version will result in the same famous greeting.

Our next assignment: compute the first 20 elements of the Fibbonacci sequence.  
Here's an answer using the `while` loop construct:

```javascript
// Compute the first 20 elements from the Fibbonacci sequence

var a = 0;  // Use the var keyword to declare a new variable
var b = 1;
var count = 20;

while (count > 0) {
  print a;
  print " ";
  var tmp = a;
  a = b;
  b = tmp + b;
  count = count - 1;
}
```

Assuming, that this source code was put in a file named `fibbonacci.lox`, then
the command line

    $ loxxy fibbonacci.lox

Results in:

    0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181
 
Fans of `for` loops will be pleased to find their favorite looping construct.  
Here again, the Fibbonacci sequence refactored with a `for` loop:

```javascript
// Fibbonacci sequence - version 2
var a = 0;
var b = 1;
var count = 20;

for (var i = 0; i < count; i = i + 1) {
  print a;
  print " ";
  var tmp = a;
  a = b;
  b = tmp + b;
}
```
Lets's call this file `fibbonacci_v2.lox` and execute it thanks `loxxy` CLI:

    $ loxxy fibbonacci_v2.lox

We see again the same sequence:

    0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181

To complete our quick tour of `Lox` language, let's calculate the sequence with a recursive function:

```javascript
// Fibbonacci sequence - version 3
var count = 20;

// Let's define a recursive function
fun fib(n) {
  if (n < 2) return n;
  return fib(n - 1) + fib(n - 2);
}

// For demo purposes, let's assign the function to a variable
var fib_fun = fib;

for (var i = 0; i < count; i = i + 1) {
  print fib_fun(i);
  print " ";
}
```

This completes our quick tour of `Lox`, to learn more about the language,
check the online book [Crafting Interpreters](https://craftinginterpreters.com/ )

## What's the fuss about Lox?
... Nothing...  
Bob Nystrom designed a language __simple__ enough so that he could present
two implementations (an interpreter, then a compiler) in one single book.

In other words, __Lox__ contains interesting features found in most general-purpose
languages. In addition to that, there are [numerous implementations](https://github.com/munificent/craftinginterpreters/wiki/Lox-implementations) in different languages 

Lox interpreters, like `Loxxy` give the unique opportunity for the curious to learn the internals of reasonably-sized language.

### What's missing in Lox?
While `Lox` blends interesting features from the two mainstream paradigms (OO and functional),
it doesn't pretend to be used in real-life projects.

In fact, the language was designed to be simple to implement at the expense of missing advanced features.  
Here are features I'll like to put on my wish list:
- Collection classes (e.g. Arrays, Maps (Hash))
- Modules  
- Standard library
- Concurrency / parallelism constructs

That `Lox` cannot be compared to a full-featured language, is both a drawback and and an opportunity.
Indeed, an open-source language that misses some features is an invitation for the curious to tinker and experiment with extensions.
There are already a number of programming languages derived from `Lox`...

## Why `Loxxy`? What's in it for me?...

### Purpose of this project:
- To deliver an open source example of a programming language fully implemented in Ruby  
  (from the scanner and parser to an interpreter).
- The implementation should be mature enough to run [LoxLox](https://github.com/benhoyt/loxlox),  
  a Lox interpreter written in Lox.
  
### Roadmap
- Extend the test suite
- Improve the error handling  
- Improve the documentation
- Ability run the LoxLox interpreter

## Hello world example
The next examples show how to use the interpreter directly from Ruby code.

```ruby
require 'loxxy'

lox_program = <<LOX_END
  // Your first Lox program!
  print "Hello, world!";
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # Output: Hello, world!
```

## A function definition example
```ruby
require 'loxxy'

lox_program = <<LOX_END
  fun add4(n) {
    n + 4;
  }

  print add4(6); // Output: 10
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # Output 10
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



## Suppported Lox language features


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
- [Function declaration](#func-statement)

### Comments

Loxxy supports single line C-style comments.

```javascript
// single line comment
```

### Keywords
Loxxy implements the following __Lox__ reserved keywords:
```lang-none
and, class, else, false, for, fun, if,
nil, or, print, return, this, true, var, while
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
  -[Function call](#function-call)

-[Variable declarations](#var-statement)  
-[If Statement](#if-statement)  
-[Print Statement](#print-statement)  
-[While Statement](#while-statement)  
-[Block Statement](#block-statement)  
-[Function Declaration](#function-declaration)

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

#### Function call
``` javascript
// Calling a function without argument
print clock();

// Assumption: there exists a function `add` that takes two arguments
print add(2, 3);
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

#### Function Declaration
The keyword `fun` is used to begin a function declaration.
In __Lox__ a function has a name and a body (which may be empty).

``` javascript
fun add4(n) // `add4` will be the name of the function
{
  n + 4;
}

print add4(6); // output: 10
```



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
