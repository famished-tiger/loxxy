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
        it 'should give its display representation' do
          expect(subject.to_str).to eq(sample_value.to_s)
        end
      end
    end # describe
  end # module
end # module
