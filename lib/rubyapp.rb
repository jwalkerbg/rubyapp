# frozen_string_literal: true

require "optparse"
require "json"
require "toml-rb"
require_relative "rubyapp/config"
require_relative "rubyapp/cli"
require_relative "rubyapp/version"
require_relative "rubyapp/logging"

module Rubyapp
  # Mainclass contains main function from which start app execution
  class Mainclass
    def main
      logger.info "Start of main"
      cfg = Config.new
      args = CommandLineParser.parse
      give_up if args.nil?
      print_version if args["version"]

      cfgfile = args["config"]&.then { |config| cfg.load_toml_file(config) }

      # Merging options
      cfgfile&.then { |cf| cfg.deep_merge(cf) }
      cfg.merge_cli_options(args)

      run_app(cfg.configuration)
    end

    def give_up
      logger.info("Giving up.")
      exit
    end

    def print_version
      puts "#{Rubyapp::NAME} #{Rubyapp::VERSION}"
      exit
    end

    # Application code begins execution here, using configuration options as a hash object
    def run_app(cfg)
      logger.info("Running #{Rubyapp::NAME} with following options:")
      logger.info(cfg)

      # Implement application business logic here.
    end
  end
end
