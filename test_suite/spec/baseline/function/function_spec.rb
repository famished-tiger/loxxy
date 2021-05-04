# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Function:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'empty_body.lox'" do
      run_positive_test
    end

    it "passes 'local_recursion.lox'" do
      run_positive_test
    end

    it "passes 'mutual_recursion.lox'" do
      run_positive_test
    end

    it "passes 'nested_call_with_arguments.lox'" do
      run_positive_test
    end

    it "passes 'parameters.lox'" do
      run_positive_test
    end

    it "passes 'print.lox'" do
      run_positive_test
    end

    it "passes 'recursion.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'body_must_be_block.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'extra_arguments.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end

    it "passes 'local_mutual_recursion.lox'" do
      run_negative_test
    end

    it "passes 'missing_arguments.lox'" do
      run_negative_test
    end

    it "passes 'missing_comma_in_parameters.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'missing_comma_in_parameters.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'too_many_arguments.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end

    it "passes 'too_many_parameters.lox'" do
      run_negative_test(Loxxy::SyntaxError)
    end
  end # context
end # describe
