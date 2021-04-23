# frozen_string_literal: true

require_relative 'ast_visitee'

module Loxxy
  module Ast
    # Abstract class.
    # Instances of its subclasses represent nodes of an abstract syntax tree
    # that is the product of the parse of an input text.
    class LoxNode
      # Let nodes take `visitee` role as defined in the Visitor design pattern
      extend ASTVisitee

      # return [Rley::Lexical::Position] Position of the entry in the input stream.
      attr_reader :position

      # @param aPosition [Rley::Lexical::Position] Position of the entry in the input stream.
      def initialize(aPosition)
        @position = aPosition
      end

      # Notification that the parsing was successfully completed
      def done!
        # Default: do nothing ...
      end

      # Abstract method (must be overriden in subclasses).
      # Part of the 'visitee' role in Visitor design pattern.
      # @param _visitor [LoxxyTreeVisitor] the visitor
      def accept(_visitor)
        raise NotImplementedError
      end
    end # class
  end # module
end # module
