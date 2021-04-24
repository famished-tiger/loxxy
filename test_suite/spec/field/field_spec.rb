# frozen_string_literal: true

require 'stringio'
require 'loxxy'
require_relative '../spec_helper'

module LoxFileTester
  def run_positive_test
    original_dir = Dir.getwd
    Dir.chdir(my_path)

    File.open(lox_filename, 'r') do |f|
      source = f.read
      expectations = collect_expected_output(source)
      predicted = expectations.join
      io = interpret2string_io(source)
      expect(io.string).to eq(predicted)
    end

    Dir.chdir(original_dir)
  end

  def run_negative_test(err_arg = nil, err_msg_arg = nil)
    original_dir = Dir.getwd
    Dir.chdir(my_path)

    File.open(lox_filename, 'r') do |f|
      source = f.read
      lox_err, lox_err_msg = expected_error(source)
      err = err_arg || lox_err
      msg = err_msg_arg || lox_err_msg
      lox = Loxxy::Interpreter.new
      expect { lox.evaluate(source) }.to raise_error(err, msg)
    end

    Dir.chdir(original_dir)
  end

  def interpret2string_io(source)
    io = StringIO.new
    cfg = { ostream: io }
    lox = Loxxy::Interpreter.new(cfg)
    lox.evaluate(source)

    io
  end

  def lox_filename
    # Dependency on RSpec
    title = instance_variable_get(:@__inspect_output)
    title.split("'")[1]
  end

  def collect_expected_output(source)
    output = []
    lines = source.split(/(?:\r\n?)|\n/)
    lines.each do |ln|
      next unless ln =~ /\/\/ expect: /

      expected = ln.split('// expect: ')[1]
      output << expected
    end

    output
  end

  def expected_error(source)
    txt2exception = {
      'runtime' => Loxxy::RuntimeError
    }
    err = nil
    err_msg = nil

    lines = source.split(/(?:\r\n?)|\n/)
    lines.each do |ln|
      next unless ln =~ /\/\/ expect .+ error: /

      expected = ln.split('// expect ')[1]
      error_type, err_msg = expected.split(' error: ')
      err = txt2exception[error_type]
    end

    [err, err_msg]
  end
end

describe 'Field:' do
  include LoxFileTester

  let(:my_path) { __FILE__.sub(/\/[^\/]+$/, '/') }

  context 'Valid cases:' do
    it "passes 'call_function_field.lox'" do
      run_positive_test
    end

    it "passes 'get_and_set_method.lox'" do
      run_positive_test
    end

    it "passes 'many.lox'" do
      run_positive_test
    end

    it "passes 'method.lox'" do
      run_positive_test
    end

    it "passes 'method_binds_this.lox'" do
      run_positive_test
    end

    it "passes 'on_instance.lox'" do
      run_positive_test
    end
  end # context

  context 'Invalid cases:' do
    it "passes 'call_nonfunction_field.lox'" do
      run_negative_test
    end

    it "passes 'get_on_bool.lox'" do
      run_negative_test
    end

    it "passes 'get_on_class.lox'" do
      run_negative_test
    end

    it "passes 'get_on_function.lox'" do
      run_negative_test
    end

    it "passes 'get_on_num.lox'" do
      run_negative_test
    end

    it "passes 'get_on_string.lox'" do
      run_negative_test
    end

    it "passes 'set_evaluation_order.lox'" do
      run_negative_test
    end

    it "passes 'set_on_bool.lox'" do
      run_negative_test
    end

    it "passes 'set_on_class.lox'" do
      run_negative_test
    end

    it "passes 'set_on_function.lox'" do
      run_negative_test
    end

    it "passes 'set_on_nil.lox'" do
      run_negative_test
    end

    it "passes 'set_on_num.lox'" do
      run_negative_test
    end

    it "passes 'set_on_string.lox'" do
      run_negative_test
    end

    it "passes 'undefined.lox'" do
      run_negative_test
    end
  end # context
end # describe
