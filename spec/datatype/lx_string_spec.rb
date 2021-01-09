# frozen_string_literal: true

require_relative '../spec_helper' # Use the RSpec framework

# Load the class under test
require_relative '../../lib/loxxy/datatype/lx_string'

module Loxxy
  module Datatype
    describe LXString do
      let(:sample_text) { 'some_text' }
      subject { LXString.new(sample_text) }

      context 'Initialization:' do
        it 'should accept a String value at initialization' do
          expect { LXString.new(sample_text) }.not_to raise_error
        end

        it 'should know its value' do
          expect(subject.value).to eq(sample_text)
        end
      end

      context 'Provided services:' do
        it 'should give its display representation' do
          expect(subject.to_str).to eq(sample_text)
        end

        it 'compares with another string' do
          expect(subject).to eq(sample_text)
          expect(subject).to eq(LXString.new(sample_text.dup))

          expect(subject).not_to eq('')
          expect(subject).not_to eq('other-text')
        end
      end
    end # describe
  end # module
end # module
