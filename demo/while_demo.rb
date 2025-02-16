# frozen_string_literal: true

require 'loxxy'

lox_program = <<LOX_END
  var a = 1;
  while (a < 10) {
    print a;
    a = a + 1;
  }
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # Output:123456789