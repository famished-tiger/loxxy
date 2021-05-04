# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Inheritance:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'constructor.lox'" do
      run_positive_test
    end

    it "passes 'inherit_methods.lox'" do
      run_positive_test
    end

    it "passes 'set_fields_from_base_class.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'inherit_from_function.lox'" do
      run_negative_test
    end

    it "passes 'inherit_from_nil.lox'" do
      run_negative_test
    end

    it "passes 'inherit_from_number.lox'" do
      run_negative_test
    end

    it "passes 'parenthesized_superclass.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end
  end # context
end # describe
