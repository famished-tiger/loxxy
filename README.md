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
- [STARTED] Recognizer
- [TODO] Parser
- [TODO] Interpreter or transpiler


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
