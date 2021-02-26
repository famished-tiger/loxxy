# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

describe Loxxy do
  context 'Valid and operator cases:' do
    it 'should perform the greater than tests of two values' do
      [
        # Return the first non-true argument
        ['false and 1;', false],
        ['1 and 2 and false;', false],

        # Return the last argument if all are true
        ['true and 1;', 1],
        ['1 and true;', true],
        ['1 and 2 and 3;', 3]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result.value == predicted).to be_truthy
      end
    end

    it 'should perform short cicuit evaluation' do
      lox_snippet = <<-LOX_END
        // Short-circuit at the first false argument.
        var a = "before";
        var b = "before";
        (a = true) and
            (b = false) and
            (a = "bad");
        print a; // expect: true
        print b; // expect: false
LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(lox_snippet)
      predicted = 'truefalse'
      expect(io.string).to eq(predicted)
    end
  end # context

  # context 'Invalid < operator cases:' do
    # let(:err) { Loxxy::RuntimeError }
    # let(:err_msg) { 'Operands must be numbers.' }

    # it "should complain when both operands aren't numbers" do
      # [
        # '"1" < 1;',
        # '1 < "1";'
      # ].each do |source|
        # lox = Loxxy::Interpreter.new
        # expect { lox.evaluate(source) }.to raise_error(err, err_msg)
      # end
    # end
  # end # context
end # describe
