# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'if statement:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'dangling_else.lox'" do
      run_positive_test
    end

    it "passes 'else.lox'" do
      run_positive_test
    end

    it "passes 'if.lox'" do
      run_positive_test
    end

    it "passes 'truth.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'class_in_else.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'class_in_then.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'fun_in_else.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'fun_in_then.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'var_in_else.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'var_in_then.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end
  end # context
end # describe
