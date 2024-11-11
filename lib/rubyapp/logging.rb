# rubyapp/logging.rb

require "logger"

# LoggerConfig module to set up and provide a global logger instance
module LoggerConfig
  require "logger"

  # Initialize the logger with desired settings
  def self.logger
    @logger ||= Logger.new($stdout).tap do |log|
      log.level = Logger::DEBUG
      log.datetime_format = "%Y-%m-%d %H:%M:%S"
      log.formatter = proc do |severity, datetime, _progname, msg|
        caller_location = caller_locations.detect do |location|
          !location.path.include?("logger.rb")
        end
        file = caller_location.path.split("/").last
        line = caller_location.lineno
        "#{datetime} #{severity} #{file}:#{line} : #{msg}\n"
      end
    end
  end
end

def logger
  LoggerConfig.logger
end
