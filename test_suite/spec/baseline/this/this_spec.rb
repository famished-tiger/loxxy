# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'this:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'closure.lox'" do
      run_positive_test
    end

    it "passes 'nested_class.lox'" do
      run_positive_test
    end

    it "passes 'nested_closure.lox'" do
      run_positive_test
    end

    it "passes 'this_in_method.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'this_at_top_level.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end

    it "passes 'this_in_top_level_function.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end
  end # context
end # describe
