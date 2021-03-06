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

        print fib(8); // Output: 2// 21
      LOX_END
      predicted = '21'

      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq(predicted)
    end

    it 'should support local recursive functions' do
      source = <<-LOX_END
      {
        fun fib(n) {
          if (n < 2) return n;
          return fib(n - 1) + fib(n - 2);
        }

        print fib(8); // expect: 21
      }
      LOX_END
      predicted = '21'

      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq(predicted)
    end

    # rubocop: disable Style/StringConcatenation
    it 'should support mutual recursive functions' do
      source = <<-LOX_END
        fun isEven(n) {
          if (n == 0) return true;
          return isOdd(n - 1);
        }

        fun isOdd(n) {
          if (n == 0) return false;
          return isEven(n - 1);
        }

        print isEven(4); // output: true
        print isOdd(3); // output: true
      LOX_END
      predicted = 'true' + 'true'

      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq(predicted)
    end
    # rubocop: enable Style/StringConcatenation
  end # context
end # describe
