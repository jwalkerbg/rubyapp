# frozen_string_literal: true

require "optparse"
require "json"
require_relative "rubyapp/config"
require_relative "rubyapp/cli"
require_relative "rubyapp/version"

module Rubyapp
  # Application Error handler
  class Error < StandardError
    attr_reader :message, :subject

    def initialize(message, subject = '')
      @message = message
      @subject = subject
      super()
    end

    # print_message composes and prints error message
    def print_message
      mess = @message
      mess += ": #{@subject}" unless @subject.empty
      puts mess
    end
  end

  # Mainclass contains main function from which start app execution
  class Mainclass
    def main
      # primary parse of the commandline options, handling -v --version option
      # options = CommandLineParser.parse(ARGV)
      # exit if CommandLineParser.optVersAndError(options)

      cfg = Config.new()
      puts cfg.default_config
      args = CommandLineParser.parse
      puts args
    end
  end
end
