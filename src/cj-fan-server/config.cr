require "logger"
require "yaml"
require "file"

module CjFanServer
	CONFIG = Config.new

	class Config
		USER_CONFIG_PATH = "user_config.yml"

		# General

		@is_dev: Bool
		@bot_token: String?
		@bot_client_id: UInt64?

		# Cmds

		@cmds_prefix: String

		# Is in a development environment. Only true if the user_config.yml
		# file exists.
		getter is_dev
		# The bot token.
		property bot_token
		# The bot client id.
		property bot_client_id
		# The prefix for commands.
		getter cmds_prefix

		def initialize
			client = ENV["BOT_CLIENT_ID"]?

			@is_dev = File.exists?(USER_CONFIG_PATH)
			@bot_token = ENV["BOT_TOKEN"]?
			if client
				@bot_client_id = client.to_u64
			end

			@cmds_prefix = "/"
		end

		# Overloads configurations if a `user_config.yml` file is provided in
		# the root directory. All configurations are optional. Invalid
		# configurations are not allowed.
		def overload(path = USER_CONFIG_PATH)
			if File.exists?(path)
				YAML.parse(File.read(path)).as_h.each do |key, value|
					case key
					when "bot_token"
						@bot_token = value.as_s
					when "bot_client_id"
						@bot_client_id = value.as_i64.to_u64
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
			elsif @bot_client_id.nil?
				raise "Missing bot client id."
			end
		end
	end
end
