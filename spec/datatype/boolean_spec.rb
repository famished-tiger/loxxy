# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/datatype/boolean'

module Loxxy
  module Datatype
    describe Boolean do
      let(:thruth_value) { false }
      subject { Boolean.new(thruth_value) }

      context 'Initialization:' do
        it 'should accept a boolean value at initialization' do
          expect { Boolean.new(thruth_value) }.not_to raise_error
        end

        it 'should know its value' do
          expect(subject.value).to eq(thruth_value)
        end
      end

      context 'Provided services:' do
        it 'should give its display representation' do
          expect(subject.to_str).to eq('false')
        end
      end
    end # describe
  end # module
end # module
