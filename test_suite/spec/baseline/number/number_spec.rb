# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Number:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'literals.lox'" do
      # Non-compliance: in Lox print -0; // => "-0", in Loxxy the output is "0"
      run_positive_test('12398765400123.456-0.001')
    end

    it "passes 'nan_equality.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'decimal_point_at_eof.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'leading_dot.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'trailing_dot.lox'" do
      # Non-compliant error message
      # But standard message isn't correct too...
      run_negative_test(Loxxy::SyntaxError)
    end
  end # context
end # describe
