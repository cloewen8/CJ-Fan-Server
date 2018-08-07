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
		describe "#overload" do
			it "must not throw if user_config.yml does not exist" do
				CjFanServer::CONFIG.overload("spec/inexistant.yml")
			end
			it "must set the token if provided" do
				CjFanServer::CONFIG.overload("spec/user_config_valid.yml")
				CjFanServer::CONFIG.bot_token.should eq("abc")
			end
			it "must throw if invalid configurations are present" do
				expect_raises(Exception) do
					CjFanServer::CONFIG.overload("spec/user_config_invalid.yml")
				end
			end
		end
	end
end
