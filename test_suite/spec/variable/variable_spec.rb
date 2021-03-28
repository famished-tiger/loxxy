# frozen_string_literal: true

require 'loxxy'
require_relative '../spec_helper'
require 'stringio'

describe Loxxy do
  context 'Invalid variable declarations:' do
    it 'should complain when a local variable is re-declared' do
      lox_snippet = <<-LOX_END
        {
          var a = "value";
          var a = "other";
        }
      LOX_END
      io = StringIO.new
      cfg = { ostream: io }
      err = StandardError
      err_msg = "Error at 'a': Already variable with this name in this scope."
      lox = Loxxy::Interpreter.new(cfg)
      expect { lox.evaluate(lox_snippet) }.to raise_error(err, err_msg)
    end
  end # context
end # describe
