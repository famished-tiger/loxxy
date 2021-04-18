# frozen_string_literal: true

require 'optparse' # Use standard OptionParser class for command-line parsing

module Loxxy
  # A command-line option parser for the Loxxy interpreter.
  # It is a specialisation of the OptionParser class.
  class CLIParser < OptionParser
    # @return [Hash{Symbol=>String, Array}]
    attr_reader(:parsed_options)

    # Constructor.
    def initialize(prog_name, ver)
      super()
      reset(prog_name, ver)

      heading
      separator 'Options:'
      separator ''
      add_tail_options
    end

    def parse!(args)
      super
      parsed_options
    end

    private

    def reset(prog_name, ver)
      @program_name = prog_name
      @version = ver
      @banner = "Usage: #{prog_name} LOX_FILE [options]"
      @parsed_options = {}
    end

    def description
      <<-DESCR
  Description:
    loxxy is a Lox interpreter, it executes the Lox file(s) given in command-line.
    More on Lox Language: https://craftinginterpreters.com/the-lox-language.html

  Example:
    #{program_name} hello.lox
      DESCR
    end

    def heading
      banner
      separator ''
      separator description
      separator ''
    end

    def add_tail_options
      on_tail('--version', 'Display the program version then quit.') do
        puts version
        exit(0)
      end

      on_tail('-?', '-h', '--help', 'Display this help then quit.') do
        puts help
        exit(0)
      end
    end
  end # class
end # module
# End of file
