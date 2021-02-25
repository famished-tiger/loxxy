# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid != operator cases:' do
    it 'should perform the inequality test of two values' do
      [
        ['nil != nil;', false],
        ['true != true;', false],
        ['true != false;', true],
        ['1 != 1;', false],
        ['1 != 2;', true],
        ['0 != 0;', false],
        ['"str" != "str";', false],
        ['"str" != "ing";', true],
        ['"" != "";', false],
        ['nil != false;', true],
        ['false != 0;', true],
        ['0 != "0";', true]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result.value == predicted).to be_truthy
      end
    end
  end # context
end # describe
