# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid <= operator cases:' do
    it 'should perform the greater than tests of two values' do
      [
        ['1 <= 2;', true],
        ['2 <= 2;', true],
        ['2 <= 1;', false],
        ['0 <= -0;', true],
        [' -0 <= 0;', true]        
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result.value == predicted).to be_truthy
      end
    end
  end # context

  context 'Invalid <= operator cases:' do
    let(:err) { Loxxy::RuntimeError }
    let(:err_msg) { 'Operands must be numbers.' }

    it "should complain when both operands aren't numbers" do
      [
        '"1" <= 1;',
        '1 <= "1";'
      ].each do |source|
        lox = Loxxy::Interpreter.new
        expect { lox.evaluate(source) }.to raise_error(err, err_msg)
      end
    end
  end # context  
=begin
print 1 < 2;    // expect: true
print 2 < 2;    // expect: false
print 2 < 1;    // expect: false

// Zero and negative zero compare the same.
print 0 < -0; // expect: false
print -0 < 0; // expect: false
=end
end # describe
