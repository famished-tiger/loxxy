# frozen_string_literal: true

module Loxxy
  module Ast
    class LoxNode
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

      # Abstract method.
      # Part of the 'visitee' role in Visitor design pattern.
      # @param _visitor [LoxxyTreeVisitor] the visitor
      def accept(_visitor)
        raise NotImplementedError
      end
    end # class
  end # module
end # module
