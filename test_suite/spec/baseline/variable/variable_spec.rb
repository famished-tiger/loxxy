# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Variable:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'early_bound.lox'" do
      run_positive_test
    end

    it "passes 'in_middle_of_block.lox'" do
      run_positive_test
    end

    it "passes 'in_nested_block.lox'" do
      run_positive_test
    end

    it "passes 'local_from_method.lox'" do
      run_positive_test
    end

    it "passes 'redeclare_global.lox'" do
      run_positive_test
    end

    it "passes 'redefine_global.lox'" do
      run_positive_test
    end

    it "passes 'scope_reuse_in_different_blocks.lox'" do
      run_positive_test
    end

    it "passes 'shadow_and_local.lox'" do
      run_positive_test
    end

    it "passes 'shadow_global.lox'" do
      run_positive_test
    end

    it "passes 'shadow_local.lox'" do
      run_positive_test
    end

    it "passes 'uninitialized.lox'" do
      run_positive_test
    end

    it "passes 'unreached_undefined.lox'" do
      run_positive_test
    end

    it "passes 'use_global_in_initializer.lox'" do
      # passes the test but ...
      # ... standard behaviour is questionable
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'collide_with_parameter.lox'" do
      # Standard message
      err_msg = "Error at 'a': Already variable with this name in this scope."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'duplicate_local.lox'" do
      # Standard message
      err_msg = "Error at 'a': Already variable with this name in this scope."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'duplicate_parameter.lox'" do
      # Standard message
      err_msg = "Error at 'arg': Already variable with this name in this scope."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'undefined_global.lox'" do
      # Non-compliant message
      err_msg = "[line 1:7] Undefined variable 'notDefined'."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'undefined_local.lox'" do
      # Non-compliant message
      err_msg = "[line 2:9] Undefined variable 'notDefined'."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'use_false_as_var.lox'" do
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'use_local_in_initializer.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end

    it "passes 'use_nil_as_var.lox'" do
      # non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end

    it "passes 'use_this_as_var.lox'" do
      # non-compliant error message
      run_negative_test(Loxxy::SyntaxError)
    end
  end # context
end # describe
