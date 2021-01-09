# frozen_string_literal: true

module Loxxy
  module Ast
    class ASTVisitor
      # Link to the top node to visit
      attr_reader(:top)

      # List of objects that subscribed to the visit event notification.
      attr_reader(:subscribers)

      # attr_reader(:runtime)

      # Build a visitor for the given top.
      # @param aRoot [AST::LoxNode] the parse tree to visit.
      def initialize(aTop)
        raise StandardError if aTop.nil?

        @top = aTop
        @subscribers = []
      end

      # Add a subscriber for the visit event notifications.
      # @param aSubscriber [Object]
      def subscribe(aSubscriber)
        subscribers << aSubscriber
      end

      # Remove the given object from the subscription list.
      # The object won't be notified of visit events.
      # @param aSubscriber [Object]
      def unsubscribe(aSubscriber)
        subscribers.delete_if { |entry| entry == aSubscriber }
      end

      # The signal to begin the visit of the top.
      def start # (aRuntime)
        # @runtime = aRuntime
        top.accept(self)
      end

      # Visit event. The visitor is about to visit the ptree.
      # @param aParseTree [Rley::PTre::ParseTree] the ptree to visit.
      def start_visit_ptree(aParseTree)
        broadcast(:before_ptree, aParseTree)
      end

      # Visit event. The visitor has completed the visit of the ptree.
      # @param aParseTree [Rley::PTre::ParseTree] the visited ptree.
      def end_visit_ptree(aParseTree)
        broadcast(:after_ptree, aParseTree)
      end

      # Visit event. The visitor is about to visit a print statement expression.
      # @param aPrintStmt [AST::LOXPrintStmt] the print statement node to visit
      def visit_print_stmt(aPrintStmt)
        broadcast(:before_print_stmt, aPrintStmt)
        traverse_subnodes(aPrintStmt)
        broadcast(:after_print_stmt, aPrintStmt)
      end

      # Visit event. The visitor is visiting the
      # given terminal node containing a datatype object.
      # @param aLiteralExpr [AST::LoxLiteralExpr] the leaf node to visit.
      def visit_literal_expr(aLiteralExpr)
        broadcast(:before_literal_expr, aLiteralExpr)
        broadcast(:after_literal_expr, aLiteralExpr)
      end

      # Visit event. The visitor is about to visit the given non terminal node.
      # @param aNonTerminalNode [Rley::PTre::NonTerminalNode] the node to visit.
      def visit_nonterminal(_non_terminal_node)
        # Loxxy interpreter encountered a CST node (Concrete Syntax Tree)
        # that it cannot handle.
        raise NotImplementedError, 'Loxxy cannot execute this code yet.'
      end

      private

      # Visit event. The visitor is about to visit the subnodes of a non
      # terminal node.
      # @param aParentNode [Ast::LocCompoundExpr] the parent node.
      def traverse_subnodes(aParentNode)
        subnodes = aParentNode.subnodes
        broadcast(:before_subnodes, aParentNode, subnodes)

        # Let's proceed with the visit of subnodes
        subnodes.each { |a_node| a_node.accept(self) }

        broadcast(:after_subnodes, aParentNode, subnodes)
      end

      # Send a notification to all subscribers.
      # @param msg [Symbol] event to notify
      # @param args [Array] arguments of the notification.
      def broadcast(msg, *args)
        subscribers.each do |subscr|
          next unless subscr.respond_to?(msg) || subscr.respond_to?(:accept_all)

          subscr.send(msg, *args)
        end
      end
    end # class
  end # module
end # module
