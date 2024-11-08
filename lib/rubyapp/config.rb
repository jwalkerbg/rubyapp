# rubyapp/config

# Rubyapp - application nmodule
module Rubyapp
  class Config
    def initialize
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
      "configuration" => {
        # add options here, nested structur are available
      }
    }

    def default_config
      DEFAULT_CONFIG
    end

    CONFIG_SCHEMA = {
      "$schema" => "https://json-schema.org/draft/2020-12/schema",
      "type" => "object",
      "properties" => {
        "metadata": {
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
          "additionalProperties" => true
        }
      },
      "additionalProperties" => false
    }

    def config_schema
      CONFIG_SCHEMA
    end

    def self.load_toml_file(file_path, schema)
      config = {}
      begin
        config = TomlRB.load_toml_file(file_path)
      rescue TomlRB::ParseError => e
        puts "TOML parsing error: #{e.message}"
        return nil
      rescue Errno::ENOENT => e
        puts "File not found: #{file_path}"
        return nil
      rescue StandardError => e
        puts "An unexpected error occurred: #{e.message}"
        return nil
      end

      # Validate the data against the JSON schema
      begin
        JSON::Validator.validate!(schema, config)
        puts "Configuration is valid."
        config  # Return the loaded configuration
      rescue JSON::Schema::ValidationError => e
        puts "Validation error: #{e.message}"
        nil
      end
    end
  end
end
