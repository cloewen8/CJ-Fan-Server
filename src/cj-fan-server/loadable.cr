require "discordcr"

module CjFanServer
	abstract class Loadable
		abstract def load(client : Discord::Client)
	end
end
