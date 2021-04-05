# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'Methods' do
  context 'Valid method call:' do
    # rubocop: disable Style/StringConcatenation
    it 'should support methods with different arity' do
      source = <<-LOX_END
        class Foo {
          method0() { return "no args"; }
          method1(a) { return a; }
          method2(a, b) { return a + b; }
          method3(a, b, c) { return a + b + c; }
          method4(a, b, c, d) { return a + b + c + d; }
          method5(a, b, c, d, e) { return a + b + c + d + e; }
          method6(a, b, c, d, e, f) { return a + b + c + d + e + f; }
          method7(a, b, c, d, e, f, g) { return a + b + c + d + e + f + g; }
          method8(a, b, c, d, e, f, g, h) { return a + b + c + d + e + f + g + h; }
        }

        var foo = Foo();
        print foo.method0(); // output: no args
        print foo.method1(1); // output: 1
        print foo.method2(1, 2); // output: 3
        print foo.method3(1, 2, 3); // output: 6
        print foo.method4(1, 2, 3, 4); // output: 10
        print foo.method5(1, 2, 3, 4, 5); // output: 15
        print foo.method6(1, 2, 3, 4, 5, 6); // output: 21
        print foo.method7(1, 2, 3, 4, 5, 6, 7); // output: 28
        print foo.method8(1, 2, 3, 4, 5, 6, 7, 8); // output: 36
      LOX_END
      predicted = 'no args' + '1' + '3' + '6' + '10' + '15' + '21' + '28' + '36'

      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)

      expect(io.string).to eq(predicted)
    end
    # rubocop: enable Style/StringConcatenation

    it 'should accept empty method' do
      source = <<-LOX_END
        class Foo {
          bar() {}
        }

        Foo().bar(); // => nil
      LOX_END
      lox = Loxxy::Interpreter.new
      result = lox.evaluate(source)

      expect(result).to eq(Loxxy::Datatype::Nil.instance)
    end

    it 'should support methods with different arity' do
      source = <<-LOX_END
        class Foo {
          method() { }
        }
        var foo = Foo();
        print foo.method; // expect: <fn method>
      LOX_END
      predicted = '<fn method>'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)

      expect(io.string).to eq(predicted)
    end
  end # context

  context 'Invalid method call:' do
    it 'should complain when calling an unknown method' do
      source = <<-LOX_END
        class Foo {}

        Foo().unknown(); // expect runtime error: Undefined property 'unknown'.
      LOX_END
      lox = Loxxy::Interpreter.new
      err_msg = "Undefined property 'unknown'."
      expect { lox.evaluate(source) }.to raise_error(StandardError, err_msg)
    end

    it 'should complain when calling a method with extra arguments' do
      source = <<-LOX_END
        class Foo {
          method(a, b) {
            print a;
            print b;
          }
        }

        Foo().method(1, 2, 3, 4); // expect runtime error: Expected 2 arguments but got 4.
      LOX_END
      lox = Loxxy::Interpreter.new
      err_msg = 'Expected 2 arguments but got 4.'
      expect { lox.evaluate(source) }.to raise_error(StandardError, err_msg)
    end

    it 'should complain when calling a method with too few arguments' do
      source = <<-LOX_END
        class Foo {
          method(a, b) {}
        }

        Foo().method(1); // expect runtime error: Expected 2 arguments but got 1.
      LOX_END
      lox = Loxxy::Interpreter.new
      err_msg = 'Expected 2 arguments but got 1.'
      expect { lox.evaluate(source) }.to raise_error(StandardError, err_msg)
    end

    it 'should complain when referring a method in its body' do
      source = <<-LOX_END
        class Foo {
          method() {
            print method; // expect runtime error: Undefined variable 'method'.
          }
        }

        Foo().method();
      LOX_END
      lox = Loxxy::Interpreter.new
      err_msg = "Undefined variable 'method'."
      expect { lox.evaluate(source) }.to raise_error(StandardError, err_msg)
    end
  end # context
end # describe
