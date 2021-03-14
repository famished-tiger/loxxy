# frozen_string_literal: true

require_relative 'variable'

module Loxxy
  module BackEnd
    # A environment is a name space that corresponds either to a specific
    # delimited region in Loxxy source code or to an activation record
    # of a relation or a relation definition.
    # It contains a map of names to the objects they name (e.g. logical var)
    class Environment
      # The enclosing (parent) environment.
      # @return [Environment, NilClass]
      attr_accessor :enclosing

      # The previous environment in the environment chain.
      # @return [Environment, NilClass]
      attr_accessor :predecessor

      # @return [Boolean] true if this environment is part of a closure (contains an embedded function)
      attr_accessor :embedding

      # Mapping from user-defined name to related definition
      #  (say, a variable object)
      # @return [Hash{String => Variable}] Pairs of the kind
      attr_reader :defns

      # Construct a environment instance.
      # @param aParent [Environment, NilClass] Parent environment to this one.
      def initialize(aParent = nil)
        @enclosing = aParent
        @defns = {}
      end

      # Add a new variable to the environment.
      # @param anEntry [BackEnd::Variable]
      # @return [BackEnd::Variable] the variable
      def insert(anEntry)
        e = validated_entry(anEntry)
        # e.suffix = default_suffix if e.kind_of?(BackEnd::Variable)
        defns[e.name] = e

        e
      end

      # Returns a string with a human-readable representation of the object.
      # @return [String]
      def inspect
        +"#<#{self.class}:#{object_id.to_s(16)}>"
      end

      private

      def validated_entry(anEntry)
        name = anEntry.name
        unless name.kind_of?(String) && !name.empty?
          err_msg = 'Invalid variable name argument.'
          raise StandardError, err_msg
        end
        if defns.include?(name) && !anEntry.kind_of?(Variable)
          err_msg = "Variable with name '#{name}' already exists."
          raise StandardError, err_msg
        end

        anEntry
      end

      # def default_suffix
        # @default_suffix ||= "_#{object_id.to_s(16)}"
      # end
    end # class
  end # module
end # module
