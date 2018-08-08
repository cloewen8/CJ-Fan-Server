require "logger"
require "file"
require "./config"

module CjFanServer
	LOG = Logger.new(STDOUT, CONFIG.is_dev ?
		Logger::Severity::DEBUG :
		Logger::Severity::ERROR)
end
