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

      if args["config"]
        cfgfile = cfg.load_toml_file(args["config"])
        give_up unless cfgfile
      end

      # Merging options
      cfgfile&.then { |cf| cfg.deep_merge(cf) }
      cfg.merge_cli_options(args)

      run_app(cfg.configuration)
      logger.info("End of main")
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
      if cfg["logging"]["verbose"]
        logger.info("Running #{Rubyapp::NAME} with following options:\n#{JSON.pretty_generate(cfg)}")
      end

      # Implement application business logic here.
    end
  end
end
