# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Logical expression (non-std):' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'second_operand_variable.lox'" do
      run_positive_test
    end
  end # context
end # describe
