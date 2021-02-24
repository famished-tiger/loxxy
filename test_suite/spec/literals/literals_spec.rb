# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

describe Loxxy do
  context 'Core data types implementation:' do
    it 'should evaluate true literal' do
      lox = Loxxy::Interpreter.new
      result = lox.evaluate('true; // Not false')
      expect(result).to eq(Loxxy::lox_true)
    end

    it 'should evaluate false literal' do
      lox = Loxxy::Interpreter.new
      result = lox.evaluate('false; // Not *not* false')
      expect(result).to eq(Loxxy::lox_false)
    end



    it 'should evaluate number literals' do
      %w[1234 12.34 -0.1 0.0001 12.0].each do |num|
        lox = Loxxy::Interpreter.new
        result = lox.evaluate("#{num};")
        expect(result).to be_kind_of(Loxxy::Datatype::Number)
        expect(result.value).to eq(num.to_f)
      end
    end

    it 'should evaluate string literals' do
      ['I am a string',
        '',
        '123'].each do |str|
        program = %Q("#{str}";)
        lox = Loxxy::Interpreter.new
        result = lox.evaluate(program)
        expect(result).to be_kind_of(Loxxy::Datatype::LXString)
        expect(result.value).to eq(str)
      end
    end

    it 'should evaluate nil literal' do
      lox = Loxxy::Interpreter.new
      result = lox.evaluate('nil;')
      expect(result).to eq(Loxxy::lox_nil)
    end
  end # context

  context 'Displaying Lox literals:' do
    it 'should print boolean literals' do
      %w[false true].each do |bool|
        output = StringIO.new(+'', 'w')
        program = "print #{bool};"
        lox = Loxxy::Interpreter.new(ostream: output)
        lox.evaluate(program)
        expect(output.string).to eq(bool)
      end
    end

    it 'should print number literals' do
      %w[1234 12.34 -0.1 0.0001 12.0].each do |num|
        output = StringIO.new(+'', 'w')
        program = "print #{num};"
        lox = Loxxy::Interpreter.new(ostream: output)
        lox.evaluate(program)
        expect(output.string).to eq(num)
      end
    end

    it 'should print string literals' do
      ['I am a string',
        '',
        '123'].each do |str|
        output = StringIO.new(+'', 'w')
        program = %Q(print "#{str}";)
        lox = Loxxy::Interpreter.new(ostream: output)
        lox.evaluate(program)
        expect(output.string).to eq(str)
      end
    end

    it 'should print nil literal' do
      program = 'print nil;'
      output = StringIO.new(+'', 'w')
      lox = Loxxy::Interpreter.new(ostream: output)
      lox.evaluate(program)
      expect(output.string).to eq('nil')
    end
  end # context
end # describe
