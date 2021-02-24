# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid / operator cases:' do
    it 'should perform the division of two numbers' do
      [
        ['8 / 2;', 4],
        ['8 / -2;', -4],
        ['12.34 / 12.34;', 1],
        ['20 / 5 / 2;', 2]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result == predicted).to be_true
      end
    end
  end # context

  context 'Invalid / operator cases:' do
    let(:err) { Loxxy::RuntimeError }
    let(:err_msg) { 'Operands must be numbers.' }

    it "should complain if numerator isn't a number" do
      source = '"1" / 1;'
      lox = Loxxy::Interpreter.new
      expect { lox.evaluate(source) }.to raise_error(err, err_msg)
    end

    it "should complain if denominator isn't a number" do
      source = '1 / "1";'
      lox = Loxxy::Interpreter.new
      expect { lox.evaluate(source) }.to raise_error(err, err_msg)
    end
  end # context
end # describe
