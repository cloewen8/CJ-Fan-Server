require "random"
require "./loadable"

module CjFanServer
	class ApprovalProcess < Loadable
		CHANNEL = 465662927064793108_u64
		MESSAGE_START = "If you are a new member, you must agree to these rules, to do so, please enter the code below in  #verify-channel.\n\n"
		CODE_LENGTH = 8
		CODE_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

		@code = ""

		# Load an approval process for users to gain access to the server after
		# reading the server's rules.
		def load(client : Discord::Client)
			message = client.get_channel_messages(CHANNEL, 1).first

			if message && message.author.id.to_u64 == client.client_id
				LOG.debug("Code message found.")
				client.edit_message(CHANNEL, message.id.value, getMessageContent)
			else
				LOG.debug("Code message not found.")
				message = client.create_message(CHANNEL, getMessageContent)
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
	end
end
