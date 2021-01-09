# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/datatype/boolean'

module Loxxy
  module Datatype
    describe Nil do
      subject { Nil.instance }

      context 'Initialization:' do
        it 'should know its value' do
          expect(subject.value).to be_nil
        end
      end

      context 'Provided services:' do
        it 'should give its display representation' do
          expect(subject.to_str).to eq('nil')
        end
      end
    end # describe
  end # module
end # module
