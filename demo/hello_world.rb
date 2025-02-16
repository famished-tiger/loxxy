# frozen_string_literal: true

require 'loxxy'

lox_program = <<LOX_END
  // Your first Lox program!
  print "Hello, world!";
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # => Hello, world!
