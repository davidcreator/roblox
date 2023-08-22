local remoteEvent = game.ReplicatedStorage.NameChangeEvent


remoteEvent.OnServerEvent:Connect(function(plr, name)
	
	
	local char = plr.Character or plr.CharacterAdded:Wait()
	
	
	local filteredName = game:GetService("TextService"):FilterStringAsync(name, plr.UserId) 
	
	local filteredNameAsString = filteredName:GetNonChatStringForBroadcastAsync() 
	

	local nameGui = char.Head:FindFirstChild("NameGui")
	
	local nameLabel = nameGui:FindFirstChild("NameLabel")
	
	
	nameLabel.Text = filteredNameAsString	
end)