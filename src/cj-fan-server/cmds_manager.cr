require "./loadable"
require "./config"
require "./cmds/*"

module CjFanServer
	class CmdsManager < Loadable
		@cmds = [] of Cmd

		getter cmds

		# Loads the commands manager to process commands.
		def load
			register_all
		end

		# Register all applicable commands.
		def register_all(load = true)
			if CONFIG.is_dev
				# Load in-progress commands.
				register(Help::HelpCmd.new, load)
			else
				# Load finished commands.
			end
		end

		# Register a command.
		def register(cmd, load)
			if load && cmd.is_a?(Loadable)
				cmd.load
			end
			@cmds << cmd
		end
	end
end
