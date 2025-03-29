# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/datatype/boolean'

module Loxxy
  module Datatype
    describe Boolean do
      let(:truth_value) { false }

      subject(:a_boolean) { described_class.new(truth_value) }

      context 'Initialization:' do
        it 'accepts a boolean value at initialization' do
          expect { described_class.new(truth_value) }.not_to raise_error
        end

        it 'knows its value' do
          expect(a_boolean.value).to eq(truth_value)
        end
      end

      context 'Provided services:' do
        it 'gives its display representation' do
          expect(a_boolean.to_str).to eq('false')
        end
      end
    end # describe
  end # module
end # module
