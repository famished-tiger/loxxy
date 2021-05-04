# frozen_string_literal: true

require 'stringio'

# Mix-in module that provides utility methods to RSpec tests
module LoxFileTester
  def run_positive_test(nonCompliantResult = nil)
    original_dir = Dir.getwd
    Dir.chdir(my_path)

    File.open(lox_filename, 'r') do |f|
      source = f.read
      if nonCompliantResult
        predicted = nonCompliantResult
      else
        expectations = collect_expected_output(source)
        predicted = expectations.join
      end
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

  def scan_file
    original_dir = Dir.getwd
    Dir.chdir(my_path)

    File.open(lox_filename, 'r') do |f|
      source = f.read
      expectations = collect_expected_tokens(source)
      skanner = Loxxy::FrontEnd::Scanner.new(source)
      actuals = skanner.tokens
      actuals.each_with_index do |tok, i|
        (symb, lex) = expectations[i]
        expect(tok.terminal).to eq(symb)
        expect(tok.lexeme).to eq(lex)
      end
    end

    Dir.chdir(original_dir)
  end

  def evaluate_file(aSuffix, hint = nil)
    original_dir = Dir.getwd
    Dir.chdir(my_path)

    File.open(lox_filename, 'r') do |f|
      source = f.read
      source += aSuffix
      lox = Loxxy::Interpreter.new
      if hint
        predicted = hint
      else
        expectations = collect_expected_output(source)
        predicted = expectations.join
      end
      result = lox.evaluate(source)
      expect(result.to_str).to eq(predicted)
    end

    Dir.chdir(original_dir)
  end

  private

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

  def collect_expected_tokens(source)
    tokens = []
    lines = source.split(/(?:\r\n?)|\n/)
    lines.each do |ln|
      next unless ln =~ /\/\/ expect: /

      expected = ln.split('// expect: ')[1]
      duo = expected.scan(/\S+/)[0..1]
      tokens << duo.map { |item| (item == 'null') ? nil : item }
    end

    tokens
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
