local gamepassIDs = {
	[25375907] = script:WaitForChild("Sword"),
	[25375884] = script:WaitForChild("LaserGun"),
	[25375939] = script:WaitForChild("GravityCoil"),
	[25375958] = script:WaitForChild("SpeedCoil"),
}

local mps = game:GetService("MarketplaceService")


game.Players.PlayerAdded:Connect(function(p)

	for id, tool in pairs(gamepassIDs) do
		
		if mps:UserOwnsGamePassAsync(p.UserId, id) then
			
			tool:Clone().Parent = p.StarterGear
			tool:Clone().Parent = p.Backpack
		end
	end
end)


mps.PromptGamePassPurchaseFinished:Connect(function(p, id, purchased)
	
	if purchased and gamepassIDs[id] then
		
		gamepassIDs[id]:Clone().Parent = p.StarterGear
		gamepassIDs[id]:Clone().Parent = p.Backpack
	end
end)