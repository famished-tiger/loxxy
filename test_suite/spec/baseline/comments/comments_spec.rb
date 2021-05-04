# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Commnents:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'line_at_eof.lox'" do
      run_positive_test
    end

    it "passes 'only_line_comment.lox'" do
      run_positive_test
    end

    it "passes 'only_line_comment_and_line.lox'" do
      run_positive_test
    end

    it "passes 'unicode.lox'" do
      run_positive_test
    end
  end # context
end # describe
