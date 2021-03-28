# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid - return cases:' do
    it 'should support return in if branch' do
      lox_snippet = <<-LOX_END
        fun f() {
          if (true) return "ok";
        }

        f(); // returns: ok
      LOX_END
      lox = Loxxy::Interpreter.new
      result = lox.evaluate(lox_snippet)
      expect(result.value).to eq('ok')
    end

    it 'should support return in else branch' do
      lox_snippet = <<-LOX_END
        fun f() {
          if (false) "no"; else return "ok";
        }

        f(); // returns: ok
      LOX_END
      lox = Loxxy::Interpreter.new
      result = lox.evaluate(lox_snippet)
      expect(result.value).to eq('ok')
    end

    it 'should support return in while statement' do
      lox_snippet = <<-LOX_END
        fun f() {
          while (true) return "ok";
        }

        f(); // returns: ok
      LOX_END
      lox = Loxxy::Interpreter.new
      result = lox.evaluate(lox_snippet)
      expect(result.value).to eq('ok')
    end

    it 'should ignore statements after return in a function' do
      lox_snippet = <<-LOX_END
        fun f() {
          return "ok";
          print "ignored";
        }

        print f(); // output: ok
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('ok')
    end

    it 'should return nil if no explicit value given' do
      lox_snippet = <<-LOX_END
        fun f() {
          return;
          print "ignored";
        }

        print f(); // output: nil
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('nil')
    end
  end # context

  context 'Invalid - return cases:' do
    it 'should complain when a return occurs at top-level scope' do
      lox_snippet = <<-LOX_END
        return "wrong"; // Error at 'return': Can't return from top-level code.
      LOX_END
      lox = Loxxy::Interpreter.new
      err = StandardError
      err_msg = "Error at 'return': Can't return from top-level code."
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end
  end # context
end # describe
