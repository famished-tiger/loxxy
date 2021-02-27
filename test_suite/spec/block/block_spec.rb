# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

describe Loxxy do
  context 'Blocks:' do
    it 'should accept empty blocks' do
      source = <<-LOX_END
        {} // Standalone block.

        // Part of a statement.
        if (true) {}
        if (false) {} else {}
LOX_END
      lox = Loxxy::Interpreter.new
      expect { lox.evaluate(source) }.not_to raise_error
    end

    it 'should support nested block scopes' do
      source = <<-LOX_END
        var a = "outer";

        {
          var a = "inner";
          print a; // expect: inner
        }

        print a; // expect: outer
LOX_END
      predicted = 'innerouter'

      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq(predicted)
    end
  end # context
end # describe
