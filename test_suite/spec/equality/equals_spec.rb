# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid == operator cases:' do
    it 'should perform the equality tests of two values' do
      [
        ['nil == nil;', true],
        ['true == true;', true],
        ['true == false;', false],
        ['1 == 1;', true],
        ['1 == 2;', false],
        ['0 == 0;', true],
        ['"str" == "str";', true],
        ['"str" == "ing";', false],
        ['"" == "";', true],
        ['nil == false;', false],
        ['false == 0;', false],
        ['0 == "0";', false]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result.value == predicted).to be_truthy
      end
    end
  end # context
end # describe
