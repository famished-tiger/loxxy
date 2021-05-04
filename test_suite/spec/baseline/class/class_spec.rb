# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Class:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'empty.lox'" do
      run_positive_test
    end

    it "passes 'inherited_method.lox'" do
      run_positive_test
    end

    it "passes 'local_inherit_other.lox'" do
      run_positive_test
    end

    it "passes 'local_reference_self.lox'" do
      run_positive_test
    end

    it "passes 'reference_self.lox'" do
      run_positive_test
    end
  end # context

  context 'Valid cases:' do
    it "passes 'inherit_self.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end

    it "passes 'local_inherit_self.lox'" do
      run_negative_test(Loxxy::RuntimeError)
    end
  end # context
end # describe
