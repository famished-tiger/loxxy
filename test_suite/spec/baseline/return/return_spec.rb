# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'return:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'after_else.lox'" do
      run_positive_test
    end

    it "passes 'after_if.lox'" do
      run_positive_test
    end

    it "passes 'after_while.lox'" do
      run_positive_test
    end

    it "passes 'in_function.lox'" do
      run_positive_test
    end

    it "passes 'in_method.lox'" do
      run_positive_test
    end

    it "passes 'return_nil_if_no_value.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'at_top_level.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end
  end # context
end # describe
