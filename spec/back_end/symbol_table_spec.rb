# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework
require_relative '../../lib/loxxy/back_end/variable'

# Load the class under test
require_relative '../../lib/loxxy/back_end/symbol_table'

module Loxxy
  module BackEnd
    describe SymbolTable do
      subject(:symb_table) { described_class.new }

      context 'Initialization:' do
        it 'is initialized without argument' do
          expect { described_class.new }.not_to raise_error
        end

        it 'has a root BackEnd' do
          expect(symb_table.root).not_to be_nil
          expect(symb_table.current_env).to eq(symb_table.root)
          expect(symb_table.root).to be_a(BackEnd::Environment)
        end

        it "doesn't have names at initialization" do
          expect(symb_table.name2envs).to be_empty
        end

        it 'is empty at initialization' do
          expect(symb_table).to be_empty
        end
      end # context

      context 'Provided services:' do
        def var(aName)
          Variable.new(aName)
        end

        it 'allows the addition of a variable' do
          expect { symb_table.insert(var('q')) }.not_to raise_error
          expect(symb_table).not_to be_empty
          expect(symb_table.name2envs['q']).to be_a(Array)
          expect(symb_table.name2envs['q'].size).to eq(1)
          expect(symb_table.name2envs['q'].first).to eq(symb_table.current_env)
          expect(symb_table.current_env.defns['q']).to be_a(BackEnd::Variable)
        end

        it 'allows the addition of several labels for same env' do
          symb_table.insert(var('q'))
          # expect(i_name).to match(/^q_[0-9a-z]*$/)

          expect { symb_table.insert(var('x')) }.not_to raise_error
          expect(symb_table.name2envs['x']).to be_a(Array)
          expect(symb_table.name2envs['x'].first).to eq(symb_table.current_env)
          expect(symb_table.current_env.defns['x']).to be_a(BackEnd::Variable)
        end

        it 'allows the entry into a new scope' do
          symb_table.insert(var('q'))
          new_env = BackEnd::Environment.new
          expect { symb_table.enter_environment(new_env) }.not_to raise_error
          expect(symb_table.current_env).to eq(new_env)
          expect(symb_table.current_env.enclosing).to eq(symb_table.root)
          expect(symb_table.name2envs['q']).to eq([symb_table.root])
        end

        it 'allows the addition of same name in different scopes' do
          symb_table.insert(var('q'))
          symb_table.enter_environment(BackEnd::Environment.new)
          symb_table.insert(var('q'))
          expect(symb_table.name2envs['q']).to be_a(Array)
          expect(symb_table.name2envs['q'].size).to eq(2)
          expect(symb_table.name2envs['q'].first).to eq(symb_table.root)
          expect(symb_table.name2envs['q'].last).to eq(symb_table.current_env)
          expect(symb_table.current_env.defns['q']).to be_a(BackEnd::Variable)
        end

        it 'allows the removal of a scope' do
          symb_table.insert(var('q'))
          new_env = BackEnd::Environment.new
          symb_table.enter_environment(new_env)
          symb_table.insert(var('q'))
          expect(symb_table.name2envs['q'].size).to eq(2)

          expect { symb_table.leave_environment }.not_to raise_error
          expect(symb_table.current_env).to eq(symb_table.root)
          expect(symb_table.name2envs['q'].size).to eq(1)
          expect(symb_table.name2envs['q']).to eq([symb_table.root])
        end

        it 'allows the search of an entry based on its name' do
          symb_table.insert(var('q'))
          symb_table.insert(var('x'))
          symb_table.enter_environment(BackEnd::Environment.new)
          symb_table.insert(var('q'))
          symb_table.insert(var('y'))

          # Search for unknown name
          expect(symb_table.lookup('z')).to be_nil

          # Search for existing unique names
          expect(symb_table.lookup('y')).to eq(symb_table.current_env.defns['y'])
          expect(symb_table.lookup('x')).to eq(symb_table.root.defns['x'])

          # Search for redefined name
          expect(symb_table.lookup('q')).to eq(symb_table.current_env.defns['q'])
        end

        it 'lists all the variables defined in all the szcope chain' do
          symb_table.insert(var('q'))
          symb_table.enter_environment(BackEnd::Environment.new)
          symb_table.insert(var('x'))
          symb_table.enter_environment(BackEnd::Environment.new)
          symb_table.insert(var('y'))
          symb_table.insert(var('x'))

          vars = symb_table.all_variables
          expect(vars.map(&:name)).to eq(%w[q x y x])
        end
      end # context
    end # describe
  end # module
end # module
