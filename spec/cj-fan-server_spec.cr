require "./spec_helper"

describe CjFanServer do
	describe "#Config" do
		describe "#validate" do
			it "must throw if the bot_token is nil" do
				current = CjFanServer::CONFIG.bot_token
				CjFanServer::CONFIG.bot_token = nil
				expect_raises(Exception) do
					CjFanServer::CONFIG.validate
				end
				CjFanServer::CONFIG.bot_token = current
			end
			it "must throw if the bot_client_id is nil" do
				current = CjFanServer::CONFIG.bot_client_id
				CjFanServer::CONFIG.bot_client_id = nil
				expect_raises(Exception) do
					CjFanServer::CONFIG.validate
				end
				CjFanServer::CONFIG.bot_client_id = current
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
	describe "#ApprovalProcess" do
		describe "#generateCode" do
			it "generates a code between [1..2000] characters" do
				process = CjFanServer::ApprovalProcess.new
				process.generateCode
				process.code.size.should be >  0
				process.code.size.should be <= 2000
			end
		end
	end
	describe "#CmdsManager" do
		describe "#register_all" do
			it "registers a command into an array" do
				manager = CjFanServer::CmdsManager.new
				cmd = CjFanServer::LoadCmd.new
				manager.register(cmd, false)
				manager.cmds.size.should be >= 1
			end
		end
		describe "#register" do
			it "loads loadable commands" do
				manager = CjFanServer::CmdsManager.new
				cmd = CjFanServer::LoadCmd.new
				manager.register(cmd, true)
				cmd.loaded.should eq(true)
			end
		end
	end
end
