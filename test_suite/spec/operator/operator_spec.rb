# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'Operators:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'add.lox'" do
      run_positive_test
    end

    it "passes 'comparison.lox'" do
      run_positive_test
    end

    it "passes 'divide.lox'" do
      # Non compliant output
      run_positive_test('41.0') # jlox returns '41'
    end

    it "passes 'equals.lox'" do
      run_positive_test
    end

    it "passes 'equals_class.lox'" do
      run_positive_test
    end

    it "passes 'equals_method.lox'" do
      run_positive_test
    end

    it "passes 'multiply.lox'" do
      run_positive_test
    end

    it "passes 'negate.lox'" do
      run_positive_test
    end

    it "passes 'not.lox'" do
      run_positive_test
    end

    it "passes 'not_class.lox'" do
      run_positive_test
    end

    it "passes 'not_equals.lox'" do
      run_positive_test
    end

    it "passes 'subtract.lox'" do
      # Non compliant output
      run_positive_test('10.0') # jlox returns '10'
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'add_bool_nil.lox'" do
      run_negative_test
    end

    it "passes 'add_bool_num.lox'" do
      run_negative_test
    end

    it "passes 'add_bool_string.lox'" do
      run_negative_test
    end

    it "passes 'add_nil_nil.lox'" do
      run_negative_test
    end

    it "passes 'add_num_nil.lox'" do
      run_negative_test
    end

    it "passes 'add_string_nil.lox'" do
      run_negative_test
    end

    it "passes 'divide_nonnum_num.lox'" do
      run_negative_test
    end

    it "passes 'divide_num_nonnum.lox'" do
      run_negative_test
    end

    it "passes 'greater_nonnum_num.lox'" do
      run_negative_test
    end

    it "passes 'greater_num_nonnum.lox'" do
      run_negative_test
    end

    it "passes 'greater_or_equal_nonnum_num.lox'" do
      run_negative_test
    end

    it "passes 'greater_or_equal_num_nonnum.lox'" do
      run_negative_test
    end

    it "passes 'less_nonnum_num.lox'" do
      run_negative_test
    end

    it "passes 'less_num_nonnum.lox'" do
      run_negative_test
    end

    it "passes 'less_nonnum_num.lox'" do
      run_negative_test
    end

    it "passes 'less_or_equal_nonnum_num.lox'" do
      run_negative_test
    end

    it "passes 'less_or_equal_num_nonnum.lox'" do
      run_negative_test
    end

    it "passes 'multiply_nonnum_num.lox'" do
      run_negative_test
    end

    it "passes 'multiply_num_nonnum.lox'" do
      run_negative_test
    end

    it "passes 'negate_nonnum.lox'" do
      run_negative_test
    end

    it "passes 'multiply_num_nonnum.lox'" do
      run_negative_test
    end

    it "passes 'subtract_nonnum_num.lox'" do
      run_negative_test
    end

    it "passes 'subtract_num_nonnum.lox'" do
      run_negative_test
    end
  end # context
end # describe
