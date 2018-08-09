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
			begin
				ApprovalProcess.new.load(@client.not_nil!)
			rescue exc
				LOG.error("Unable to load approval process.")
				LOG.error(exc)
			end
		end

		# Starts the bot using the current configuration.
		def start
			@client = Discord::Client.new(token: CONFIG.bot_token.to_s,
				client_id: CONFIG.bot_client_id,
				logger: LOG)
			@client.not_nil!.on_ready do |payload|
				load
			end
			@client.not_nil!.run
		end
	end
end
