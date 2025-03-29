# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/datatype/lx_string'

module Loxxy
  module Datatype
    describe LXString do
      let(:sample_text) { 'some_text' }

      subject(:a_string) { described_class.new(sample_text) }

      context 'Initialization:' do
        it 'accepts a String value at initialization' do
          expect { described_class.new(sample_text) }.not_to raise_error
        end

        it 'knows its value' do
          expect(a_string.value).to eq(sample_text)
        end
      end

      context 'Provided services:' do
        it 'gives its display representation' do
          expect(a_string.to_str).to eq(sample_text)
        end

        # rubocop: disable Lint/BinaryOperatorWithIdenticalOperands
        it 'compares with another Lox string' do
          result = a_string == described_class.new(sample_text.dup)
          expect(result).to be_true

          result = a_string == described_class.new('other-text')
          expect(result).to be_false

          result = a_string == described_class.new('')
          expect(result).to be_false

          # Two empty strings are equal
          result = described_class.new('') == described_class.new('')
          expect(result).to be_true
        end
        # rubocop: enable Lint/BinaryOperatorWithIdenticalOperands

        it 'compares with a Ruby string' do
          result = a_string == sample_text.dup
          expect(result).to be_true

          result = a_string == 'other-text'
          expect(result).to be_false

          result = a_string == ''
          expect(result).to be_false
        end

        it 'performs the concatenation with another string' do
          concatenation = described_class.new('str') + described_class.new('ing')
          expect(concatenation == 'string').to be_true
        end
      end
    end # describe
  end # module
end # module
