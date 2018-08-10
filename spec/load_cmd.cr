module CjFanServer
	class LoadCmd < Loadable
		include Cmd

		@loaded = false

		getter loaded

		def load
			@loaded = true
		end
	end
end
