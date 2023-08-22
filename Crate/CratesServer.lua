--Variables
local rs = game:GetService("ReplicatedStorage")
local remotes = rs:WaitForChild("RemoteEvents")
local items = rs:WaitForChild("Items")
local crates = rs:WaitForChild("Crates")

local rnd = Random.new()

local playersUnboxing = {}


--Data handling
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("UNBOXING SYSTEM DATA")


function saveData(plr:Player)

	if not plr:FindFirstChild("DATA FAILED TO LOAD") then
		
		local cash = plr.leaderstats.Cash.Value
		
		local inventory = {}
		for _, item in pairs(plr.StarterGear:GetChildren()) do
			table.insert(inventory, item.Name)
		end
		if playersUnboxing[plr] then
			table.insert(inventory, playersUnboxing[plr])
		end
		
		local compiledData = {
			Cash = cash;
			Inventory = inventory;
		}

		local success, err = nil, nil
		while not success do
			success, err = pcall(function()
				ds:SetAsync(plr.UserId, compiledData)
			end)
			if err then
				warn(err)
			end
			task.wait(0.02)
		end
	end
end


game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for _, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)

game.Players.PlayerAdded:Connect(function(plr)

	local dataFailedWarning = Instance.new("StringValue")
	dataFailedWarning.Name = "DATA FAILED TO LOAD"
	dataFailedWarning.Parent = plr

	local success, plrData = nil, nil
	while not success do
		success, plrData = pcall(function()
			return ds:GetAsync(plr.UserId)
		end)
		task.wait(0.02)
	end
	dataFailedWarning:Destroy()

	if not plrData then
		plrData = {
			Cash = 30000;
			Inventory = {};
		}
	end
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr
	
	local cashValue = Instance.new("IntValue")
	cashValue.Name = "Cash"
	cashValue.Value = plrData.Cash
	cashValue.Parent = ls

	for _, itemName in pairs(plrData.Inventory) do
		local foundItem = items:FindFirstChild(itemName, true)
		
		if foundItem and foundItem.Parent.Parent == items then
			foundItem:Clone().Parent = plr:WaitForChild("StarterGear")
			
			if plr.Character then
				foundItem:Clone().Parent = plr:WaitForChild("Backpack")
			end
		end
	end
end)


--Unboxing a crate
remotes:WaitForChild("BuyCrate").OnServerEvent:Connect(function(plr, crateName)
	
	local plrCash = plr.leaderstats.Cash
	
	if crates:FindFirstChild(crateName) and not playersUnboxing[plr] then
		local crateProperties = require(crates[crateName])
		
		if plrCash.Value >= crateProperties["Price"] then
			plrCash.Value -= crateProperties["Price"]
			
			local chances = crateProperties["Chances"]
			local plrChance = rnd:NextNumber() * 100
			
			local n = 0
			local rarityChosen = nil
			
			for rarity, chance in pairs(chances) do	
				n += chance
				if plrChance <= n then
					rarityChosen = rarity
					break
				end
			end
			
			local unboxableItems = crateProperties["Items"]
			
			for i = #unboxableItems, 2, -1 do
				local j = rnd:NextInteger(1, i)
				unboxableItems[i], unboxableItems[j] = unboxableItems[j], unboxableItems[i]
			end
			
			local itemChosen = nil
			
			for _, itemName in pairs(unboxableItems) do
				if items:FindFirstChild(itemName, true).Parent.Name == rarityChosen then
					itemChosen = items:FindFirstChild(itemName, true)
					break
				end
			end
			playersUnboxing[plr] = itemChosen.Name
			
			local unboxTime = rnd:NextNumber(3, 7)
			remotes:WaitForChild("CrateOpened"):FireClient(plr, crateName, itemChosen, unboxTime)
			
			local timeStarted = tick()
			while true do
				if (tick() - timeStarted >= unboxTime) or (not plr.Character) then
					break
				end
				game:GetService("RunService").Heartbeat:Wait()
			end
			
			playersUnboxing[plr] = nil
			
			itemChosen:Clone().Parent = plr:WaitForChild("StarterGear")
			if plr.Character then
				itemChosen:Clone().Parent = plr:WaitForChild("Backpack")
			end
		end
	end
end)