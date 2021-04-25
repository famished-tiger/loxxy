# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'Field:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'closure_in_body.lox'" do
      run_positive_test
    end

    it "passes 'closure_in_body.lox'" do
      run_positive_test
    end

    it "passes 'return_closure.lox'" do
      run_positive_test
    end

    it "passes 'return_inside.lox'" do
      run_positive_test
    end

    it "passes 'scope.lox'" do
      run_positive_test
    end

    it "passes 'scope.lox'" do
      run_positive_test
    end

    # FAILS!!!!!
    it "passes 'syntax.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'class_in_body.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'fun_in_body.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'statement_condition.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'statement_increment.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'statement_initializer.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end

    it "passes 'var_in_body.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end
  end # context
end # describe
