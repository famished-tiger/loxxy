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

    context 'Evaluating arithmetic operations code:' do
      it 'should evaluate an addition of two numbers' do
        result = subject.evaluate('123 + 456; // => 579')
        expect(result).to be_kind_of(Loxxy::Datatype::Number)
        expect(result == 579).to be_true
      end

      it 'should evaluate a subtraction of two numbers' do
        result = subject.evaluate('4 - 3; // => 1')
        expect(result).to be_kind_of(Loxxy::Datatype::Number)
        expect(result == 1).to be_true
      end

      it 'should evaluate a multiplication of two numbers' do
        result = subject.evaluate('5 * 3; // => 15')
        expect(result).to be_kind_of(Loxxy::Datatype::Number)
        expect(result == 15).to be_true
      end

      it 'should evaluate a division of two numbers' do
        result = subject.evaluate('8 / 2; // => 4')
        expect(result).to be_kind_of(Loxxy::Datatype::Number)
        expect(result == 4).to be_true
      end
    end # context

    context 'Evaluating Lox code:' do
      let(:hello_world) do
        lox = <<-LOX_END
        var greeting = "Hello"; // Declaring a variable
        print greeting + ", " + "world!"; // ... Playing with concatenation
LOX_END

        lox
      end

      it 'should evaluate core data types' do
        result = subject.evaluate('true; // Not false')
        expect(result).to be_kind_of(Loxxy::Datatype::True)
      end

      it 'should evaluate string concatenation' do
        result = subject.evaluate('"str" + "ing"; // => "string"')
        expect(result).to be_kind_of(Loxxy::Datatype::LXString)
        expect(result == 'string').to be_true
      end

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

      it 'should evaluate a comparison of two numbers' do
        [
          ['1 < 2;', true],
          ['2 < 2;', false],
          ['2 < 1;', false],
          ['1 <= 2;', true],
          ['2 <= 2;', true],
          ['2 <= 1;', false],
          ['1 > 2;', false],
          ['2 > 2;', false],
          ['2 > 1;', true],
          ['1 >= 2;', false],
          ['2 >= 2;', true],
          ['2 >= 1;', true],
          ['0 < -0;', false],
          ['-0 < 0;', false],
          ['0 > -0;', false],
          ['-0 > 0;', false],
          ['0 <= -0;', true],
          ['-0 <= 0;', true],
          ['0 >= -0;', true],
          ['-0 >= 0;', true]
        ].each do |(source, predicted)|
          lox = Loxxy::Interpreter.new
          result = lox.evaluate(source)
          expect(result.value == predicted).to be_truthy
        end
      end

      it 'should evaluate the change sign of a number' do
        [
          ['- 3;', -3],
          ['- - 3;', 3],
          ['- - - 3;', -3]
        ].each do |(source, predicted)|
          lox = Loxxy::Interpreter.new
          result = lox.evaluate(source)
          expect(result.value == predicted).to be_truthy
        end
      end

      it 'should evaluate the negation of an object' do
        [
          ['!true;', false],
          ['!false;', true],
          ['!!true;', true],
          ['!123;', false],
          ['!0;', false],
          ['!nil;', true],
          ['!"";', false]
        ].each do |(source, predicted)|
          lox = Loxxy::Interpreter.new
          result = lox.evaluate(source)
          expect(result.value == predicted).to be_truthy
        end
      end

      it 'should evaluate the "conjunction" of two values' do
        [
          # Return the first falsey argument
          ['false and 1;', false],
          ['nil and 1;', nil],
          ['true and 1;', 1],
          ['1 and 2 and false;', false],
          ['1 and 2 and nil;', nil],

          # Return the last argument if all are truthy
          ['1 and true;', true],
          ['0 and true;', true],
          ['"false" and 0;', 0],
          ['1 and 2 and 3;', 3]

          # TODO test short-circuit at first false argument
        ].each do |(source, predicted)|
          lox = Loxxy::Interpreter.new
          result = lox.evaluate(source)
          expect(result.value == predicted).to be_truthy
        end
      end

      it 'should evaluate the "disjunction" of two values' do
        [
          # Return the first truthy argument
          ['1 or true;', 1],
          ['false or 1;', 1],
          ['nil or 1;', 1],
          ['false or false or true;', true],
          ['1 and 2 and nil;', nil],

          # Return the last argument if all are falsey
          ['false or false;', false],
          ['nil or false;', false],
          ['false or nil;', nil],
          ['false or false or false;', false],
          ['false or false or nil;', nil]

          # TODO test short-circuit at first false argument
        ].each do |(source, predicted)|
          lox = Loxxy::Interpreter.new
          result = lox.evaluate(source)
          expect(result.value == predicted).to be_truthy
        end
      end

      it 'should support expressions between parentheses' do
        [
          ['3 + 4 * 5;', 23],
          ['(3 + 4) * 5;', 35],
          ['(5 - (3 - 1)) + -(1);', 2]
        ].each do |(source, predicted)|
          lox = Loxxy::Interpreter.new
          result = lox.evaluate(source)
          expect(result.value == predicted).to be_truthy
        end
      end

      it 'should evaluate an if statement' do
        [
          # Evaluate the 'then' expression if the condition is true.
          ['if (true) print "then-branch";', 'then-branch'],
          ['if (false) print "ignored";', ''],
          # TODO: test with then block body
          # TODO: test with assignment in if condition

          # Evaluate the 'else' expression if the condition is false.
          ['if (true) print "then-branch"; else print "else-branch";', 'then-branch'],
          ['if (false) print "then-branch"; else print "else-branch";', 'else-branch'],
          ['if (0) print "then-branch"; else print "else-branch";', 'then-branch'],
          ['if (nil) print "then-branch"; else print "else-branch";', 'else-branch']
          # TODO: test with else block body

          # TODO: A dangling else binds to the right-most if.
          # ['if (true) if (false) print "bad"; else print "good";', 'good'],
          # ['if (false) if (true) print "bad"; else print "worse";', 'bad']
        ].each do |(source, predicted)|
          io = StringIO.new
          cfg = { ostream: io }
          lox = Loxxy::Interpreter.new(cfg)
          lox.evaluate(source)
          expect(io.string).to eq(predicted)
        end
      end

      it 'should accept variable declarations' do
        # Variable with initialization value
        var_decl = 'var iAmAVariable = "here is my value";'
        expect { subject.evaluate(var_decl) }.not_to raise_error

        # Variable without initialization value
        expect { subject.evaluate('var iAmNil;') }.not_to raise_error
      end

      it 'should accept variable mention' do
        program = <<-LOX_END
        var foo = "bar";
        print foo; // => bar
LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('bar')
      end

      it 'should set uninitialized variables to nil' do
        program = <<-LOX_END
        var foo;
        print foo; // => nil
LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('nil')
      end

      it 'should print the hello world message' do
        expect { subject.evaluate(hello_world) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('Hello, world!')
      end
    end # context
  end # describe
end # module
