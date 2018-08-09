require "discordcr"
require "random"
require "./loadable"
require "./guild"

module CjFanServer
	class ApprovalProcess < Loadable
		MESSAGE_START = "If you are a new member, you must agree to these rules, to do so, please enter the code below in  #verify-channel.\n\n"
		WARNING = "The CJ Fan Server requires you agree to their rules before you can chat freely. Please read the #rules channel for more information."
		CODE_LENGTH = 8
		CODE_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
		REFRESH_DELAY = 30000

		@code = ""
		@refresh_time = 0_f64
		@code_message = 0_u64

		# Load an approval process for users to gain access to the server after
		# reading the server's rules.
		def load(client : Discord::Client)
				message = client.get_channel_messages(RULES_CHANNEL, 1).first

				# Generate the message.
				if message && message.author.id.to_u64 == client.client_id
					LOG.debug("Code message found.")
					client.edit_message(RULES_CHANNEL, message.id.value, getMessageContent)
				else
					LOG.debug("Code message not found.")
					message = client.create_message(RULES_CHANNEL, getMessageContent)
				end
				@code_message = message.id.value

				# Send warnings.
				client.on_guild_member_add do |member|
					sendWarning(member)
				end
				# Process codes.
				client.on_message_create do |message|
					processCode(message)
				end
			end
		end

		private def generateCode
			@code = String.build(CODE_LENGTH) do |str|
				chars = 0

				while chars < CODE_LENGTH
					str << CODE_CHARS[Random.rand(CODE_CHARS.size)]
					chars += 1
				end
			end
		end

		private def getMessageContent
			generateCode
			MESSAGE_START + @code
		end

		private def sendWarning(member : Discord::Gateway::GuildMemberAddPayload)
			BOT.client.create_message(BOT.cache.resolve_dm_channel(member.user.id),
				WARNING)
		end

		private def processCode(message : Discord::Message)
			if message.content == @code
				member = BOT.cache.resolve_member(GUILD, message.author.id)
				if !(member.roles.any? do |role| role.value == LITTLE_FISH_ROLE end)
					BOT.client.add_guild_member_role(GUILD, member.user.id.value, LITTLE_FISH_ROLE)
					BOT.client.delete_message(message.channel_id.value, message.id.value)
					updateMessage
				end
			end
		end

		private def updateMessage
			current_time = Time.utc_now.total_milliseconds
			if current_time > @refresh_time
				@refresh_time = Float64.INFINITY
				client.edit_message(RULES_CHANNEL, @code_message, getMessageContent)

				@refresh_time = current_time + REFRESH_DELAY
			end
		end
	end
end
