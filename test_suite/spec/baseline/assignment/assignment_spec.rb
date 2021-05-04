# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'assignment:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'associativity.lox'" do
      run_positive_test
    end

    it "passes 'global.lox'" do
      run_positive_test
    end

    it "passes 'local.lox'" do
      run_positive_test
    end

    it "passes 'syntax.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'grouping.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'infix_operator.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'prefix_operator.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'to_this.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'undefined.lox'" do
      # Non-compliant error message
      run_negative_test
    end
  end # context
end # describe
