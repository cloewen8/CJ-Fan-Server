port = 8080

OptionParser.parse! do |opts|
	opts.on("-p PORT", "--port PORT", "define port to run server") do |opt|
		port = opt.to_i
	end
end

server = HTTP::Server.new do |context|
	context.response.content_type = "text/plain"
	context.response.print "Hello world! The time is #{Time.now}"
end

address = server.bind_tcp port
server.listen


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
