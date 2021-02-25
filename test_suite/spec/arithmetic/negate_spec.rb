# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid -@ operator cases:' do
    it 'should perform the substraction of two numbers' do
      [
        ['-(3);', -3],
        ['--(3);', 3],
        ['---(3);', 3],
        ['-(0);', 0]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result == predicted).to be_true
      end
    end
  end # context

  context 'Invalid -@ operator cases:' do
    let(:err) { Loxxy::RuntimeError }
    let(:err_msg) { 'Operand must be a number.' }

    it "should complain when both operands aren't numbers" do
      [
        '-"1"'
      ].each do |source|
        lox = Loxxy::Interpreter.new
        expect { lox.evaluate(source) }.to raise_error(err, err_msg)
      end
    end
  end # context
end # describe
