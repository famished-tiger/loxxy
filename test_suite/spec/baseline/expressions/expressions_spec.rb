# frozen_string_literal: true

require 'loxxy'
require_relative '../../spec_helper'

describe 'Expressions:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'evaluate.lox'" do
      evaluate_file(';')
    end

    it "passes 'parse.lox'" do
      evaluate_file(';', '2')
    end
  end # context
end # describe
