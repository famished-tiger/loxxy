# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'regression tests:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes '40.lox'" do
      run_positive_test
    end

    it "passes '394.lox'" do
      run_positive_test
    end
  end # context
end # describe
