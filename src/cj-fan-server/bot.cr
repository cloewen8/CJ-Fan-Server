require "discordcr"
require "./config"
require "./log"

require "./approval"

module CjFanServer
	BOT = Bot.new

	class Bot
		@client: Discord::Client?

		protected getter client

		# Loads all of the bots components.
		private def load
		end

		# Starts the bot using the current configuration.
		def start
			@client = Discord::Client.new(token: CONFIG.bot_token.to_s,
				client_id: CONFIG.bot_client_id,
				logger: LOG)
			load
			@client.as(Discord::Client).run
		end
	end
end
