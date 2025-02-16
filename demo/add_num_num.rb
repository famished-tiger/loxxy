# frozen_string_literal: true

require 'loxxy'

lox_program = <<LOX_END
  // Let's show the result of an addition
  print 37 + 5;
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # Output: 42
