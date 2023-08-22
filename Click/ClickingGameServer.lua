local clickCooldown = 0.05
local cooldownPlrs = {}


local dss = game:GetService("DataStoreService")

local ds = dss:GetDataStore("DATA")


function saveData(plr)


	local cash = plr.Stats.Cash.Value
	local upgrades = plr.Stats.Upgrades.Value

	pcall(function()

		ds:SetAsync(plr.UserId .. "-Data", {cash, upgrades})
	end)
end


game.Players.PlayerAdded:Connect(function(plr)


	local statsFolder = Instance.new("Folder")
	statsFolder.Name = "Stats"
	statsFolder.Parent = plr

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = statsFolder
	
	local upgrades = Instance.new("IntValue")
	upgrades.Name = "Upgrades"
	upgrades.Parent = statsFolder


	local cashData = nil
	local upgradesData = nil

	pcall(function()

		cashData = ds:GetAsync(plr.UserId .. "-Data")[1]
		upgradesData = ds:GetAsync(plr.UserId .. "-Data")[2]
	end)

	cash.Value = cashData or 0
	upgrades.Value = upgradesData or 1
end)


game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()


	for i, plr in pairs(game.Players:GetPlayers()) do

		saveData(plr)
	end
end)


game.ReplicatedStorage:WaitForChild("ClickedRE").OnServerEvent:Connect(function(plr, instruction)
	
	
	if instruction == "Click" and not cooldownPlrs[plr] then
		
		cooldownPlrs[plr] = true
		
		
		local amountToGive = plr.Stats.Upgrades.Value ^ 1.5
		
		plr.Stats.Cash.Value += amountToGive
		
		
		wait(clickCooldown)
		cooldownPlrs[plr] = false
		
		
	elseif instruction == "Upgrade" then
		
		
		local cost = (plr.Stats.Upgrades.Value + 1) ^ 4
		
		
		if plr.Stats.Cash.Value >= cost then
			
			plr.Stats.Cash.Value -= cost
			
			plr.Stats.Upgrades.Value += 1
		end
	end
end)