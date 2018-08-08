require "./config"
require "./log"
require "discordcr"

module CjFanServer
	BOT = Bot.new

	class Bot
		@client: Discord::Client?

		protected getter client

		def load
			# todo: Load everything.
		end

		def start
			@client = Discord::Client.new(token: CONFIG.bot_token.to_s,
				client_id: CONFIG.bot_client_id,
				logger: LOG)
			load
			@client.as(Discord::Client).run
		end
	end
end
