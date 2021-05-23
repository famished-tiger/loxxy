# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'String:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'literals.lox'" do
      run_positive_test
    end

    it "passes 'multiline.lox'" do
      run_positive_test("1\n2\n3") # Parsing expectations ignores newlines
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'error_after_multiline.lox'" do
      # Non-compliant error message:
      err_msg = "[line 7:1] Undefined variable 'err'."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end

    it "passes 'unterminated.lox'" do
      # Non-compliant error message:
      err_msg = 'Error: [line 2:1]: Unterminated string.'
      run_negative_test(Loxxy::ScanError, err_msg)
    end
  end # context
end # describe
