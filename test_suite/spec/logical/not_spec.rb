# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

describe Loxxy do
  context 'Valid ! operator cases:' do
    it 'should evaluate the negation of a value' do
      [
        ['!true;', false],
        ['!false;', true],
        ['!!true;', true],
        ['!123;', false],
        ['!0;', false],
        ['!nil;', true],
        ['!"";', false],
        ["fun foo() {}\n!foo;", false]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result.value == predicted).to be_truthy
      end
    end
  end # context
end # describe
