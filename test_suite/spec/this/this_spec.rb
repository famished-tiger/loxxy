# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'this:' do
  context 'Valid cases:' do
    it 'should return current instance when this occurs' do
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

    it 'should support this in a function nested in a method' do
      # TODO: make this test pass
      # lox_snippet = <<-LOX_END
      #   class Foo {
      #     getClosure() {
      #       fun closure() {
      #         return this.toString();
      #       }
      #       return closure;
      #     }
      #
      #     toString() { return "foo"; }
      #   }
      #
      #   var closure = Foo().getClosure();
      #   print closure(); // output: foo
      # LOX_END
      # io = StringIO.new
      # lox = Loxxy::Interpreter.new({ ostream: io })
      # expect { lox.evaluate(lox_snippet) }.not_to raise_error
      # expect(io.string).to eq('foo')
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