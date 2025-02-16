# frozen_string_literal: true

require 'loxxy'

lox_program = <<LOX_END
  fun add4(n) {
    n + 4;
  }

  print add4(6); // Output: 10
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # => 10