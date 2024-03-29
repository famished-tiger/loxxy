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
      # @param aTop [AST::LoxNode] the parse tree to visit.
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

      # Visit event. The visitor is about to visit a variable declaration statement.
      # @param aSeqDecls [AST::LOXSeqDecl] the variable declaration node to visit
      def visit_seq_decl(aSeqDecls)
        broadcast(:before_seq_decl, aSeqDecls)
        traverse_subnodes(aSeqDecls)
        broadcast(:after_seq_decl, aSeqDecls)
      end

      # Visit event. The visitor is about to visit a variable declaration statement.
      # @param aVarStmt [AST::LOXVarStmt] the variable declaration node to visit
      def visit_var_stmt(aVarStmt)
        broadcast(:before_var_stmt, aVarStmt)
        traverse_subnodes(aVarStmt)
        broadcast(:after_var_stmt, aVarStmt)
      end

      # Visit event. The visitor is about to visit a class declaration.
      # @param aClassStmt [AST::LOXClassStmt] the for statement node to visit
      def visit_class_stmt(aClassStmt)
        broadcast(:before_class_stmt, aClassStmt)
        broadcast(:after_class_stmt, aClassStmt, self)
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

      # Visit event. The visitor is about to visit a return statement.
      # @param aReturnStmt [AST::LOXReturnStmt] the return statement node to visit
      def visit_return_stmt(aReturnStmt)
        broadcast(:before_return_stmt, aReturnStmt)
        traverse_subnodes(aReturnStmt)
        broadcast(:after_return_stmt, aReturnStmt, self)
      end

      # Visit event. The visitor is about to visit a while statement node.
      # @param aWhileStmt [AST::LOXWhileStmt] the while statement node to visit
      def visit_while_stmt(aWhileStmt)
        broadcast(:before_while_stmt, aWhileStmt)
        traverse_subnodes(aWhileStmt) if aWhileStmt.condition # The condition is visited/evaluated here...
        broadcast(:after_while_stmt, aWhileStmt, self)
      end

      # Visit event. The visitor is about to visit a block statement.
      # @param aBlockStmt [AST::LOXBlockStmt] the print statement node to visit
      def visit_block_stmt(aBlockStmt)
        broadcast(:before_block_stmt, aBlockStmt)
        traverse_subnodes(aBlockStmt) unless aBlockStmt.empty?
        broadcast(:after_block_stmt, aBlockStmt)
      end

      # Visit event. The visitor is visiting an assignment node
      # @param anAssignExpr [AST::LoxAssignExpr] the variable assignment node to visit.
      def visit_assign_expr(anAssignExpr)
        broadcast(:before_assign_expr, anAssignExpr)
        traverse_subnodes(anAssignExpr)
        broadcast(:after_assign_expr, anAssignExpr, self)
      end

      # @param aSetExpr [AST::LOXGetExpr] the get expression node to visit
      def visit_set_expr(aSetExpr)
        broadcast(:before_set_expr, aSetExpr, self)
        broadcast(:after_set_expr, aSetExpr, self)
      end

      # Visit event. The visitor is about to visit a logical expression.
      # Since logical expressions may take shorcuts by not evaluating all their
      # sub-expressiosns, they are responsible for visiting or not their children.
      # @param aLogicalExpr [AST::LOXLogicalExpr] the logical expression node to visit
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

      # Visit event. The visitor is about to visit a call expression.
      # @param aCallExpr [AST::LoxCallExpr] call expression to visit
      def visit_call_expr(aCallExpr)
        broadcast(:before_call_expr, aCallExpr)
        traverse_subnodes(aCallExpr)
        broadcast(:after_call_expr, aCallExpr, self)
      end

      # @param aGetExpr [AST::LOXGetExpr] the get expression node to visit
      def visit_get_expr(aGetExpr)
        broadcast(:before_get_expr, aGetExpr)
        broadcast(:after_get_expr, aGetExpr, self)
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

      # Visit event. The visitor is visiting a variable usage node
      # @param aVariableExpr [AST::LoxVariableExpr] the variable reference node to visit.
      def visit_variable_expr(aVariableExpr)
        broadcast(:before_variable_expr, aVariableExpr)
        broadcast(:after_variable_expr, aVariableExpr, self)
      end

      # Visit event. The visitor is about to visit the this keyword.
      # @param aThisExpr [Ast::LoxThisExpr] this expression
      def visit_this_expr(aThisExpr)
        broadcast(:before_this_expr, aThisExpr)
        broadcast(:after_this_expr, aThisExpr, self)
      end

      # Visit event. The visitor is about to visit the super keyword.
      # @param aSuperExpr [Ast::LoxSuperExpr] super expression
      def visit_super_expr(aSuperExpr)
        broadcast(:before_super_expr, aSuperExpr)
        broadcast(:after_super_expr, aSuperExpr, self)
      end

      # Visit event. The visitor is about to visit the given terminal datatype value.
      # @param aValue [Ast::BuiltinDattype] the built-in datatype value
      def visit_builtin(aValue)
        broadcast(:before_visit_builtin, aValue)
        broadcast(:after_visit_builtin, aValue)
      end

      # Visit event. The visitor is about to visit a function statement node.
      # @param aFunStmt [AST::LoxFunStmt] function declaration to visit
      def visit_fun_stmt(aFunStmt)
        broadcast(:before_fun_stmt, aFunStmt, self)
        broadcast(:after_fun_stmt, aFunStmt, self)
      end

      # Visit event. The visitor is about to visit the given non terminal node.
      # @param aNonTerminalNode [Rley::PTree::NonTerminalNode] the node to visit.
      def visit_nonterminal(aNonTerminalNode)
        # Loxxy interpreter encountered a CST node (Concrete Syntax Tree)
        # that it cannot handle.
        symb = aNonTerminalNode.symbol.name
        msg = "Loxxy cannot execute this code yet for non-terminal symbol '#{symb}'."
        raise NotImplementedError, msg
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
