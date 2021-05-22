# frozen_string_literal: true

require_relative 'spec_helper' # Use the RSpec framework
require 'stringio'

# Load the class under test
require_relative '../lib/loxxy/interpreter'

# rubocop: disable Metrics/ModuleLength
module Loxxy
  # This spec contains the bare bones test for the Interpreter class.
  # The execution of Lox code is tested elsewhere.
  # rubocop: disable Metrics/BlockLength
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

      it 'should ignore spaces surrounding minus in subtraction of two numbers' do
        [
          ['1 - 1;', 0],
          ['1 -1;', 0],
          ['1- 1;', 0],
          ['1-1;', 0]
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
          ['if (nil) print "ignored";', ''],
          ['if (true) { print "block"; }', 'block'],
          ['var a = false; if (a = true) print a;', 'true'],

          # Evaluate the 'else' expression if the condition is false.
          ['if (true) print "then-branch"; else print "else-branch";', 'then-branch'],
          ['if (false) print "then-branch"; else print "else-branch";', 'else-branch'],
          ['if (0) print "then-branch"; else print "else-branch";', 'then-branch'],
          ['if (nil) print "then-branch"; else print "else-branch";', 'else-branch'],
          ['if (false) nil; else { print "else-branch"; }', 'else-branch'],

          # A dangling else binds to the right-most if.
          ['if (true) if (false) print "bad"; else print "good";', 'good'],
          ['if (false) if (true) print "bad"; else print "worse";', '']
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
        var a;
        print a; // => nil
LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('nil')
      end

      it 'should accept assignments to a global variable' do
        program = <<-LOX_END
          var a = "before";
          print a; // output: before

          a = "after";
          print a; // output: after

          print a = "arg"; // output: arg
          print a; // output: arg
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('beforeafterargarg')
      end

      it 'should support variables local to a block' do
        program = <<-LOX_END
        {
          var a = "first";
          print a;
        }
        {
          var a = "second";
          print a;
        }
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('firstsecond')
      end

      it 'should support the shadowing of variables in a block' do
        program = <<-LOX_END
        var a = "outer";

        {
          var a = "inner";
          print a; // output: inner
        }

        print a; // output: outer
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('innerouter')
      end

      it 'should implement single statement while loops' do
        program = <<-LOX_END
          // Single-expression body.
          var c = 0;
          while (c < 3) print c = c + 1;
          // output: 1
          // output: 2
          // output: 3
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('123')
      end

      it 'should implement block body while loops' do
        program = <<-LOX_END
          // Block body.
          var a = 0;
          while (a < 3) {
            print a;
            a = a + 1;
          }
          // output: 0
          // output: 1
          // output: 2
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('012')
      end

      it 'should implement single statement for loops' do
        program = <<-LOX_END
          // Single-expression body.
          for (var c = 0; c < 3;) print c = c + 1;
          // output: 1
          // output: 2
          // output: 3
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('123')
      end

      it 'should implement for loops with block body' do
        program = <<-LOX_END
          // Block body.
          for (var a = 0; a < 3; a = a + 1) {
            print a;
          }
          // output: 0
          // output: 1
          // output: 2
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('012')
      end

      it 'should implement nullary function calls' do
        program = <<-LOX_END
          print clock(); // Lox expects the 'clock' predefined native function
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        tick = sample_cfg[:ostream].string
        expect(Time.now.to_f - tick.to_f).to be < 0.1
      end

      it 'should implement function definition' do
        program = <<-LOX_END
          fun printSum(a, b) {
             print a + b;
          }
          printSum(1, 2);
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('3')
      end

      it 'should support functions with empty body' do
        program = <<-LOX_END
          fun f() {}
          print f();
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('nil')
      end

      it 'should provide print representation of functions' do
        program = <<-LOX_END
          fun foo() {}
          print foo; // output: <fn foo>
          print clock; // output: <native fn>
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('<fn foo><native fn>')
      end

      it "should implement 'getc' function" do
        input_str = 'Abc'
        cfg = { istream: StringIO.new(input_str) }
        interpreter = Loxxy::Interpreter.new(cfg)
        source = 'getc();'
        result = interpreter.evaluate(source)
        expect(result.value).to eq(65) # codepoint for letter 'A'
      end

      it "should implement 'chr' function" do
        source = 'chr(65); // => "A"'
        result = subject.evaluate(source)
        expect(result.value).to eq('A')
      end

      # This test is disabled since it causes RSpec to stop immediately
      # it "should implement 'exit' function" do
      #   source = 'exit(100); // Process halts with exit code 100'
      #   expect { subject.evaluate(source) }.to raise(SystemExit)
      # end

      it "should implement 'print_error' function" do
        source = 'print_error("Some error"); // => Some error on stderr'
        stderr_backup = $stderr
        $stderr = StringIO.new
        expect { subject.evaluate(source) }.not_to raise_error
        expect($stderr.string).to eq('Some error')
        $stderr = stderr_backup
      end

      # rubocop: disable Style/StringConcatenation
      it 'should return in absence of explicit return statement' do
        program = <<-LOX_END
          fun foo() {
            print "foo";
          }

          print foo();
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('foo' + 'nil')
      end
      # rubocop: enable Style/StringConcatenation

      it 'should support return statements' do
        program = <<-LOX_END
          fun max(a, b) {
            if (a > b) return a;

            return b;
          }

          max(3, 2);
        LOX_END
        result = subject.evaluate(program)
        expect(result).to eq(3)
      end

      it 'should support return within statements inside a function' do
        program = <<-LOX_END
          fun foo() {
            for (;;) return "done";
          }
          print foo(); // output: done
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('done')
      end

      # rubocop: disable Style/StringConcatenation
      it 'should support local functions and closures' do
        program = <<-LOX_END
          fun makeCounter() {
            var i = 0;
            fun count() {
              i = i + 1;
              print i;
            }

            return count;
          }

          var counter = makeCounter();
          counter(); // "1".
          counter(); // "2".
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('1' + '2')
      end
      # rubocop: enable Style/StringConcatenation

      it 'should print the hello world message' do
        program = <<-LOX_END
          var greeting = "Hello"; // Declaring a variable
          print greeting + ", " + "world!"; // ... Playing with concatenation
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('Hello, world!')
      end
    end # context

    context 'Object orientation:' do
      let(:duck_class) do
        snippet = <<-LOX_END
          class Duck {
            noise() {
              this.quack();
            }

            quack() {
              print "quack";
            }
          }
        LOX_END

        snippet
      end

      it 'should support field assignment expression' do
        program = <<-LOX_END
          class Foo {}

          var foo = Foo();

          print foo.bar = "bar value"; // expect: bar value
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('bar value')
      end

      it 'should support class declaration' do
        program = <<-LOX_END
          #{duck_class}

          print Duck; // Class names can appear in statements
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('Duck')
      end

      it 'should support default instance creation' do
        program = <<-LOX_END
          #{duck_class}

          var daffy = Duck(); // Default constructor
          print daffy;
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('Duck instance')
      end

      it 'should support calls to method' do
        program = <<-LOX_END
          #{duck_class}

          var daffy = Duck(); // Default constructor
          daffy.quack();
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('quack')
      end

      it "should support the 'this' keyword" do
        program = <<-LOX_END
          class Egotist {
            speak() {
              print this;
            }
          }

          var method = Egotist().speak;
          method(); // Output: Egotist instance
        LOX_END
        expect { subject.evaluate(program) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('Egotist instance')
      end

      it 'should support a closure nested in a method' do
        lox_snippet = <<-LOX_END
        class Foo {
          getClosure() {
            fun closure() {
              return this.toString();
            }
            return closure;
          }

          toString() { return "foo"; }
        }

        var closure = Foo().getClosure();
        closure;
        LOX_END
        # Expected result: Backend::LoxFunction('closure')
        # Expected function's closure (environment layout):
        # Environment('global')
        #   defns
        #   +- ['clock'] => BackEnd::Engine::NativeFunction
        #   *- ['Foo'] => BackEnd::LoxClass
        # Environment
        #   defns
        #   ['this'] => BackEnd::LoxInstance
        # Environment
        #   defns
        #   +- ['closure'] => Backend::LoxFunction
        result = subject.evaluate(lox_snippet)
        expect(result).to be_kind_of(BackEnd::LoxFunction)
        expect(result.name).to eq('closure')
        closure = result.closure
        expect(closure).to be_kind_of(Loxxy::BackEnd::Environment)
        expect(closure.defns['closure'].value).to eq(result)
        expect(closure.enclosing).to be_kind_of(Loxxy::BackEnd::Environment)
        expect(closure.enclosing.defns['this'].value).to be_kind_of(Loxxy::BackEnd::LoxInstance)
        global_env = closure.enclosing.enclosing
        expect(global_env).to be_kind_of(Loxxy::BackEnd::Environment)
        expect(global_env.defns['clock'].value).to be_kind_of(BackEnd::Engine::NativeFunction)
        expect(global_env.defns['Foo'].value).to be_kind_of(BackEnd::LoxClass)
      end

      it 'should support custom initializer' do
        lox_snippet = <<-LOX_END
          // From section 3.9.5
          class Breakfast {
            init(meat, bread) {
              this.meat = meat;
              this.bread = bread;
            }

            serve(who) {
              print "Enjoy your " + this.meat + " and " +
                  this.bread + ", " + who + ".";
            }
          }

          var baconAndToast = Breakfast("bacon", "toast");
          baconAndToast.serve("Dear Reader");
          // Output: "Enjoy your bacon and toast, Dear Reader."
        LOX_END
        expect { subject.evaluate(lox_snippet) }.not_to raise_error
        predicted = 'Enjoy your bacon and toast, Dear Reader.'
        expect(sample_cfg[:ostream].string).to eq(predicted)
      end

      it 'should support class inheritance and super keyword' do
        lox_snippet = <<-LOX_END
          class A {
            method() {
              print "A method";
            }
          }

          class B < A {
            method() {
              print "B method";
            }

            test() {
              super.method();
            }
          }

          class C < B {}

          C().test();
        LOX_END
        expect { subject.evaluate(lox_snippet) }.not_to raise_error
        expect(sample_cfg[:ostream].string).to eq('A method')
      end
    end # context
  end # describe
  # rubocop: enable Metrics/BlockLength
end # module
# rubocop: enable Metrics/ModuleLength
