# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework
require_relative '../../lib/loxxy/back_end/variable'

# Load the class under test
require_relative '../../lib/loxxy/back_end/symbol_table'

module Loxxy
  module BackEnd
    describe SymbolTable do
      subject { SymbolTable.new }

      context 'Initialization:' do
        it 'should be initialized without argument' do
          expect { SymbolTable.new }.not_to raise_error
        end

        it 'should have a root BackEnd' do
          expect(subject.root).not_to be_nil
          expect(subject.current_env).to eq(subject.root)
          expect(subject.root).to be_kind_of(BackEnd::Environment)
        end

        it "shouldn't have names at initialization" do
          expect(subject.name2envs).to be_empty
        end

        it 'should be empty at initialization' do
          expect(subject).to be_empty
        end
      end # context

      context 'Provided services:' do
        def var(aName)
          Variable.new(aName)
        end

        it 'should allow the addition of a variable' do
          expect { subject.insert(var('q')) }.not_to raise_error
          expect(subject).not_to be_empty
          expect(subject.name2envs['q']).to be_kind_of(Array)
          expect(subject.name2envs['q'].size).to eq(1)
          expect(subject.name2envs['q'].first).to eq(subject.current_env)
          expect(subject.current_env.defns['q']).to be_kind_of(BackEnd::Variable)
        end

        it 'should allow the addition of several labels for same env' do
          subject.insert(var('q'))
          # expect(i_name).to match(/^q_[0-9a-z]*$/)

          expect { subject.insert(var('x')) }.not_to raise_error
          expect(subject.name2envs['x']).to be_kind_of(Array)
          expect(subject.name2envs['x'].first).to eq(subject.current_env)
          expect(subject.current_env.defns['x']).to be_kind_of(BackEnd::Variable)
        end

        it 'should allow the entry into a new scope' do
          subject.insert(var('q'))
          new_env = BackEnd::Environment.new
          expect { subject.enter_environment(new_env) }.not_to raise_error
          expect(subject.current_env).to eq(new_env)
          expect(subject.current_env.parent).to eq(subject.root)
          expect(subject.name2envs['q']).to eq([subject.root])
        end

        it 'should allow the addition of same name in different scopes' do
          subject.insert(var('q'))
          subject.enter_environment(BackEnd::Environment.new)
          subject.insert(var('q'))
          expect(subject.name2envs['q']).to be_kind_of(Array)
          expect(subject.name2envs['q'].size).to eq(2)
          expect(subject.name2envs['q'].first).to eq(subject.root)
          expect(subject.name2envs['q'].last).to eq(subject.current_env)
          expect(subject.current_env.defns['q']).to be_kind_of(BackEnd::Variable)
        end

        it 'should allow the removal of a scope' do
          subject.insert(var('q'))
          new_env = BackEnd::Environment.new
          subject.enter_environment(new_env)
          subject.insert(var('q'))
          expect(subject.name2envs['q'].size).to eq(2)

          expect { subject.leave_environment }.not_to raise_error
          expect(subject.current_env).to eq(subject.root)
          expect(subject.name2envs['q'].size).to eq(1)
          expect(subject.name2envs['q']).to eq([subject.root])
        end

        it 'should allow the search of an entry based on its name' do
          subject.insert(var('q'))
          subject.insert(var('x'))
          subject.enter_environment(BackEnd::Environment.new)
          subject.insert(var('q'))
          subject.insert(var('y'))

          # Search for unknown name
          expect(subject.lookup('z')).to be_nil

          # Search for existing unique names
          expect(subject.lookup('y')).to eq(subject.current_env.defns['y'])
          expect(subject.lookup('x')).to eq(subject.root.defns['x'])

          # Search for redefined name
          expect(subject.lookup('q')).to eq(subject.current_env.defns['q'])
        end

        # it 'should allow the search of an entry based on its i_name' do
          # subject.insert(var('q'))
          # i_name_x = subject.insert(var('x'))
          # subject.enter_environment(BackEnd::Environment.new)
          # i_name_q2 = subject.insert(var('q'))
          # i_name_y = subject.insert(var('y'))

          # # Search for unknown i_name
          # expect(subject.lookup_i_name('dummy')).to be_nil

          # curr_scope = subject.current_env
          # # # Search for existing unique names
          # expect(subject.lookup_i_name(i_name_y)).to eq(curr_scope.defns['y'])
          # expect(subject.lookup_i_name(i_name_x)).to eq(subject.root.defns['x'])

          # # Search for redefined name
          # expect(subject.lookup_i_name(i_name_q2)).to eq(curr_scope.defns['q'])
        # end

        it 'should list all the variables defined in all the szcope chain' do
          subject.insert(var('q'))
          subject.enter_environment(BackEnd::Environment.new)
          subject.insert(var('x'))
          subject.enter_environment(BackEnd::Environment.new)
          subject.insert(var('y'))
          subject.insert(var('x'))

          vars = subject.all_variables
          expect(vars.map(&:name)).to eq(%w[q x y x])
        end
      end # context
    end # describe
  end # module
end # module
