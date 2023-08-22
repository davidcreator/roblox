local messagingService = game:GetService("MessagingService")


game.Players.PlayerAdded:Connect(function(player)
	
	player.Chatted:Connect(function(msg)
		
		local splitMsg = string.split(msg, " ")
		
		if splitMsg[1] == "/global" then
			
			
			msg = string.gsub(msg, "/global ", "")
			
			local filteredMsg
			pcall(function()
				filteredMsg = game:GetService("TextService"):FilterStringAsync(msg, player.UserId)
				
				filteredMsg = filteredMsg:GetNonChatStringForBroadcastAsync()
			end)
		
			
			if filteredMsg then
				
				local messageData = {
					sender = player.Name,
					message = filteredMsg
				}
				
				messagingService:PublishAsync("Chat", messageData)
			end
		end
	end)
end)

messagingService:SubscribeAsync("Chat", function(sentData)
	
	
	local data = sentData.Data
	
	game.ReplicatedStorage.GlobalMessageRE:FireAllClients(data.sender, data.message)
end)