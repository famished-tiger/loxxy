# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'logical operator:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'and.lox'" do
      run_positive_test
    end

    it "passes 'and_truth.lox'" do
      run_positive_test
    end

    it "passes 'or.lox'" do
      run_positive_test
    end

    it "passes 'or_truth.lox'" do
      run_positive_test
    end
  end # context
end # describe
