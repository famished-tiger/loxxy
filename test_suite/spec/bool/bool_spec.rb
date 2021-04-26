# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'bool literals:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'equality.lox'" do
      run_positive_test
    end

    it "passes 'not.lox'" do
      run_positive_test
    end
  end # context
end # describe
