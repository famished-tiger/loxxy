# frozen_string_literal: true

require_relative 'lox_node'

module Loxxy
  module Ast
    # rubocop: disable Style/AccessorGrouping
    class LoxFunStmt < LoxNode
      attr_reader :name
      attr_reader :params
      attr_reader :body
      attr_accessor :is_method

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      # @param aName [String]
      # @param arguments [Array<String>]
      # @param body [Ast::LoxBlockStmt]
      def initialize(aPosition, aName, paramList, aBody)
        super(aPosition)
        @name = aName.dup
        @params = paramList
        @body = aBody
        @is_method = false
      end

      define_accept # Add `accept` method as found in Visitor design pattern
    end # class
    # rubocop: enable Style/AccessorGrouping
  end # module
end # module
