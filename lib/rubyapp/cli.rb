# rubyapp/cli.rb

require "optparse"

module Rubyapp
  # CommandLineParser of CLI options
  class CommandLineParser
    def self.parse
      parameters = { "config" => "config.toml" }

      opt_parser = OptionParser.new do |opt|
        opt.banner = "Usage: rubyapp [options...\n\n]"
        opt.on("--config FILE", String, "Specify the configuration file") do |file|
          parameters["config"] = file
        end
        opt.on("--no-config", "Disable the use of a configuration file") do
          parameters["config"] = nil
        end
        opt.on_tail("-V", "--version", "app version") do
          parameters["version"] = true
        end
        opt.on_tail("--[no-]verbose", "Verbose logging (default: --no-verbose)") do |v|
          parameters["verbose"] = v
        end
        # Replace param1 and param2 with actual options for your application
        opt.on("--param1 VALUE", Integer, "Parameter1") do |v|
          parameters["param1"] = v
        end
        opt.on("--param2 VALUE", Integer, "Parameter2") do |v|
          parameters["param2"] = v
        end
      end
      begin
        opt_parser.parse!
      rescue OptionParser::InvalidOption, OptionParser::NeedlessArgument, OptionParser::InvalidArgument,
             OptionParser::MissingArgument, OptionParser::AmbiguousOption => e
        puts e
        parameters = nil
      end
      parameters
    end
  end
end
