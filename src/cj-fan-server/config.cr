require "logger"
require "yaml"
require "file"
require "./log"

module CjFanServer
	CONFIG = Config.new

	class Config
		USER_CONFIG_PATH = "user_config.yml"

		@bot_token = ENV["BOT_TOKEN"]?

		# The bot token.
		property bot_token

		# Overloads configurations if a `user_config.yml` file is provided in
		# the root directory. All configurations are optional. Invalid
		# configurations are not allowed.
		def overload(path = USER_CONFIG_PATH)
			if File.exists?(path)
				YAML.parse(File.read(path)).as_h.each do |key, value|
					case key
					when "bot_token"
						@bot_token = value.as_s
					else
						raise "Unkown configuration (#{key})"
					end
				end
			end
		end

		# Validates the configuration. An exception will be raised if a
		# configuration is invalid.
		def validate
			if @bot_token.nil?
				raise "Missing bot token."
			end
		end
	end
end
