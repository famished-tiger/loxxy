# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid + operator cases:' do
    it 'should perform the addition of two numbers' do
      [
        ['123 + 456;', 579],
        ['12.5 + 7.5;', 20],
        ['0 + 0;', 0],
        ['1 + -1;', 0],
        ['1 + 2 + 3 + 4;', 10],
        ['1000000 + 0.001;', 1000000.001]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result == predicted).to be_true
      end
    end

    it 'should perform the concatenation of two strings' do
      [
        ['"str" + "ing";', 'string'],
        ['"string" + "";', 'string'],
        ['"" + "";', ''],
        ['"Hello" + ", " + "world!";', 'Hello, world!']
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result == predicted).to be_true
      end
    end
  end # context

  context 'Invalid / operator cases:' do
    let(:err) { Loxxy::RuntimeError }
    let(:err_msg) { 'Operands must be two numbers or two strings.' }

    it "should complain when both operands aren't numbers nor strings" do
      [
        'true + nil;',
        'true + 123;',
        'true + "s";',
        'nil + nil;',
        '1 + nil;',
        '"s" + nil;'
      ].each do |source|
        lox = Loxxy::Interpreter.new
        expect { lox.evaluate(source) }.to raise_error(err, err_msg)
      end
    end
  end # context
end # describe
