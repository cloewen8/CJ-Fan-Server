require "./cj-fan-server/config"
require "./cj-fan-server/bot"

begin
	# Configure	
	CjFanServer::CONFIG.overload
	CjFanServer::CONFIG.validate

	# Start bot
	CjFanServer::BOT.start
rescue exc
	CjFanServer::LOG.fatal("Unable to start.")
	CjFanServer::LOG.fatal(exc)
end
