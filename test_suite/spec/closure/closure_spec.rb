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
  end # context
  # rubocop: enable Style/StringConcatenation
end # describe
