# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'

describe 'Additional tests:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'empty_file.lox'" do
      run_positive_test
    end

    it "passes 'precedence.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'unexpected_character.lox'" do
      # Non-compliant message: improved message compared to standard
      err_msg = 'Error: [line 3:7]: Unexpected character.'
      run_negative_test(Loxxy::ScanError, err_msg)
    end
  end # context
end # describe
