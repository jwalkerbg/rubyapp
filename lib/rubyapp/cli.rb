# rubyapp/cli.rb

require "optparse"

module Rubyapp
  class CommandLineParser
    def self.parse
      parameters = { "ok" => false, "verbose" => false, "version" => false }

      opt_parser = OptionParser.new do |opt|
        opt.banner = "Usage: rubyapp [options...\n\n]"
        opt.on("--config FILE", default="config.toml", "Specify the configuration file") do |file|
          parameters["config"] = file
        end
        opt.on_tail("-V", "--version", "app version") do
          parameters["version"] = true
        end
        opt.on_tail("--[no-]verbose", "Verbose logging (default: --no-verbose)") do |v|
          parameters["verbose"] = v
        end
      end
      begin
        opt_parser.parse!
        parameters["ok"] = true
      rescue OptionParser::InvalidOption, OptionParser::NeedlessArgument, OptionParser::InvalidArgument, OptionParser::MissingArgument, OptionParser::AmbiguousOption => e
        puts e
        parameters["ok"] = false
      end
      parameters
    end
  end
end
