require "./spec_helper"

describe CjFanServer do
	describe "#CONFIG" do
		it "must contain a token string" do
			CjFanServer::CONFIG.bot_token.should be_a(String)
		end
		describe "#validate" do
			it "must throw if the token is nil" do
				current = CjFanServer::CONFIG.bot_token
				CjFanServer::CONFIG.bot_token = nil
				expect_raises(Exception) do
					CjFanServer::CONFIG.validate
				end
				CjFanServer::CONFIG.bot_token = current
			end
		end
	end
end
