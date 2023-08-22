game.Players.PlayerAdded:Connect(function(p)
	
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = p
	
	local cash = Instance.new("IntValue")	
	cash.Name = "Cash"
	cash.Value = 100000
	cash.Parent = ls
end)


local crates = game.ReplicatedStorage:WaitForChild("Crates")


game.ReplicatedStorage.CrateRE.OnServerEvent:Connect(function(plr, crateType, crateTime)
	
	
	if crates:FindFirstChild(crateType) then
		

		local price = crates[crateType].Price.Value
		
		if plr.leaderstats.Cash.Value >= price then
			
			plr.leaderstats.Cash.Value = plr.leaderstats.Cash.Value - price
			
			
			local unboxableWeapons = crates[crateType]:GetChildren()
			
			local chosenWeapon 
			repeat chosenWeapon = unboxableWeapons[math.random(#unboxableWeapons)]; wait() until chosenWeapon:IsA("Tool")
			
			
			game.ReplicatedStorage.CrateRE:FireClient(plr, chosenWeapon)
			
			
			wait(crateTime + 1)
			
			chosenWeapon:Clone().Parent = plr.Backpack
		end
	end
end)