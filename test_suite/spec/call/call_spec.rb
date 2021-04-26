# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'Callee:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Invalid cases:' do
    it "passes 'bool.lox'" do
      run_negative_test
    end

    it "passes 'nil.lox'" do
      run_negative_test
    end

    it "passes 'num.lox'" do
      run_negative_test
    end

    it "passes 'object.lox'" do
      run_negative_test
    end

    it "passes 'string.lox'" do
      run_negative_test
    end
  end # context
end # describe
