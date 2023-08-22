local function updateGui()
	
	
	local serverFrames = {}
	
	
	for i, serverValue in pairs(game.ReplicatedStorage.Servers:GetChildren()) do
		
		local name = serverValue.Name
		
		local serverStats = string.split(serverValue.Value, " ")
		
		local id = serverStats[1]
		local plrs = serverStats[2]
		
		
		local serverFrame = script.ServerTemplate:Clone()
		
		serverFrame:WaitForChild("ServerName").Text = name .. "\n ID: " .. id
		serverFrame:WaitForChild("Players").Text = plrs .. "/" .. game.Players.MaxPlayers
		
		
		table.insert(serverFrames, serverFrame)
		

		serverFrame.JoinButton.MouseButton1Click:Connect(function()
				
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, id)
		end)

		
		script.Parent.List:ClearAllChildren()

		script.UIListLayout:Clone().Parent = script.Parent.List
		
		
		for i, serverFrame in pairs(serverFrames) do
			
			serverFrame.Parent = script.Parent.List
		end
	end
end


updateGui()

game.ReplicatedStorage.Servers.ChildAdded:Connect(updateGui)
game.ReplicatedStorage.Servers.ChildRemoved:Connect(updateGui)