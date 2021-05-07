# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'limit:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Invalid cases:' do
    it "passes 'too_many_locals.lox'" do
      err_msg = "Error at 'oops': Too many local variables in function."
      run_negative_test(Loxxy::RuntimeError, err_msg)
    end
  end # context
end # describe
