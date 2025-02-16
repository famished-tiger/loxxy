# frozen_string_literal: true

require 'loxxy'

# literal        → NUMBER | STRING | "true" | "false" | "nil" ;

lox_input = <<-LOX_END
  true;
LOX_END

# Show that the raw parser accepts the above program
base_parser = Loxxy::FrontEnd::RawParser.new

# Now parse the input into a concrete parse tree...
ptree = base_parser.parse(lox_input)

# Display the parse tree thanks to Rley utility classes...
visitor = Rley::ParseTreeVisitor.new(ptree)
tree_formatter = Rley::Formatter::Asciitree.new($stdout)
tree_formatter.render(visitor)
