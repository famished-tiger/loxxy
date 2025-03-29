# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/back_end/environment'

module Loxxy
  module BackEnd
    describe Environment do
      let(:foo) { Datatype::LXString.new('foo') }
      let(:bar) { Datatype::LXString.new('bar') }
      let(:mother) { described_class.new }

      subject(:an_environ) { described_class.new(mother) }

      # Shortand factory method.
      def var(aName, aValue)
        Variable.new(aName, aValue)
      end

      context 'Initialization:' do
        it 'could be initialized without argument' do
          expect { described_class.new }.not_to raise_error
        end

        it 'could be initialized with a parent environment' do
          expect { described_class.new(mother) }.not_to raise_error
        end

        it "doesn't have definitions by default" do
          expect(an_environ.defns).to be_empty
        end

        it 'knows its parent (if any)' do
          expect(an_environ.enclosing).to eq(mother)
        end
      end # context

      context 'Provided services:' do
        it 'accepts the addition of a variable' do
          an_environ.insert(var('a', foo))
          expect(an_environ.defns).not_to be_empty
          var_a = an_environ.defns['a']
          expect(var_a).to be_a(Variable)
          expect(var_a.name).to eq('a')
        end

        it 'accepts the addition of multiple variables' do
          an_environ.insert(var('a', foo))
          expect(an_environ.defns).not_to be_empty

          an_environ.insert(var('b', bar))
          var_b = an_environ.defns['b']
          expect(var_b).to be_a(Variable)
          expect(var_b.name).to eq('b')
        end
      end # context
    end # describe
  end # module
end # module
