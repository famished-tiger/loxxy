# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework
require 'stringio'

# Load the class under test
require_relative '../../lib/loxxy/back_end/engine'

module Loxxy
  module BackEnd
    describe Engine do
      let(:sample_options) do
        { ostream: StringIO.new }
      end
      subject { Engine.new(sample_options) }

      context 'Initialization:' do
        it 'should accept a option Hash at initialization' do
          expect { Engine.new(sample_options) }.not_to raise_error
        end

        it 'should know its config options' do
          expect(subject.config).to eq(sample_options)
        end

        it 'should have an empty stack' do
          expect(subject.stack).to be_empty
        end
      end

      context 'Listening to visitor events:' do
        let(:greeting) { Datatype::LXString.new('Hello, world') }
        let(:sample_pos) { double('fake-position') }
        let(:var_decl) { Ast::LoxVarStmt.new(sample_pos, 'greeting', greeting) }
        let(:lit_expr) { Ast::LoxLiteralExpr.new(sample_pos, greeting) }

        it "should react to 'before_var_stmt' event" do
          expect { subject.before_var_stmt(var_decl) }.not_to raise_error
          current_env = subject.symbol_table.current_env
          expect(current_env.defns['greeting']).to be_kind_of(Variable)
        end

        it "should react to 'after_var_stmt' event" do
          # Precondition: `before_var_stmt` is called...
          expect { subject.before_var_stmt(var_decl) }.not_to raise_error
          # Precondition: value to assign is on top of stack
          subject.stack.push(greeting)

          expect { subject.after_var_stmt(var_decl) }.not_to raise_error
          current_env = subject.symbol_table.current_env
          expect(current_env.defns['greeting']).to be_kind_of(Variable)
          expect(current_env.defns['greeting'].value).to eq(greeting)
        end

        it "should react to 'before_literal_expr' event" do
          expect { subject.before_literal_expr(lit_expr) }.not_to raise_error
          expect(subject.stack.pop).to eq(greeting)
        end
      end
    end # describe
  end # module
end # module
