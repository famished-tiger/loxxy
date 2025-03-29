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

      subject(:engine) { described_class.new(sample_options) }

      context 'Initialization:' do
        it 'accepts an option Hash at initialization' do
          expect { described_class.new(sample_options) }.not_to raise_error
        end

        it 'knows its config options' do
          expect(engine.config).to eq(sample_options)
        end

        it 'has an empty stack' do
          expect(engine.stack).to be_empty
        end
      end

      context 'Listening to visitor events:' do
        let(:greeting) { Datatype::LXString.new('Hello, world') }
        # let(:sample_pos) { double('fake-position') }
        let(:sample_pos) { instance_double(Rley::Lexical::Position) }
        let(:var_decl) { Ast::LoxVarStmt.new(sample_pos, 'greeting', greeting) }
        let(:lit_expr) { Ast::LoxLiteralExpr.new(sample_pos, greeting) }

        it "reacts to 'after_var_stmt' event" do
          # Precondition: value to assign is on top of expr stack
          engine.expr_stack.push(greeting)

          expect { engine.after_var_stmt(var_decl) }.not_to raise_error
          current_env = engine.symbol_table.current_env
          expect(current_env.defns['greeting']).to be_a(Variable)
          expect(current_env.defns['greeting'].value).to eq(greeting)
        end

        it "reacts to 'before_literal_expr' event" do
          expect { engine.before_literal_expr(lit_expr) }.not_to raise_error
          expect(engine.expr_stack.pop).to eq(greeting)
        end
      end

      context 'Built-in functions:' do
        it 'provides built-in functions' do
          symb_table = engine.symbol_table
          %w[clock getc chr exit print_error].each do |name|
            fun_var = symb_table.current_env.defns[name]
            expect(fun_var.value).to be_a(BackEnd::Engine::NativeFunction)
          end
        end
      end
    end # describe
  end # module
end # module
