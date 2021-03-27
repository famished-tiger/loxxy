# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  # rubocop: disable Style/StringConcatenation
  context 'Closure:' do
    it 'should support assignment of closures' do
      program = <<-LOX_END
        var f;
        var g;

        {
          var local = "local";
          fun f_() {
            print local;
            local = "after f";
            print local;
          }
          f = f_;

          fun g_() {
            print local;
            local = "after g";
            print local;
          }
          g = g_;
        }

        f();
        // expect: local
        // expect: after f

        g();
        // expect: after f
        // expect: after g
      LOX_END
      predicted = 'local' + 'after f' + 'after f' + 'after g'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)
      expect(io.string).to eq(predicted)
    end

    it 'should handle nested scopes and closures' do
      program = <<-LOX_END
        var a = "global";

        {
          fun assign() {
            a = "assigned";
          }

          var a = "inner";
          assign();
          print a; // expect: inner
        }

        print a; // expect: assigned
      LOX_END
      predicted = 'inner' + 'assigned'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should handle assignment to closure' do
      program = <<-LOX_END
        var f;

        fun foo(param) {
          fun f_() {
            print param;
          }
          f = f_;
        }
        foo("param");

        f(); // output: param
      LOX_END
      predicted = 'param'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should support the use of multiple variables by closure' do
      program = <<-LOX_END
        fun f() {
          var a = "a";
          var b = "b";
          fun g() {
            print b; // output: b
            print a; // output: a
          }
          g();
        }
        f();
      LOX_END
      predicted = 'b' + 'a'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should support closures referencing variables from enclosing scope' do
      program = <<-LOX_END
        var f;

        {
          var local = "local";
          fun f_() {
            print local;
          }
          f = f_;
        }

        f(); // output: local
      LOX_END
      predicted = 'local'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should support nested closures' do
      program = <<-LOX_END
        var f;

        fun f1() {
          var a = "a";
          fun f2() {
            var b = "b";
            fun f3() {
              var c = "c";
              fun f4() {
                print a;
                print b;
                print c;
              }
              f = f4;
            }
            f3();
          }
          f2();
        }
        f1();

        f();
        // output: a
        // output: b
        // output: c
      LOX_END
      predicted = 'a' + 'b' + 'c'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should support top-level closure' do
      program = <<-LOX_END
        {
          var local = "local";
          fun f() {
            print local; // output: local
          }
          f();
        }
      LOX_END
      predicted = 'local'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should support multiple use of a variable in a function' do
      program = <<-LOX_END
        var f;

        {
          var a = "a";
          fun f_() {
            print a;
            print a;
          }
          f = f_;
        }

        f();
        // output: a
        // output: a
      LOX_END
      predicted = 'a' + 'a'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should separate variables from different scopes' do
      program = <<-LOX_END
        {
          var f;

          {
            var a = "a";
            fun f_() { print a; }
            f = f_;
          }

          {
            // Since a is out of scope, the local slot will be reused by b. Make sure
            // that f still closes over a.
            var b = "b";
            f(); // expect: a
          }
        }
      LOX_END
      predicted = 'a'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should handle the shadowing of variables' do
      program = <<-LOX_END
        {
          var foo = "closure";
          fun f() {
            {
              print foo; // output: closure
              var foo = "shadow";
              print foo; // output: shadow
            }
            print foo; // output: closure
          }
          f();
        }
      LOX_END
      predicted = 'closure' + 'shadow' + 'closure'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should cause exception when a function declaration is on dead branch' do
      program = <<-LOX_END
        {
          var a = "a";
          if (false) {
            fun foo() { a; }
          }
        }

        print "ok"; // output: ok
      LOX_END
      predicted = 'ok'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end

    it 'should not be fooled by dead branch' do
      program = <<-LOX_END
        var closure;

        {
          var a = "a";

          {
            var b = "b";
            fun returnA() {
              return a;
            }

            closure = returnA;

            if (false) {
              fun returnB() {
                return b;
              }
            }
          }

          print closure(); // output: a
        }
      LOX_END
      predicted = 'a'
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(program)

      expect(io.string).to eq(predicted)
    end
  end # context
  # rubocop: enable Style/StringConcatenation
end # describe
