# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

describe Loxxy do
  context 'Constructor:' do
    it 'should accept default constructor' do
      source = <<-LOX_END
        class Foo {}

        var foo = Foo();
        print foo; // output: Foo instance
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      lox = Loxxy::Interpreter.new(cfg)
      lox.evaluate(source)
      expect(io.string).to eq('Foo instance')
    end
  end # context
end # describe
