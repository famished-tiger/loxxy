# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'Field:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'call_function_field.lox'" do
      run_positive_test
    end

    it "passes 'get_and_set_method.lox'" do
      run_positive_test
    end

    it "passes 'many.lox'" do
      run_positive_test
    end

    it "passes 'method.lox'" do
      run_positive_test
    end

    it "passes 'method_binds_this.lox'" do
      run_positive_test
    end

    it "passes 'on_instance.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'call_nonfunction_field.lox'" do
      run_negative_test
    end

    it "passes 'get_on_bool.lox'" do
      run_negative_test
    end

    it "passes 'get_on_class.lox'" do
      run_negative_test
    end

    it "passes 'get_on_function.lox'" do
      run_negative_test
    end

    it "passes 'get_on_num.lox'" do
      run_negative_test
    end

    it "passes 'get_on_string.lox'" do
      run_negative_test
    end

    it "passes 'set_evaluation_order.lox'" do
      run_negative_test
    end

    it "passes 'set_on_bool.lox'" do
      run_negative_test
    end

    it "passes 'set_on_class.lox'" do
      run_negative_test
    end

    it "passes 'set_on_function.lox'" do
      run_negative_test
    end

    it "passes 'set_on_nil.lox'" do
      run_negative_test
    end

    it "passes 'set_on_num.lox'" do
      run_negative_test
    end

    it "passes 'set_on_string.lox'" do
      run_negative_test
    end

    it "passes 'undefined.lox'" do
      run_negative_test
    end
  end # context
end # describe
