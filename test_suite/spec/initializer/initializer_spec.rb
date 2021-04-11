# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

# rubocop: disable Style/StringConcatenation
describe 'Initializer' do
  context 'Valid cases:' do
    it 'should accept default constructor' do
      source = <<-LOX_END
        class Foo {}

        var foo = Foo();
        print foo; // output: Foo instance
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq('Foo instance')
    end

    it 'should accept multiple arguments in custom constructor' do
      source = <<-LOX_END
        class Foo {
          init(a, b) {
            print "init"; // output: init
            this.a = a;
            this.b = b;
          }
        }

        var foo = Foo(1, 2);
        print foo.a; // output: 1
        print foo.b; // output: 2
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq('init' + '1' + '2')
    end

    it 'should accept early return in custom constructor' do
      source = <<-LOX_END
        class Foo {
          init() {
            print "init";
            return;
            print "nope";
          }
        }

        var foo = Foo(); // output: init
        print foo.init(); // output: init
        // output: Foo instance
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq('init' + 'init' + 'Foo instance')
    end

    it 'should accept explicit call to initializer' do
      source = <<-LOX_END
        class Foo {
          init(arg) {
            print "Foo.init(" + arg + ")";
            this.field = "init";
          }
        }

        var foo = Foo("one"); // output: Foo.init(one)
        foo.field = "field";

        var foo2 = foo.init("two"); // output: Foo.init(two)
        print foo2; // expect: Foo instance

        // Make sure init() doesn't create a fresh instance.
        print foo.field; // output: init
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      predicted = 'Foo.init(one)' + 'Foo.init(two)' + 'Foo instance' + 'init'
      expect(io.string).to eq(predicted)
    end

    it "should distinguish between initializer and a function called 'init'" do
      source = <<-LOX_END
        class Foo {
          init(arg) {
            print "Foo.init(" + arg + ")";
            this.field = "init";
          }
        }

        fun init() {
          print "not initializer";
        }

        init(); // output: not initializer
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      predicted = 'not initializer'
      expect(io.string).to eq(predicted)
    end

    it 'should accept return in nested function within initializer' do
      source = <<-LOX_END
        class Foo {
          init() {
            fun init() {
              return "bar";
            }
            print init(); // output: bar
          }
        }

        print Foo(); // output: Foo instance
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      lox.evaluate(source)
      predicted = 'bar' + 'Foo instance'
      expect(io.string).to eq(predicted)
    end
  end # context

  context 'Invalid cases:' do
    it 'should complain when default constructor get arguments' do
      source = <<-LOX_END
        class Foo {}

        var foo = Foo(1, 2, 3); // expect runtime error: Expected 0 arguments but got 3.
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      err_msg = 'Expected 0 arguments but got 3.'
      expect { lox.evaluate(source) }.to raise_error(Loxxy::RuntimeError, err_msg)
    end

    it 'should complain when constructor is called with extra argument' do
      source = <<-LOX_END
        class Foo {
          init(a, b) {
            this.a = a;
            this.b = b;
          }
        }

        var foo = Foo(1, 2, 3, 4); // expect runtime error: Expected 2 arguments but got 4.
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      err_msg = 'Expected 2 arguments but got 4.'
      expect { lox.evaluate(source) }.to raise_error(Loxxy::RuntimeError, err_msg)
    end

    it 'should complain when constructor is called with missing argument' do
      source = <<-LOX_END
        class Foo {
          init(a, b) {}
        }

        var foo = Foo(1); // runtime error: Expected 2 arguments but got 1.
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      err_msg = 'Expected 2 arguments but got 1.'
      expect { lox.evaluate(source) }.to raise_error(Loxxy::RuntimeError, err_msg)
    end

    it 'should complain when constructor ends with a return statement' do
      source = <<-LOX_END
        class Foo {
          init() {
            return "result"; // Error at 'return': Can't return a value from an initializer.
          }
        }
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      err_msg = "Error at 'return': Can't return a value from an initializer."
      expect { lox.evaluate(source) }.to raise_error(StandardError, err_msg)
    end
  end # context
end # describe
# rubocop: enable Style/StringConcatenation
