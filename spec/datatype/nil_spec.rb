# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/datatype/boolean'

module Loxxy
  module Datatype
    describe Nil do
      subject(:nil_literal) { described_class.instance }

      context 'Initialization:' do
        it 'knows its value' do
          expect(nil_literal.value).to be_nil
        end
      end

      context 'Provided services:' do
        it 'gives its display representation' do
          expect(nil_literal.to_str).to eq('nil')
        end
      end
    end # describe
  end # module
end # module
