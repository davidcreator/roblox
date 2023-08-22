game.Players.PlayerAdded:Connect(function(plr)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local money = Instance.new("IntValue")
	money.Name = "Money"
	money.Value = 0
	money.Parent = leaderstats
end)


game.ReplicatedStorage.OnAllEggsFound.OnServerEvent:Connect(function(plr)
	
	plr.leaderstats.Money.Value = plr.leaderstats.Money.Value + 1000
end)