# frozen_string_literal: true

require_relative 'loxxy/version'
require_relative 'loxxy/interpreter'
require_relative 'loxxy/front_end/raw_parser'

# Namespace for all classes and constants of __loxxy__ gem.
module Loxxy
  class Error < StandardError; end

  # Shorthand method. Returns the sole object that represents
  # a Lox false literal.
  # @return [Loxxy::Datatype::False]
  def self.lox_false
    Datatype::False.instance
  end

  # Shorthand method. Returns the sole object that represents
  # a Lox nil literal.
  # @return [Loxxy::Datatype::Nil]
  def self.lox_nil
    Datatype::Nil.instance
  end

  # Shorthand method. Returns the sole object that represents
  # a Lox true literal.
  # @return [Loxxy::Datatype::True]
  def self.lox_true
    Datatype::True.instance
  end
end
