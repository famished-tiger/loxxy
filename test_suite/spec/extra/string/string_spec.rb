# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'String (non-std):' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'escaped_quotes.lox'" do
      run_positive_test
    end

    it "passes 'escaped_backslash.lox'" do
      run_positive_test
      # run_positive_test("1\n2\n3") # Parsing expectations ignores newlines
    end

    it "passes 'newlines.lox'" do
      run_positive_test("1\n2\n3")
    end
  end # context
end # describe
