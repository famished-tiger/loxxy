# Loxxy

A Ruby implementation of the [Lox programming language](https://craftinginterpreters.com/the-lox-language.html),
a simple language used in Bob Nystrom's online book [Crafting Interpreters](https://craftinginterpreters.com/).

## Purpose of this project:
- To deliver an open source example of a programming language fully implemented in Ruby  
  (from the scanner, parser, code generation).
- The implementation should be mature enough to run (LoxLox)[https://github.com/benhoyt/loxlox],  
  a Lox interpreter written in Lox.

## Roadmap
- [DONE] Scanner (tokenizer)
- [DONE] Raw parser. It parses Lox programs and generates a parse tree.
- [TODO] Tailored parser for generating AST (Abstract Syntax Tree)
- [TODO] Interpreter or transpiler


## Example
At this, stage, the raw parser is able to recognize Lox input and to generate
a concrete parse tree from it.

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
+-- declaration_star
|   +-- declaration_star
|   +-- declaration
|       +-- statement
|           +-- printStmt
|               +-- PRINT: 'print'
|               +-- expression
|               |   +-- assignment
|               |       +-- logic_or
|               |           +-- logic_and
|               |           |   +-- equality
|               |           |   |   +-- comparison
|               |           |   |   |   +-- term
|               |           |   |   |   |   +-- factor
|               |           |   |   |   |   |   +-- unary
|               |           |   |   |   |   |   |   +-- call
|               |           |   |   |   |   |   |       +-- primary
|               |           |   |   |   |   |   |       |   +-- STRING: '"Hello, world!"'
|               |           |   |   |   |   |   |       +-- refinement_star
|               |           |   |   |   |   |   +-- multiplicative_star
|               |           |   |   |   |   +-- additive_star
|               |           |   |   |   +-- comparisonTest_star
|               |           |   |   +-- equalityTest_star
|               |           |   +-- conjunct_star
|               |           +-- disjunct_star
|               +-- SEMICOLON: ';'
+-- EOF: ''
```

Soon, the `loxxy` will host another, tailored parser, that will generate
abstract syntax tree which much more convenient for further processing 
(like implementing an interpreter).

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
An impressive list of Lox implementations can be found [here](https://github.com/munificent/craftinginterpreters/wiki/Lox-implementations

For Ruby, ther is the [lox](https://github.com/rdodson41/ruby-lox) gem.
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
