# frozen_string_literal: true

require_relative 'environment'

module Loxxy
  module BackEnd
    # A symbol table is basically a mapping from a name onto an object
    # that holds information associated with that name. It is a data structure
    # that keeps track of variables and their respective environment where they are
    # declared. The key requirements for the symbol are:
    # - To perform fast lookup operations: given a name, retrieve the corresponding
    #   object.
    # - To allow the efficient insertion of names and related information
    # - To support the nesting of environments
    # - To handle the entry environment and exit environment events,
    # - To cope with variable redefinition in nested environment
    # The terminology 'symbol table' comes from the compiler design
    # community.
    class SymbolTable
      # Mapping between a name and the environment(s) where it is defined
      # @return [Hash{String => Array<Environment>}]
      attr_reader :name2envs

      # @return [Environment] The top-level environment (= root of environment tree)
      attr_reader :root

      # @return [Environment] The current environment.
      attr_reader :current_env

      # Build symbol table with given environment as root.
      # @param anEnv [BackEnd::Environment,NilClass] The top-level Environment
      def initialize(anEnv = nil)
        @name2envs = {}
        init_root(anEnv) # Set default (global) environment
      end

      # Returns iff there is no entry in the symbol table
      # @return [Boolean]
      def empty?
        name2envs.empty?
      end

      # Use this method to signal the interpreter that a given environment
      # to be a child of current environment and to be itself the new current environment.
      # @param anEnv [BackEnd::Environment] the Environment that
      def enter_environment(anEnv)
        anEnv.enclosing = current_env
        @current_env = anEnv
      end

      def leave_environment
        current_env.defns.each_pair do |nm, _item|
          environments = name2envs[nm]
          if environments.size == 1
            name2envs.delete(nm)
          else
            environments.pop
            name2envs[nm] = environments
          end
        end
        raise StandardError, 'Cannot remove root environment.' if current_env == root

        @current_env = current_env.enclosing
      end

      # Add an entry with given name to current environment.
      # @param anEntry [Variable]
      # @return [String] Internal name of the entry
      def insert(anEntry)
        current_env.insert(anEntry)
        name = anEntry.name
        if name2envs.include?(name)
          name2envs[name] << current_env
        else
          name2envs[name] = [current_env]
        end

        anEntry.name # anEntry.i_name
      end

      # Search for the object with the given name
      # @param aName [String]
      # @return [BackEnd::Variable]
      def lookup(aName)
        environments = name2envs.fetch(aName, nil)
        return nil if environments.nil?

        sc = environments.last
        sc.defns[aName]
      end

      # Search for the object with the given i_name
      # @param anIName [String]
      # @return [BackEnd::Variable]
      # def lookup_i_name(anIName)
        # found = nil
        # environment = current_env

        # begin
          # found = environment.defns.values.find { |e| e.i_name == anIName }
          # break if found

          # environment = environment.parent
        # end while environment

        # found
      # end

      # Return all variables defined in the current .. root chain.
      # Variables are sorted top-down and left-to-right.
      def all_variables
        vars = []
        skope = current_env
        while skope
          vars_of_environment = skope.defns.select { |_, item| item.kind_of?(Variable) }
          vars = vars_of_environment.values.concat(vars)
          skope = skope.enclosing
        end

        vars
      end

      private

      def init_root(anEnv)
        @root = valid_environment(anEnv)
        @current_env = @root
      end

      def valid_environment(anEnv)
        anEnv.nil? ? Environment.new : anEnv
      end
    end # class
  end # module
end # module
