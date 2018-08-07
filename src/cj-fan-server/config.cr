require "logger"
require "./log"

module CjFanServer
	CONFIG = Config.new

	class Config
		@bot_token = ENV["BOT_TOKEN"]?

		# The bot token.
		property bot_token

		# Validates the configuration.
		# An exception will be raised
		# if a configuration is invalid.
		def validate
			if bot_token.nil?
				raise "Missing bot token."
			end
		end
	end
end
