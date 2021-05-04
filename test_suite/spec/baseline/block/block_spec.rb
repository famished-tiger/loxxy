# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Block:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'empty.lox'" do
      run_positive_test
    end

    it "passes 'scope.lox'" do
      run_positive_test
    end
  end # context
end # describe
