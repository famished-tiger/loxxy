# frozen_string_literal: true

require_relative 'spec_helper' # Use the RSpec framework
require 'stringio'

# Load the class under test
require_relative '../lib/loxxy/interpreter'

module Loxxy
  # This spec contains the bare bones test for the Interpreter class.
  # The execution of Lox code is tested elsewhere.
  describe Interpreter do
    let(:sample_cfg) do
      { ostream: StringIO.new }
    end
    subject { Interpreter.new(sample_cfg) }

    context 'Initialization:' do
      it 'should accept a option Hash at initialization' do
        expect { Interpreter.new(sample_cfg) }.not_to raise_error
      end

      it 'should know its config options' do
        expect(subject.config).to eq(sample_cfg)
      end
    end # context

    context 'Evaluating Lox code:' do
      let(:hello_world) { 'print "Hello, world!";' }

      it 'should evaluate core data types' do
        result = subject.evaluate('true; // Not false')
        expect(result).to be_kind_of(Loxxy::Datatype::True)
      end

      it 'should evaluate arithmetic operation' do
        result = subject.evaluate('123 + 456; // => 579')
        expect(result).to be_kind_of(Loxxy::Datatype::Number)
        expect(result == 579).to be_true
      end

      it 'should evaluate string concatenation' do
        result = subject.evaluate('"str" + "ing"; // => "string"')
        expect(result).to be_kind_of(Loxxy::Datatype::LXString)
        expect(result == 'string').to be_true
      end

      it 'should print the hello world message' do
        expect { subject.evaluate(hello_world) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('Hello, world!')
      end
    end # context
  end # describe
end # module
