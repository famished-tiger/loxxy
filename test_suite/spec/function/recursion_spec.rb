# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Recursion:' do
    it 'should support first-order recursive functions' do
      program = <<-LOX_END
        fun fact(n) {
          if (n < 2) return 1;

          return n * fact(n - 1);
        }

        fact(5);
      LOX_END
      lox = Loxxy::Interpreter.new
      result = lox.evaluate(program)
      expect(result).to eq(120)
    end

    it 'should support second-order recursive function' do
      source = <<-LOX_END
        fun fib(n) {
          if (n < 2) return n;
          return fib(n - 1) + fib(n - 2);
        }

        print fib(3); // Output: 2// 21
      LOX_END
      predicted = '2' # '21'

      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq(predicted)
    end
  end # context
end # describe
