# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'super expression:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'bound_method.lox'" do
      run_positive_test
    end

    it "passes 'call_other_method.lox'" do
      run_positive_test
    end

    it "passes 'call_same_method.lox'" do
      run_positive_test
    end

    it "passes 'closure.lox'" do
      run_positive_test
    end

    it "passes 'constructor.lox'" do
      run_positive_test
    end

    it "passes 'indirectly_inherited.lox'" do
      run_positive_test
    end

    it "passes 'reassign_superclass.lox'" do
      run_positive_test
    end

    it "passes 'super_in_closure_in_inherited_method.lox'" do
      run_positive_test
    end

    it "passes 'super_in_inherited_method.lox'" do
      run_positive_test
    end

    it "passes 'this_in_superclass_method.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'extra_arguments.lox'" do
      run_negative_test
    end

    it "passes 'missing_arguments.lox'" do
      run_negative_test
    end

    it "passes 'no_superclass_bind.lox'" do
      # Standard error message
      err_msg = "Error at 'super': Can't use 'super' in a class without superclass."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'no_superclass_call.lox'" do
      # Standard error message
      err_msg = "Error at 'super': Can't use 'super' in a class without superclass."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'no_superclass_method.lox'" do
      run_negative_test
    end

    it "passes 'parenthesized.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'super_at_top_level.lox'" do
      # Standard error message
      err_msg = "Error at 'super': Can't use 'super' outside of a class."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'super_in_top_level_function.lox'" do
      # Standard error message
      err_msg = "Error at 'super': Can't use 'super' outside of a class."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'super_without_dot.lox'" do
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'super_without_name.lox'" do
      run_negative_test(Loxxy::SyntaxError)
    end
  end # context
end # describe
