game.Players.PlayerAdded:Connect(function(plr)
	
	local stats = Instance.new("Folder", plr)
	stats.Name = "leaderstats"
	
	local kills = Instance.new("IntValue", stats)
	kills.Name = "Kills"
	
end)