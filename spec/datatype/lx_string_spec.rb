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

        it 'compares with another Lox string' do
          result = subject == LXString.new(sample_text.dup)
          expect(result).to be_true

          result = subject == LXString.new('other-text')
          expect(result).to be_false

          result = subject == LXString.new('')
          expect(result).to be_false

          # Two empty strings are equal
          result = LXString.new('') == LXString.new('')
          expect(result).to be_true
        end

        it 'compares with a Ruby string' do
          result = subject == sample_text.dup
          expect(result).to be_true

          result = subject == 'other-text'
          expect(result).to be_false

          result = subject == ''
          expect(result).to be_false
        end

        it 'performs the concatenation with another string' do
          concatenation = LXString.new('str') + LXString.new('ing')
          expect(concatenation == 'string').to be_true
        end
      end
    end # describe
  end # module
end # module
