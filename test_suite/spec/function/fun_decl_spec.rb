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
end # describe
