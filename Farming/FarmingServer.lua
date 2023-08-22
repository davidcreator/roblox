--SAVING DATA
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("FarmingDataStores")

function saveData(player)
	
	local seeds = {}
	for i, seed in pairs(player.SeedInventory:GetChildren()) do
		seeds[seed.Name] = seed.Value
		--ds:SetAsync(player.UserId .. seed.Name .. "Seed", seed.Value)
	end
	ds:SetAsync(player.UserId .. "Seeds", seeds)
	
	local crops = {}
	for i, crop in pairs(player.CropInventory:GetChildren()) do
		crops[crop.Name] = crop.Value
		--ds:SetAsync(player.UserId .. crop.Name .. "Crop", crop.Value)
	end
	ds:SetAsync(player.UserId .. "Crops", crops)
	
	ds:SetAsync(player.UserId .. "Cash", player.leaderstats.Cash.Value)
end

game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
	for i, player in pairs(game.Players:GetPlayers()) do
		saveData(player)
	end
end)

--LOADING DATA
local crops = game.ReplicatedStorage:WaitForChild("Crops")

game.Players.PlayerAdded:Connect(function(player)
	
	local ls = Instance.new("Folder", player)
	ls.Name = "leaderstats"
	
	local cash = Instance.new("NumberValue")
	cash.Name = "Cash"
	cash.Parent = ls
	
	
	local seedInv = Instance.new("Folder", player)
	seedInv.Name = "SeedInventory"
	
	local cropInv = Instance.new("Folder", player)
	cropInv.Name = "CropInventory"
	
	local seedData = ds:GetAsync(player.UserId .. "Seeds")
	local cropData = ds:GetAsync(player.UserId .. "Crops")
	
	for i, crop in pairs(crops:GetChildren()) do
		
		local seedValue = Instance.new("IntValue")
		seedValue.Name = crop.Name
		seedValue.Parent = seedInv
		
		seedValue.Value = seedData and seedData[crop.Name] or 3
		
		local cropValue = seedValue:Clone()
		cropValue.Parent = cropInv
		
		cropValue.Value = cropData and cropData[crop.Name] or 0
	end
	
	local cashData = ds:GetAsync(player.UserId .. "Cash") or 0
	cash.Value = cashData
end)


--HANDLING CLIENT REQUESTS
local re = game.ReplicatedStorage:WaitForChild("FarmingRemoteEvent")

re.OnServerEvent:Connect(function(player, instruction, crop, amount)
	--SELLING CROPS
	if instruction == "SELL" and player.CropInventory:FindFirstChild(crop) then
		local toSell = math.clamp(player.CropInventory[crop].Value, 0, amount)
		
		player.CropInventory[crop].Value -= toSell
		player.leaderstats.Cash.Value += toSell * crops[crop].SellValue.Value
		
	--BUYING SEEDS
	elseif instruction == "BUY" and crops:FindFirstChild(crop) then
		local price = crops[crop].PriceToBuy.Value * amount
		
		if player.leaderstats.Cash.Value >= price then
			player.leaderstats.Cash.Value -= price
			player.SeedInventory[crop].Value += amount
		end
		
	--TURN GRASS INTO FARMLAND
	elseif instruction == "FARMLAND" and crop.Name == "Grass" then
		local cframe = crop.PrimaryPart.CFrame
		local farmland = game.ReplicatedStorage:WaitForChild("GrassTypes"):WaitForChild("Farmland"):Clone()
		
		farmland:SetPrimaryPartCFrame(cframe)
		
		crop:Destroy()
		farmland.Parent = workspace.GrassFolder
		
	--PLANT SEEDS
	elseif instruction == "PLANT" and game.ReplicatedStorage.Crops:FindFirstChild(crop) then
		if player.SeedInventory[crop].Value > 0 and amount.Name == "Farmland" then
			
			player.SeedInventory[crop].Value -= 1
			
			local cframe = amount.PrimaryPart.CFrame
			amount:Destroy()
			
			local growTime = game.ReplicatedStorage.Crops[crop].Time.Value
			local stages = game.ReplicatedStorage.Crops[crop].Stages
			
			local oldStage = nil
			
			for i = 1, (#stages:GetChildren() - 1) do
				
				local newStage = stages[i]:Clone()
				newStage:SetPrimaryPartCFrame(cframe)
				
				newStage.Parent = workspace.GrassFolder
				
				if oldStage then oldStage:Destroy() end
				oldStage = newStage
				
				wait(growTime / (#stages:GetChildren() - 1))
			end
			
			oldStage:Destroy()
			
			local finalStage = stages[#stages:GetChildren()]:Clone()
			finalStage:SetPrimaryPartCFrame(cframe)
			finalStage.Name = crop
			finalStage.Parent = workspace.GrassFolder
			
			local grown = Instance.new("StringValue")
			grown.Name = "FULLY GROWN"
			grown.Parent = finalStage
		end
		
	--HARVEST CROPS
	elseif instruction == "HARVEST" and crop:FindFirstChild("FULLY GROWN") then
		local cropName = crop.Name
		
		local yieldMin = game.ReplicatedStorage.Crops[cropName].YieldMin.Value
		local yieldMax = game.ReplicatedStorage.Crops[cropName].YieldMax.Value
		local yield = math.random(yieldMin, yieldMax)
		
		local cframe = crop.PrimaryPart.CFrame
		local farmland = game.ReplicatedStorage:WaitForChild("GrassTypes"):WaitForChild("Farmland"):Clone()

		farmland:SetPrimaryPartCFrame(cframe)

		crop:Destroy()
		farmland.Parent = workspace.GrassFolder
		
		player.CropInventory[cropName].Value += yield
	end
end)


--MAKE GRASS CLICKABLE
function addCD(block)
	local cd = Instance.new("ClickDetector")
	cd.Parent = block
	
	cd.MouseClick:Connect(function(player)
		re:FireClient(player, block)
	end)
end

for i, block in pairs(workspace.GrassFolder:GetChildren()) do
	addCD(block)
end
workspace.GrassFolder.ChildAdded:Connect(addCD)


--OPEN SHOP WHEN ZONE ENTERED
local debounce = {}

workspace.SeedsShop.ShopZone.Touched:Connect(function(hit)
	
	local char = hit.Parent
	local plr = game.Players:GetPlayerFromCharacter(char)
	
	if plr and not debounce[plr] then
		debounce[plr] = true
		
		re:FireClient(plr, workspace.SeedsShop.ShopZone)
		
		wait(1)
		debounce[plr] = false
	end
end)