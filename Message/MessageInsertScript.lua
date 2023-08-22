local msgContainer = game.ReplicatedStorage:WaitForChild("MessageContainer")

local plrs = game.Players

local onChatInputted = game.ReplicatedStorage:WaitForChild("OnChatInputted")


onChatInputted.OnServerEvent:Connect(function(plr, msg)
		
		
	local filteredText
		
	local filteredString
		
		
	local stringValue = Instance.new("StringValue")
		
		
	local success, errormsg = pcall(function()
		
			
		filteredText =  game:GetService("TextService"):FilterStringAsync(msg, plr.UserId)			
	end)
		
		
	if success then
			
		local success2, errormsg2 = pcall(function()
				
				
			filteredString = filteredText:GetNonChatStringForBroadcastAsync()
			
		end)
			
		
		if success2 then
				
			stringValue.Value = "[" .. plr.Name .. "] " .. filteredString
				
				
			stringValue.Parent = msgContainer
			
		else
			
			warn(errormsg2)
			stringValue:Destroy()			
		end		
	else
			
		warn(errormsg)
		stringValue:Destroy()		
	end
end)