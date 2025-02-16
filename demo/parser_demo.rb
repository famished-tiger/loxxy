# frozen_string_literal: true

require 'loxxy'


lox_input = <<-LOX_END
  // Your first Lox program!
  print "Hello, world!";
LOX_END

# Show that the parser accepts the above program
parser = Loxxy::FrontEnd::Parser.new

# Now parse the input into an abstract parse tree...
ptree = parser.parse(lox_input)

# Display the parse tree thanks to Rley utility classes...
visitor = Rley::ParseTreeVisitor.new(ptree)
tree_formatter = Rley::Formatter::Asciitree.new($stdout)
tree_formatter.render(visitor)
