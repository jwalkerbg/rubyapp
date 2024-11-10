# rubyapp/config

require "toml-rb"
require "json-schema"

# Rubyapp - application nmodule
module Rubyapp
  class Config
    attr_accessor :configuration

    def initialize
      @configuration = default_config
    end

    DEFAULT_CONFIG = {
      "template" => {
        "template_name" => "rubyapp",
        "template_version" => "0.1.0",
        "template_description" => {
          "text" => "Template with CLI interface, configuration options in a file, logger and unit tests",
          "content-type" => "text/plain"
        }
      },
      "metadata" => {
        "version" => false
      },
      "logging" => {
        "verbose" => false
      },
      "parameters" => {
        # add options here, nested structures are available
        "param1" => 1,
        "param2" => 2
      }
    }

    def default_config
      DEFAULT_CONFIG
    end

    CONFIG_SCHEMA = {
      "type" => "object",
      "properties" => {
        "metadata" => {
          "type" => "object",
          "properties" => {
            "version" => {
              "type" => "boolean"
            }
          },
          "additionalProperties" => false
        },
        "logging" => {
          "type" => "object",
          "properties" => {
            "verbose" => {
              "type" => "boolean"
            }
          },
          "additionalProperties" => false
        },
        "parameters" => {
          "type" => "object",
          "properties" => {
            # Replace param1 and param2 with actual parameters in your application
            "param1" => {
              "type" => "integer"
            },
            "param2" => {
              "type" => "number"
            }
          },
          "additionalProperties" => false
        }
      },
      "additionalProperties" => false
    }

    def config_schema
      CONFIG_SCHEMA
    end

    def load_toml_file(file_path, schema=config_schema)
      # config = {}
      begin
        config = TomlRB.load_file(file_path)
      rescue TomlRB::ParseError => e
        logger.error("TOML parsing error: #{e.message}")
        return nil
      rescue Errno::ENOENT => e
        logger.error("File not found: #{file_path}, #{e.message}")
        return nil
      rescue StandardError => e
        logger.error("An unexpected error occurred: #{e.message}")
        return nil
      end

      # Validate the data against the JSON schema
      begin
        JSON::Validator.validate!(schema, config)
        logger.info("Configuration is valid.")
        config # Return the loaded configuration
      rescue JSON::Schema::ValidationError => e
        logger.error("Validation error: #{e.message}")
        nil
      end
    end

    def deep_merge(override)
      self.configuration = _deep_merge(configuration, override)
    end

    def _deep_merge(original, override)
      original.merge(override) do |_, old, new|
        old.is_a?(Hash) && new.is_a?(Hash) ? _deep_merge(old, new) : new
      end
    end

    def merge_cli_options(args)
      return unless args

      # List of possible parameters
      # This works if there is only one level of nesting (here category).
      params = {
        "verbose" => "logging",
        "version" => "metadata",
        # replace param1 and param2 with actual parameters in your application
        "param1" => "parameters",
        "param2" => "parameters"
      }

      params.each do |key, category|
        configuration[category][key] = args[key] if args.include?(key)
      end
    end

=begin
    variant that allow individual copy with multiple levels of nesting in configuration
    def merge_cli_options(args)
      return unless args

      configuration["logging"]["verbose"] = args["verbose"] if args.include?("verbose")
      configuration["metadata"]["version"] = args["version"] if args.include?("version")
      # replace param1 and param2 with actual parameters in your application
      configuration["parameters"]["param1"] = args["param1"] if args.include?("param1")
      configuration["parameters"]["param2"] = args["param2"] if args.include?("param2")
    end
=end
  end
end
