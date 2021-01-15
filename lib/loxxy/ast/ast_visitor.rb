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

      # Visit event. The visitor is about to visit a if statement.
      # @param anIfStmt [AST::LOXIfStmt] the if statement node to visit
      def visit_if_stmt(anIfStmt)
        broadcast(:before_if_stmt, anIfStmt)
        traverse_subnodes(anIfStmt) # The condition is visited/evaluated here...
        broadcast(:after_if_stmt, anIfStmt, self)
      end

      # Visit event. The visitor is about to visit a print statement.
      # @param aPrintStmt [AST::LOXPrintStmt] the print statement node to visit
      def visit_print_stmt(aPrintStmt)
        broadcast(:before_print_stmt, aPrintStmt)
        traverse_subnodes(aPrintStmt)
        broadcast(:after_print_stmt, aPrintStmt)
      end

      # Visit event. The visitor is about to visit a logical expression.
      # Since logical expressions may take shorcuts by not evaluating all their
      # sub-expressiosns, they are responsible for visiting or not their children.
      # @param aBinaryExpr [AST::LOXBinaryExpr] the logical expression node to visit
      def visit_logical_expr(aLogicalExpr)
        broadcast(:before_logical_expr, aLogicalExpr)

        # As logical connectors may take a shortcut only the first argument is visited
        traverse_given_subnode(aLogicalExpr, 0)

        # The second child could be visited: this action is deferred in handler
        broadcast(:after_logical_expr, aLogicalExpr, self)
      end

      # Visit event. The visitor is about to visit a binary expression.
      # @param aBinaryExpr [AST::LOXBinaryExpr] the binary expression node to visit
      def visit_binary_expr(aBinaryExpr)
        broadcast(:before_binary_expr, aBinaryExpr)
        traverse_subnodes(aBinaryExpr)
        broadcast(:after_binary_expr, aBinaryExpr)
      end

      # Visit event. The visitor is about to visit an unary expression.
      # @param anUnaryExpr [AST::anUnaryExpr] unary expression node to visit
      def visit_unary_expr(anUnaryExpr)
        broadcast(:before_unary_expr, anUnaryExpr)
        traverse_subnodes(anUnaryExpr)
        broadcast(:after_unary_expr, anUnaryExpr)
      end

      # Visit event. The visitor is about to visit a grouping expression.
      # @param aGroupingExpr [AST::LoxGroupingExpr] grouping expression to visit
      def visit_grouping_expr(aGroupingExpr)
        broadcast(:before_grouping_expr, aGroupingExpr)
        traverse_subnodes(aGroupingExpr)
        broadcast(:after_grouping_expr, aGroupingExpr)
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

      # Visit event. The visitor is about to visit one given subnode of a non
      # terminal node.
      # @param aParentNode [Ast::LocCompoundExpr] the parent node.
      # @param index [integer] index of child subnode
      def traverse_given_subnode(aParentNode, index)
        subnode = aParentNode.subnodes[index]
        broadcast(:before_given_subnode, aParentNode, subnode)

        # Now, let's proceed with the visit of that subnode
        subnode.accept(self)

        broadcast(:after_given_subnode, aParentNode, subnode)
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
