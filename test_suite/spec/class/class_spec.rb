# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

describe Loxxy do
  context 'Classes:' do
    it 'should accept empty classes' do
      source = <<-LOX_END
        class Foo {}

        print Foo; // output: Foo
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq('Foo')
    end
  end # context
end # describe
