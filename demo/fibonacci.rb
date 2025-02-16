# frozen_string_literal: true

require 'loxxy'

lox_program = <<LOX_END
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
LOX_END

lox = Loxxy::Interpreter.new
lox.evaluate(lox_program) # => 0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181
