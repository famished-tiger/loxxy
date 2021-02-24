# frozen_string_literal: true

require 'loxxy'
require_relative 'spec_helper'
require 'stringio'

describe 'Loxxy::Interpreter' do
  let(:output) { StringIO.new }
  it 'should execute the hello world program' do
    lox = Loxxy::Interpreter.new(ostream: output)
    program = <<-LOX_END
    // Your first Lox program
    print "Hello, world!";
LOX_END
    result = lox.evaluate(program)

    # Check that print has no return value
    expect(result).to eq(Loxxy::lox_nil)

    expect(output.string).to eq('Hello, world!')
  end
end # describe
