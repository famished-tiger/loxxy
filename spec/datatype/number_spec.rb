# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/datatype/number'

module Loxxy
  module Datatype
    describe Number do
      let(:sample_value) { -12.34 }
      subject { Number.new(sample_value) }

      context 'Initialization:' do
        it 'should accept a Numeric value at initialization' do
          expect { Number.new(sample_value) }.not_to raise_error
        end

        it 'should know its value' do
          expect(subject.value).to eq(sample_value)
        end
      end

      context 'Provided services:' do
        it 'should compare with other Lox numbers' do
          result = subject == Number.new(sample_value)
          expect(result).to be_true

          result = subject == Number.new(5)
          expect(result).to be_false
        end

        it 'should compare with Ruby numbers' do
          result = subject == sample_value
          expect(result).to be_true

          result = subject == 5
          expect(result).to be_false
        end

        it 'should give its display representation' do
          expect(subject.to_str).to eq(sample_value.to_s)
        end

        it 'should compute the addition with another number' do
          addition = subject + Number.new(10)
          expect(addition == -2.34).to be_true
        end

        it 'should compute the subtraction with another number' do
          subtraction = subject - Number.new(10)
          expect(subtraction == -22.34).to be_true
        end
      end
    end # describe
  end # module
end # module
