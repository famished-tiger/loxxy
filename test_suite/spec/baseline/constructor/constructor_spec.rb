# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Constructor:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'arguments.lox'" do
      run_positive_test
    end

    it "passes 'call_init_early_return.lox'" do
      run_positive_test
    end

    it "passes 'call_init_explicitly.lox'" do
      run_positive_test
    end

    it "passes 'default.lox'" do
      run_positive_test
    end

    it "passes 'early_return.lox'" do
      run_positive_test
    end

    it "passes 'init_not_method.lox'" do
      run_positive_test
    end

    it "passes 'return_in_nested_function.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'default_arguments.lox'" do
      run_negative_test
    end

    it "passes 'extra_arguments.lox'" do
      run_negative_test
    end

    it "passes 'missing_arguments.lox'" do
      run_negative_test
    end

    it "passes 'return_value.lox'" do
      # Message is standard
      err_msg = "Error at 'return': Can't return a value from an initializer."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end
  end # context
end # describe
