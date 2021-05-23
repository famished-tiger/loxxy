# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'method:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'arity.lox'" do
      run_positive_test
    end

    it "passes 'empty_block.lox'" do
      run_positive_test
    end

    it "passes 'print_bound_method.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'extra_arguments.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end

    it "passes 'missing_arguments.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end

    it "passes 'not_found.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end

    it "passes 'refer_to_name.lox'" do
      # Non-compliant error message
      err_msg = "[line 3:11] Undefined variable 'method'."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'too_many_arguments.lox'" do
      run_negative_test(Loxxy::RuntimeError, nil)
    end

    it "passes 'too_many_parameters.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end
  end # context
end # describe
