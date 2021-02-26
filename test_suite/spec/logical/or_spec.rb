# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

describe Loxxy do
  context 'Valid or operator cases:' do
    it 'should evaluate the disjunction of two values' do
      [
        # Return the first true argument
        ['1 or true;', 1],
        ['false or 1;', 1],
        ['false or false or true;', true],

        # Return the last argument if all are falsey
        ['false or false;', false],
        ['false or false or false;', false],
        ['false or nil;', nil]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result.value == predicted).to be_truthy
      end
    end

    it 'should handle disjuncts with falsey values' do
      [
        # false and nil are falsey...
        ['false or "ok";', 'ok'],
        ['nil or "ok";', 'ok'],

        # ... everything else is truthy
        ['true or "ok";', true],
        ['0 or "ok";', 0],
        ['"s" or "ok";', 's']
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result.value == predicted).to be_truthy
      end
    end

    it 'should perform short cicuit evaluation' do
      lox_snippet = <<-LOX_END
        // Short-circuit at the first true argument.
        var a = "before";
        var b = "before";
        (a = false) or
            (b = true) or
            (a = "bad");
        print a; // expect: false
        print b; // expect: true
LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(lox_snippet)
      predicted = 'falsetrue'
      expect(io.string).to eq(predicted)
    end
  end # context
end # describe
