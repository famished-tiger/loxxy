# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

# rubocop: disable Metrics/BlockLength
# rubocop: disable Style/StringConcatenation
describe 'super:' do
  context 'Valid cases:' do
    it "should allow 'super' in a closure of a method" do
      lox_snippet = <<-LOX_END
        class A {
          method(arg) {
            print "A.method(" + arg + ")";
          }
        }

        class B < A {
          getClosure() {
            return super.method;
          }

          method(arg) {
            print "B.method(" + arg + ")";
          }
        }


        var closure = B().getClosure();
        closure("arg"); // output: A.method(arg)
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('A.method(arg)')
    end

    it 'should allow `super` in closures' do
      lox_snippet = <<-LOX_END
        class Base {
          toString() { return "Base"; }
        }

        class Derived < Base {
          getClosure() {
            fun closure() {
              return super.toString();
            }
            return closure;
          }

          toString() { return "Derived"; }
        }

        var closure = Derived().getClosure();
        print closure(); // output: Base
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('Base')
    end

    it 'should allow `super` to call method with same name' do
      lox_snippet = <<-LOX_END
        class Base {
          foo() {
            print "Base.foo()";
          }
        }

        class Derived < Base {
          foo() {
            print "Derived.foo()";
            super.foo();
          }
        }

        Derived().foo();
        // expect: Derived.foo()
        // expect: Base.foo()
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('Derived.foo()' + 'Base.foo()')
    end

    it 'should allow `super` to call another method' do
      lox_snippet = <<-LOX_END
        class Base {
          foo() {
            print "Base.foo()";
          }
        }

        class Derived < Base {
          bar() {
            print "Derived.bar()";
            super.foo();
          }
        }

        Derived().bar();
        // output: Derived.bar()
        // output: Base.foo()
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('Derived.bar()' + 'Base.foo()')
    end

    it 'should allow `super` to call method inherited indirectly' do
      lox_snippet = <<-LOX_END
        class A {
          foo() {
            print "A.foo()";
          }
        }

        class B < A {}

        class C < B {
          foo() {
            print "C.foo()";
            super.foo();
          }
        }

        C().foo();
        // output: C.foo()
        // output: A.foo()
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      expect(io.string).to eq('C.foo()' + 'A.foo()')
    end

    it 'should implement this in nested classes' do
      lox_snippet = <<-LOX_END
        class Outer {
          method() {
            print this; // output: Outer instance

            fun f() {
              print this; // output: Outer instance

              class Inner {
                method() {
                  print this; // output: Inner instance
                }
              }

              Inner().method();
            }
            f();
          }
        }

        Outer().method();
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = ('Outer instance' * 2) + 'Inner instance'
      expect(io.string).to eq(predicted)
    end


    it 'should support support in closures' do
      lox_snippet = <<-LOX_END
        class Foo {
          getClosure() {
            fun f() {
              fun g() {
                fun h() {
                  return this.toString();
                }
                return h;
              }
              return g;
            }
            return f;
          }

          toString() { return "foo"; }
        }

        var closure = Foo().getClosure();
        print closure()()(); // output: foo
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = 'foo'
      expect(io.string).to eq(predicted)
    end

    it 'should support super in initializers' do
      lox_snippet = <<-LOX_END
        class Base {
          init(a, b) {
            print "Base.init(" + a + ", " + b + ")";
          }
        }

        class Derived < Base {
          init() {
            print "Derived.init()";
            super.init("a", "b");
          }
        }

        Derived();
        // output: Derived.init()
        // output: Base.init(a, b)
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = 'Derived.init()' + 'Base.init(a, b)'
      expect(io.string).to eq(predicted)
    end

    it 'should support the combination of super and this' do
      lox_snippet = <<-LOX_END
        class Base {
          init(a) {
            this.a = a;
          }
        }

        class Derived < Base {
          init(a, b) {
            super.init(a);
            this.b = b;
          }
        }

        var derived = Derived("a", "b");
        print derived.a; // output: a
        print derived.b; // output: b
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = 'a' + 'b'
      expect(io.string).to eq(predicted)
    end

    it 'should support super with multiple instances' do
      lox_snippet = <<-LOX_END
        class Base {
          method() {
            print "Base.method()";
          }
        }

        class Derived < Base {
          method() {
            super.method();
          }
        }

        class OtherBase {
          method() {
            print "OtherBase.method()";
          }
        }

        var derived = Derived();
        derived.method(); // output: Base.method()
        Base = OtherBase;
        derived.method(); // output: Base.method()
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = 'Base.method()' + 'Base.method()'
      expect(io.string).to eq(predicted)
    end

    it 'should support super in a closure in inherited method' do
      lox_snippet = <<-LOX_END
        class A {
          say() {
            print "A";
          }
        }

        class B < A {
          getClosure() {
            fun closure() {
              super.say();
            }
            return closure;
          }

          say() {
            print "B";
          }
        }

        class C < B {
          say() {
            print "C";
          }
        }

        C().getClosure()(); // output: A
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = 'A'
      expect(io.string).to eq(predicted)
    end

    it 'should support super in an inherited method' do
      lox_snippet = <<-LOX_END
        class A {
          say() {
            print "A";
          }
        }

        class B < A {
          test() {
            super.say();
          }

          say() {
            print "B";
          }
        }

        class C < B {
          say() {
            print "C";
          }
        }

        C().test(); // expect: A
      LOX_END
      io = StringIO.new
      lox = Loxxy::Interpreter.new({ ostream: io })
      expect { lox.evaluate(lox_snippet) }.not_to raise_error
      predicted = 'A'
      expect(io.string).to eq(predicted)
    end
  end # context

  context 'Invalid - return cases:' do
    it 'should complain when super occurs at top-level scope' do
      err = StandardError
      err_msg = "Error at 'super': Can't use 'super' outside of a class."
      lox = Loxxy::Interpreter.new
      ['super.foo("bar");', 'super.foo;'].each do |lox_snippet|
        expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
      end
    end

    it 'should complain when a super occurs in top-level function' do
      err = StandardError
      err_msg = "Error at 'super': Can't use 'super' outside of a class."
      lox = Loxxy::Interpreter.new
      lox_snippet = <<-LOX_END
        fun foo() {
          super.bar(); // Error at 'super': Can't use 'super' outside of a class.
        }
      LOX_END
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end

    it "should complain when a super isn't followed by a dot" do
      err = StandardError
      # Non-conformity in error message
      _err_msg = <<-MSG_END
        Reason: Syntax error at or near token line 6, column 18 >>>;<<<
        Expected one 'DOT', found a 'SEMICOLON' instead
      MSG_END
      lox = Loxxy::Interpreter.new
      lox_snippet = <<-LOX_END
        class A {}

        class B < A {
          method() {
            // [line 6] Error at ';': Expect '.' after 'super'.
            super;
          }
        }
      LOX_END
      expect { lox.evaluate(lox_snippet) }.to raise_error(err)
    end

    it "should complain when the dot after super isn't followed by identifier" do
      err = StandardError
      # Non-conformity in error message
      _err_msg = <<-MSG_END
        Reason: Syntax error at or near token line 5, column 19 >>>;<<<
        Expected one 'IDENTIFIER', found a 'SEMICOLON' instead.
      MSG_END
      lox = Loxxy::Interpreter.new
      lox_snippet = <<-LOX_END
        class A {}

        class B < A {
          method() {
            super.; // Error at ';': Expect superclass method name.
          }
        }
      LOX_END
      expect { lox.evaluate(lox_snippet) }.to raise_error(err)
    end

    it 'should complain when super occurs in an orphan class' do
      err = StandardError
      err_msg = "Error at 'super': Can't use 'super' in a class without superclass."
      lox = Loxxy::Interpreter.new
      lox_snippet = <<-LOX_END
        class Base {
          foo() {
            super.doesNotExist; // Error at 'super': Can't use 'super' in a class with no superclass.
          }
        }

        Base().foo();
      LOX_END
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end

    it 'should complain when a super call occurs in an orphan class' do
      err = StandardError
      err_msg = "Error at 'super': Can't use 'super' in a class without superclass."
      lox = Loxxy::Interpreter.new
      lox_snippet = <<-LOX_END
        class Base {
          foo() {
            super.doesNotExist(1); // Error at 'super': Can't use 'super' in a class with no superclass.
          }
        }

        Base().foo();
      LOX_END
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end

    it 'should complain when a super call refers to inexistent method' do
      err = StandardError
      err_msg = "Undefined property 'doesNotExist'."
      lox = Loxxy::Interpreter.new
      lox_snippet = <<-LOX_END
        class Base {}

        class Derived < Base {
          foo() {
            super.doesNotExist(1); // expect runtime error: Undefined property 'doesNotExist'.
          }
        }

        Derived().foo();
      LOX_END
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end

    it 'should complain when super call has extra arguments' do
      err = Loxxy::RuntimeError
      err_msg = 'Expected 2 arguments but got 4.'
      lox = Loxxy::Interpreter.new
      lox_snippet = <<-LOX_END
        class Base {
          foo(a, b) {
            print "Base.foo(" + a + ", " + b + ")";
          }
        }

        class Derived < Base {
          foo() {
            print "Derived.foo()"; // expect: Derived.foo()
            super.foo("a", "b", "c", "d"); // expect runtime error: Expected 2 arguments but got 4.
          }
        }

        Derived().foo();
      LOX_END
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end

    it 'should complain when super is put between parentheses' do
      err = StandardError
      # Non-conformity in error message
      _err_msg = <<-MSG_END
        Reason: Syntax error at or near token line 8, column 19 >>>)<<<
        Expected one 'DOT', found a 'RIGHT_PAREN' instead.
      MSG_END
      lox = Loxxy::Interpreter.new
      lox_snippet = <<-LOX_END
        class A {
          method() {}
        }

        class B < A {
          method() {
            // [line 8] Error at ')': Expect '.' after 'super'.
            (super).method();
          }
        }
      LOX_END
      expect { lox.evaluate(lox_snippet) }.to raise_error(err)
    end
  end # context
  # rubocop: enable Style/StringConcatenation
  # rubocop: enable Metrics/BlockLength
end # describe
