# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'this:' do
  context 'Valid cases:' do
    it "should return current instance where 'this' occurs in source" do
      lox_snippet = <<-LOX_END
        class Foo {
          bar() { return this; }
          baz() { return "baz"; }
        }

        print Foo().bar().baz(); // expect: baz
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('baz')
    end

    it "should allow 'this' function nested in method" do
      lox_snippet = <<-LOX_END
        class Foo {
          getClosure() {
            fun closure() {
              return this.toString();
            }
            return closure;
          }

          toString() { return "bar"; }
        }

        var closure = Foo().getClosure();
        print closure(); // output: bar
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('bar')
    end

    # rubocop: disable Style/StringConcatenation
    it 'should implement this in nested classes' do
      lox_snippet = <<-LOX_END
        class Outer {
          method() {
            print this; // output: Outer instance

            fun f() {
              print this; // output: Outer instance

              class Inner {
                method() {
                  print this; // output: Inner instance
                }
              }

              Inner().method();
            }
            f();
          }
        }

        Outer().method();
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = ('Outer instance' * 2) + 'Inner instance'
      expect(io.string).to eq(predicted)
    end
    # rubocop: enable Style/StringConcatenation

    it 'should support this in function nested in methods' do
      lox_snippet = <<-LOX_END
        class Foo {
          getClosure() {
            fun f() {
              fun g() {
                fun h() {
                  return this.toString();
                }
                return h;
              }
              return g;
            }
            return f;
          }

          toString() { return "foo"; }
        }

        var closure = Foo().getClosure();
        print closure()()(); // output: foo
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = 'foo'
      expect(io.string).to eq(predicted)
    end
  end # context

  context 'Invalid - return cases:' do
    it 'should complain when this occurs at top-level scope' do
      lox_snippet = <<-LOX_END
        this; // Error at 'this': Can't use 'this' outside of a class.
      LOX_END
      lox = Loxxy::Interpreter.new
      err = StandardError
      err_msg = "Error at 'this': Can't use 'this' outside of a class."
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end

    it 'should complain when a this occurs in a top-level function' do
      lox_snippet = <<-LOX_END
        fun foo() {
          this; // Error at 'this': Can't use 'this' outside of a class.
        }
      LOX_END
      lox = Loxxy::Interpreter.new
      err = StandardError
      err_msg = "Error at 'this': Can't use 'this' outside of a class."
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end
  end # context
end # describe
