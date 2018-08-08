require "./cj-fan-server/config"

begin
	# Configure	
	CjFanServer::CONFIG.overload
	CjFanServer::CONFIG.validate

rescue exc
	CjFanServer::LOG.fatal("Unable to start.")
	CjFanServer::LOG.fatal(exc)
end
