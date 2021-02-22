# frozen_string_literal: true

module Loxxy
  # Abstract class. Generalization of Loxxy error classes.
  class Error < StandardError ; end
  
  # Error occurring while Loxxy executes some invalid Lox code.
  class RuntimeError < Error ; end
end
