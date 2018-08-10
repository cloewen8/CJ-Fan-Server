require "discordcr"
require "./config"
require "./log"

require "./approval"

module CjFanServer
	BOT = Bot.new

	class Bot
		@client: Discord::Client?
		@cache: Discord::Cache?

		# The Discord client for the bot.
		protected getter! client

		# A cache for Discord objects.
		protected getter! cache

		# Loads all of the bots components.
		private def load
			@cache = Discord::Cache.new(client)
			begin
				ApprovalProcess.new.load
			rescue exc
				LOG.error("Unable to load approval process.")
				LOG.error(exc)
			end
		end

		# Starts the bot using the current configuration.
		def start
			@client = Discord::Client.new(token: CONFIG.bot_token.not_nil!,
				client_id: CONFIG.bot_client_id,
				logger: LOG)
			client.on_ready do
				load
			end
			client.run
		end
	end
end
