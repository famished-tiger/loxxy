# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/back_end/environment'

module Loxxy
  module BackEnd
    describe Environment do
      let(:foo) { Datatype::LXString.new('foo') }
      let(:bar) { Datatype::LXString.new('bar') }
      let(:mother) { Environment.new }
      subject { Environment.new(mother) }

      # Shortand factory method.
      def var(aName, aValue)
        Variable.new(aName, aValue)
      end

      context 'Initialization:' do
        it 'could be initialized without argument' do
          expect { Environment.new }.not_to raise_error
        end

        it 'could be initialized with a parent environment' do
          expect { Environment.new(mother) }.not_to raise_error
        end

        it "shouldn't have definitions by default" do
          expect(subject.defns).to be_empty
        end

        it 'should know its parent (if any)' do
          expect(subject.enclosing).to eq(mother)
        end
      end # context

      context 'Provided services:' do
        it 'should accept the addition of a variable' do
          subject.insert(var('a', foo))
          expect(subject.defns).not_to be_empty
          var_a = subject.defns['a']
          expect(var_a).to be_kind_of(Variable)
          expect(var_a.name).to eq('a')
        end

        it 'should accept the addition of multiple variables' do
          subject.insert(var('a', foo))
          expect(subject.defns).not_to be_empty

          subject.insert(var('b', bar))
          var_b = subject.defns['b']
          expect(var_b).to be_kind_of(Variable)
          expect(var_b.name).to eq('b')
        end
      end # context
    end # describe
  end # module
end # module
