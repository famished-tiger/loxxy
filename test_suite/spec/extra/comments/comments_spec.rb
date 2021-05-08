# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Commnents (non-std):' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'block_comments.lox'" do
      run_positive_test
    end

    it "passes 'nested_blocks.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'unterminated_comment.lox'" do
      run_negative_test(Loxxy::ScanError)
    end

    it "passes 'nested_unterminated.lox'" do
      run_negative_test(Loxxy::ScanError)
    end
  end # context
end # describe
