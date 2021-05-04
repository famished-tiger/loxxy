# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'scanning:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'identifiers.lox'" do
      scan_file
    end

    it "passes 'keywords.lox'" do
      scan_file
    end

    it "passes 'numbers.lox'" do
      scan_file
    end

    it "passes 'punctuators.lox'" do
      scan_file
    end

    it "passes 'strings.lox'" do
      scan_file
    end

    it "passes 'whitespace.lox'" do
      scan_file
    end
  end # context
end # describe
