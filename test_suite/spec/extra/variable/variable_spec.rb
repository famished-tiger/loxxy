# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Variable (non-std):' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Invalid cases:' do
    it "passes 'unknown_variable_expr.lox'" do
      run_negative_test
    end
  end # context
end # describe
