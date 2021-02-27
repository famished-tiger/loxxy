# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe Loxxy do
  context 'Valid call expressions:' do
    it 'should evaluate empty function' do
      [
        ["fun f() {}\nprint f();", nil]
      ].each do |(source, predicted)|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(source)
        expect(result == predicted).to be_true
      end
    end
  end # context

  context 'Invalid call expressions:' do
    let(:err) { Loxxy::RuntimeError }
    let(:err_msg) { 'Can only call functions and classes.' }

    it 'should complain when calling something else than a function/method' do
      [
        'true();',
        'nil();',
        '123();',
        '"str"();'
      ].each do |source|
        lox = Loxxy::Interpreter.new
        expect { lox.evaluate(source) }.to raise_error(err, err_msg)
      end
    end
  end # context
end # describe
