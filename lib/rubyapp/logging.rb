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
      log.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime} #{severity} #{progname}: #{msg}\n"
      end
    end
  end
end

def logger
  LoggerConfig.logger
end
