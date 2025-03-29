# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/back_end/variable'


module Loxxy
  module BackEnd
    describe Variable do
      let(:sample_name) { 'iAmAVariable' }
      let(:sample_value) { 'here is my value' }

      subject(:a_var) { described_class.new(sample_name, sample_value) }

      context 'Initialization:' do
        it 'is initialized with a name and a value, or...' do
          expect { described_class.new(sample_name, sample_value) }.not_to raise_error
        end

        it 'is initialized with just a name' do
          expect { described_class.new(sample_name) }.not_to raise_error
        end

        it 'knows its name' do
          expect(a_var.name).to eq(sample_name)
        end

        it 'has a frozen name' do
          expect(a_var.name).to be_frozen
        end

        it 'knows its value (if provided)' do
          expect(a_var.value).to eq(sample_value)
        end

        it 'has a nil value otherwise' do
          instance = described_class.new(sample_name)
          expect(instance.value).to eq(Datatype::Nil.instance)
        end
      end # context
    end # describe
  end # module
end # module
