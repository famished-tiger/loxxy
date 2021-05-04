# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'print statement:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Invalid cases:' do
    it "passes 'missing_argument.lox'" do
      # Non-compliant error message
      run_negative_test(Loxxy::SyntaxError, nil)
    end
  end # context
end # describe
