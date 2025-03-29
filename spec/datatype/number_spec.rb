# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/datatype/number'

module Loxxy
  module Datatype
    describe Number do
      let(:sample_value) { -12.34 }

      subject(:num_val) { described_class.new(sample_value) }

      context 'Initialization:' do
        it 'accepts a Numeric value at initialization' do
          expect { described_class.new(sample_value) }.not_to raise_error
        end

        it 'knows its value' do
          expect(num_val.value).to eq(sample_value)
        end
      end

      # rubocop: disable Lint/FloatComparison
      context 'Provided services:' do
        it 'compares with other Lox numbers' do
          result = num_val == described_class.new(sample_value)
          expect(result).to be_true

          result = num_val == described_class.new(5)
          expect(result).to be_false
        end

        it 'compares with Ruby numbers' do
          result = num_val == sample_value
          expect(result).to be_true

          result = num_val == 5
          expect(result).to be_false
        end

        it 'gives its display representation' do
          expect(num_val.to_str).to eq(sample_value.to_s)
        end

        it 'computes the addition with another number' do
          addition = num_val + described_class.new(10)
          expect(addition == -2.34).to be_true
        end

        it 'computes the subtraction with another number' do
          subtraction = num_val - described_class.new(10)
          expect(subtraction == -22.34).to be_true
        end
      end # context
      # rubocop: enable Lint/FloatComparison
    end # describe
  end # module
end # module
