# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid function declarations:' do
    it 'should evaluate empty function' do
      [
        ["fun f() {}\nprint f();", nil]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result == predicted).to be_true
      end
    end
  end # context

  context 'Function object behavior:' do
    it 'should respond to print request' do
      source = <<-LOX_END
        fun foo() {}
        print foo; // expect: <fn foo>
LOX_END
      predicted = '<fn foo>'

      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq(predicted)
    end

    it 'should respond as native function to print request' do
      source = 'print clock; // expect: <native fn>'
      predicted = '<native fn>'

      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq(predicted)
    end
  end # context

  context 'Function object behavior:' do
    it 'should accept functions with multiple arguments' do
      [
        ["fun f0() { return 0; } \nf0();", 0],
        ["fun f1(a) { return a; } \nf1(1);", 1],
        ["fun f2(a, b) { return a + b; } \nf2(1, 2);", 3],
        ["fun f3(a, b, c) { return a + b + c; } \nf3(1, 2, 3);", 6],
        ["fun f4(a, b, c, d) { return a + b + c + d; } \nf4(1, 2, 3, 4);", 10],
        ["fun f5(a, b, c, d, e) { return a + b + c + d + e; } \nf5(1, 2, 3, 4, 5);", 15],
        ["fun f6(a, b, c, d, e, f) { return a + b + c + d + e + f; } \nf6(1, 2, 3, 4, 5, 6);", 21],
        ["fun f7(a, b, c, d, e, f, g) { return a + b + c + d + e + f + g; } \nf7(1, 2, 3, 4, 5, 6, 7);", 28],
        ["fun f8(a, b, c, d, e, f, g, h) { return a + b + c + d + e + f + g + h; } \nf8(1, 2, 3, 4, 5, 6, 7, 8);", 36]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result == predicted).to be_true
      end
    end
  end # context
end # describe
