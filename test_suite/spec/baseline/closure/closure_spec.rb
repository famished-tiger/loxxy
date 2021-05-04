# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Closures:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'assign_to_closure.lox'" do
      run_positive_test
    end

    it "passes 'assign_to_shadowed_later.lox'" do
      run_positive_test
    end

    it "passes 'closed_closure_in_function.lox'" do
      run_positive_test
    end

    it "passes 'close_over_function_parameter.lox'" do
      run_positive_test
    end

    it "passes 'close_over_later_variable.lox'" do
      run_positive_test
    end

    it "passes 'close_over_method_parameter.lox'" do
      run_positive_test
    end

    it "passes 'nested_closure.lox'" do
      run_positive_test
    end

    it "passes 'open_closure_in_function.lox'" do
      run_positive_test
    end

    it "passes 'reference_closure_multiple_times.lox'" do
      run_positive_test
    end

    it "passes 'reuse_closure_slot.lox'" do
      run_positive_test
    end

    it "passes 'shadow_closure_with_local.lox'" do
      run_positive_test
    end

    it "passes 'unused_closure.lox'" do
      run_positive_test
    end

    it "passes 'unused_later_closure.lox'" do
      run_positive_test
    end
  end # context
end # describe
