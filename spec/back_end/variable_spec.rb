# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/back_end/variable'


module Loxxy
  module BackEnd
    describe Variable do
      let(:sample_name) { 'iAmAVariable' }
      let(:sample_value) { 'here is my value' }
      subject { Variable.new(sample_name, sample_value) }

      context 'Initialization:' do
        it 'should be initialized with a name and a value, or...' do
          expect { Variable.new(sample_name, sample_value) }.not_to raise_error
        end

        it 'should be initialized with just a name' do
          expect { Variable.new(sample_name) }.not_to raise_error
        end

        it 'should know its name' do
          expect(subject.name).to eq(sample_name)
        end

        it 'should have a frozen name' do
          expect(subject.name).to be_frozen
        end

        it 'should know its value (if provided)' do
          expect(subject.value).to eq(sample_value)
        end

        it 'should have a nil value otherwise' do
          instance = Variable.new(sample_name)
          expect(instance.value).to eq(Datatype::Nil.instance)
        end
      end # context
    end # describe
  end # module
end # module
