# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Constructor:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'range.lox'" do
      # initialize calls a function with nested return expression
      run_positive_test
    end

    it "passes 'line.lox'" do
      # Test calling a constructor inside an 'init' method
      run_positive_test
    end
  end # context
end # describe
