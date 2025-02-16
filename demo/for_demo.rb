# frozen_string_literal: true

require 'loxxy'

lox_program = <<LOX_END
  for (var a = 1; a < 10; a = a + 1) {
    print a;
  }
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # Output:123456789