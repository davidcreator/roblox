local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("MarkersDataStore")


function saveData(plr)
	
	local markersClaimed = {}
	
	for i, marker in pairs(plr.MarkersClaimed:GetChildren()) do
		
		table.insert(markersClaimed, marker.Name)
	end
	
	pcall(function()
		ds:SetAsync(plr.UserId, markersClaimed)
	end)
end


game.Players.PlayerAdded:Connect(function(plr)
	
	local markersFolder = Instance.new("Folder", plr)
	markersFolder.Name = "MarkersClaimed"
	
	local data = nil
	
	pcall(function()
		data = ds:GetAsync(plr.UserId)
	end)
	
	if data then
		for i, marker in pairs(data) do
			
			local value = Instance.new("StringValue")
			value.Name = marker
			value.Parent = markersFolder
		end
	end
end)


game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		saveData(plr)
	end
end)


for i, marker in pairs(workspace.Markers:GetChildren()) do
	
	marker.PrimaryPart.Touched:Connect(function(part)
		
		if game.Players:GetPlayerFromCharacter(part.Parent) then
			
			if not game.Players:GetPlayerFromCharacter(part.Parent).MarkersClaimed:FindFirstChild(marker.Name) then
				
				local value = Instance.new("StringValue")
				value.Name = marker.Name
				value.Parent = game.Players:GetPlayerFromCharacter(part.Parent).MarkersClaimed
			end
		end
	end)
end