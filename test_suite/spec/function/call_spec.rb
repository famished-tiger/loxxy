# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid call expressions:' do
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

  context 'Invalid call expressions:' do
    let(:err) { Loxxy::RuntimeError }
    let(:err_msg) { 'Can only call functions and classes.' }

    it 'should complain when calling something else than a function/method' do
      [
        'true();',
        'nil();',
        '123();',
        '"str"();'
      ].each do |source|
        lox = Loxxy::Interpreter.new
        expect { lox.evaluate(source) }.to raise_error(err, err_msg)
      end
    end

    it 'should complain in case of a missing argument' do
      program = <<-LOX_END
        fun f(a, b) {}

        f(1); // expect runtime error: Expected 2 arguments but got 1.
      LOX_END
      lox = Loxxy::Interpreter.new
      msg = 'Expected 2 arguments but got 1.'
      expect { lox.evaluate(program) }.to raise_error(err, msg)
    end

    it 'should complain in case of extra argument(s)' do
      program = <<-LOX_END
        fun f(a, b) {
          print a;
          print b;
        }

        f(1, 2, 3, 4);
      LOX_END
      lox = Loxxy::Interpreter.new
      msg = 'Expected 2 arguments but got 4.'
      expect { lox.evaluate(program) }.to raise_error(err, msg)
    end

    it 'should complain when more than 255 argument are passed' do
      args = +''
      (1..255).each { |i| args << "           a, // #{i}\n" }
      program = <<-LOX_END
      fun foo() {}
      {
        var a = 1;
        foo(
#{args}           a);
      }
      LOX_END
      lox = Loxxy::Interpreter.new
      msg = "Can't have more than 255 arguments."
      expect { lox.evaluate(program) }.to raise_error(err, msg)
    end
  end # context
end # describe
