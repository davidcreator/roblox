local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("Mining Simulator DataStore")

local rs = game.ReplicatedStorage:WaitForChild("MiningSimulatorReplicatedStorage")
local re = rs:WaitForChild("RemoteEvent")

local stones = rs:WaitForChild("StoneTypes")
local ores = rs:WaitForChild("OreTypes"):GetChildren()
for i, stone in pairs(stones:GetChildren()) do
	table.insert(ores, stone)
end

local pickaxes = rs:WaitForChild("Pickaxes")
local backpacks = rs:WaitForChild("Backpacks")

local moduleScripts = rs:WaitForChild("CONFIGURATION")
local stonesConfig = require(moduleScripts:WaitForChild("Stones"))
local oresConfig = require(moduleScripts:WaitForChild("Ores"))
local pickaxesConfig = require(moduleScripts:WaitForChild("Pickaxes"))
local backpacksConfig = require(moduleScripts:WaitForChild("Backpacks"))
local otherConfig = require(moduleScripts:WaitForChild("OtherSettings"))

local animations = rs:WaitForChild("Animations")

local areas = workspace:WaitForChild("MiningSimulatorAreas")


--Data handling
function saveData(plr)

	if not plr:FindFirstChild("FAILED TO LOAD DATA") then

		local cash = plr.leaderstats.Cash.Value
		
		local pickaxe = plr.Equipment.Pickaxe.Value
		local backpack = plr.Equipment.Backpack.Value
		
		local backpackContents = {}
		for i, oreValue in pairs(plr.BackpackContents:GetChildren()) do
			backpackContents[oreValue.Name] = oreValue.Value
		end
		
		local compiledData = {
			Cash = cash,
			Pickaxe = pickaxe,
			Backpack = backpack,
			BackpackContents = backpackContents
		}
		

		local success, err
		while not success do
			
			if err then
				warn(err)
			end

			success, err = pcall(function()
				ds:SetAsync(plr.UserId, compiledData)
			end)
			task.wait(1)
		end
	end
end

game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
	for i, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)


game.Players.PlayerAdded:Connect(function(plr)

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr

	local cashValue = Instance.new("IntValue")
	cashValue.Name = "Cash"
	cashValue.Parent = ls
	
	local equipmentFolder = Instance.new("Folder")
	equipmentFolder = Instance.new("Folder")
	equipmentFolder.Name = "Equipment"
	equipmentFolder.Parent = plr
	
	local pickaxeValue = Instance.new("StringValue")
	pickaxeValue.Name = "Pickaxe"
	pickaxeValue.Parent = equipmentFolder
	
	local backpackValue = Instance.new("StringValue")
	backpackValue.Name = "Backpack"
	backpackValue.Parent = equipmentFolder
	
	local backpackContents = Instance.new("Folder")
	backpackContents.Name = "BackpackContents"
	backpackContents.Parent = plr

	for i, ore in pairs(ores) do
		local oreValue = Instance.new("IntValue")
		oreValue.Name = ore.Name
		oreValue.Parent = backpackContents
	end
	
	
	plr.CharacterAdded:Connect(function(char)
		
		repeat task.wait(0.1) until pickaxeValue.Value ~= nil and backpackValue.Value ~= nil

		local plrPickaxe = pickaxes[pickaxeValue.Value]:Clone()
		plrPickaxe.Parent = plr:WaitForChild("Backpack")

		local plrBackpack = backpacks[backpackValue.Value]:Clone()
		plrBackpack.Name = "BACKPACK"
		
		for i, descendant in pairs(plrBackpack:GetDescendants()) do
			if descendant:IsA("BasePart") and descendant ~= plrBackpack.RootAttachment then
				local newWC = Instance.new("WeldConstraint")
				newWC.Part0 = plrBackpack.RootAttachment
				newWC.Part1 = descendant
				newWC.Parent = plrBackpack.RootAttachment
			end
		end
		
		local backpackWeld = Instance.new("Weld")
		backpackWeld.Name = "BACKPACK WELD"
		backpackWeld.Part0 = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
		backpackWeld.Part1 = plrBackpack:WaitForChild("RootAttachment")
		backpackWeld.Parent = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
		
		plrBackpack.Parent = char
	end)
	

	local success, data = pcall(function() 
		return ds:GetAsync(plr.UserId)
	end)

	if success then
		
		local cash = data and data.Cash or 0
		local pickaxe = data and data.Pickaxe or "Basic Pickaxe"
		local backpack = data and data.Backpack or "Basic Backpack"
		local backpackContentsData = data and data.BackpackContents or {}
		
		cashValue.Value = cash
		pickaxeValue.Value = pickaxe
		backpackValue.Value = backpack
		
		for ore, amount in pairs(backpackContentsData) do
			backpackContents[ore].Value = amount
		end
		
		print("Data successfully loaded for " .. plr.Name)
		
	else
		warn("Data not loaded for " .. plr.Name)

		local failedToLoad = Instance.new("StringValue")
		failedToLoad.Name = "FAILED TO LOAD DATA"
		failedToLoad.Parent = plr

		re:FireClient(plr, "FAILED TO LOAD DATA")
	end
end)


--Client requests
local pickaxeCooldowns = {}

re.OnServerEvent:Connect(function(plr, instruction, data)
	
	if instruction == "BUY PICKAXE" then
		
		local cash = plr.leaderstats.Cash
		local plrPickaxe = plr.Equipment.Pickaxe
		
		local newPickaxe = data[1]
		
		if pickaxes:FindFirstChild(newPickaxe) and plrPickaxe.Value ~= newPickaxe then
			local price = pickaxesConfig[newPickaxe].cost
			
			if price <= cash.Value then
				cash.Value -= price
				
				for i, tool in pairs(plr.Backpack:GetChildren()) do
					if tool.Name == plrPickaxe.Value then
						tool:Destroy()
					end
				end
				if plr.Character then
					for i, child in pairs(plr.Character:GetChildren()) do
						if child:IsA("Tool") and child.Name == plrPickaxe.Value then 
							child:Destroy()
						end
					end
				end
				
				plrPickaxe.Value = newPickaxe
				pickaxes[plrPickaxe.Value]:Clone().Parent = plr.Backpack
			end
		end
		
	elseif instruction == "BUY BACKPACK" then
		
		local cash = plr.leaderstats.Cash
		local plrBackpack = plr.Equipment.Backpack

		local newBackpack = data[1]

		if backpacks:FindFirstChild(newBackpack) and plrBackpack.Value ~= newBackpack then
			local price = backpacksConfig[newBackpack].cost

			if price <= cash.Value then
				cash.Value -= price

				plrBackpack.Value = newBackpack

				if plr.Character then
					local existingBackpack = plr.Character:FindFirstChild("BACKPACK")
					if existingBackpack then existingBackpack:Destroy() end
					
					local newBackpackModel = backpacks[plrBackpack.Value]:Clone()
					newBackpackModel.Name = "BACKPACK"
					
					for i, descendant in pairs(plrBackpack:GetDescendants()) do
						if descendant:IsA("BasePart") and descendant ~= plrBackpack.RootAttachment then
							local newWC = Instance.new("WeldConstraint")
							newWC.Part0 = plrBackpack.RootAttachment
							newWC.Part1 = descendant
							newWC.Parent = plrBackpack.RootAttachment
						end
					end

					local backpackWeld = Instance.new("Weld")
					backpackWeld.Name = "BACKPACK WELD"
					backpackWeld.Part0 = plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso")
					backpackWeld.Part1 = newBackpackModel:WaitForChild("RootAttachment")
					backpackWeld.Parent = plr.Character:FindFirstChild("UpperTorso") or plr.Character:FindFirstChild("Torso")
					
					newBackpackModel.Parent = plr.Character
				end
			end
		end
		
	elseif instruction == "MINE ORE" then
		
		if not pickaxeCooldowns[plr] then
			
			local char = plr.Character
			local mouseTarget = data[1]
			if char and char.Humanoid.Health > 0 and mouseTarget and mouseTarget.Parent == workspace:WaitForChild("SPAWNED ORES FOLDER") then
				
				local distance = (char.HumanoidRootPart.Position - mouseTarget.Position).Magnitude
				if distance <= otherConfig.MaxOreRange then
					
					local backpackStorageSize = backpacksConfig[plr.Equipment.Backpack.Value].storage
					
					local oresInBackpack = 0
					local backpackContents = plr.BackpackContents
					for i, oreValue in pairs(backpackContents:GetChildren()) do
						oresInBackpack += oreValue.Value
					end
					
					if oresInBackpack < backpackStorageSize then
						
						if char:FindFirstChildOfClass("Tool") and char:FindFirstChildOfClass("Tool").Name == plr.Equipment.Pickaxe.Value then
							pickaxeCooldowns[plr] = true
							
							local swingAnim = char.Humanoid.Animator:LoadAnimation(animations.PickaxeSwing)
							swingAnim:Play()
							
							local pickaxeDamage = pickaxesConfig[plr.Equipment.Pickaxe.Value].damage
							mouseTarget.HEALTH.Value -= pickaxeDamage
							
							if mouseTarget.HEALTH.Value <= 0 then
								
								local oreName = mouseTarget.Name
								plr.BackpackContents[oreName].Value += 1
								
								mouseTarget:Destroy()
							end
							
							task.wait(pickaxesConfig[plr.Equipment.Pickaxe.Value].cooldown)
							pickaxeCooldowns[plr] = false
						end
					end
				end
			end
		end
	end
end)


--Sell ores
local touchDebounce = {}

areas:WaitForChild("SellZone").Touched:Connect(function(hit)
	local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
	
	if plr and not touchDebounce[plr] then
		touchDebounce[plr] = true
		
		local totalMinedValue = 0
		
		for i, oreValue in pairs(plr.BackpackContents:GetChildren()) do
			local oreCost = oresConfig[oreValue.Name] and oresConfig[oreValue.Name].cost or stonesConfig[oreValue.Name] and stonesConfig[oreValue.Name].cost
			totalMinedValue += oreValue.Value * oreCost
			
			oreValue.Value = 0
		end
		
		local pickaxeMultiplier = pickaxesConfig[plr.Equipment.Pickaxe.Value].multiplier
		totalMinedValue *= pickaxeMultiplier
		
		plr.leaderstats.Cash.Value += totalMinedValue
		
		task.wait(3)
		touchDebounce[plr] = false
	end
end)


--Spawn quarry
while true do
	
	local workspaceOresFolder = workspace:FindFirstChild("SPAWNED ORES FOLDER") or Instance.new("Folder")
	workspaceOresFolder.Name = "SPAWNED ORES FOLDER"
	workspaceOresFolder.Parent = workspace
	
	workspaceOresFolder:ClearAllChildren()
	
	local oreZone = areas:WaitForChild("OreZone")
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		local char = plr.Character
		if char and char.HumanoidRootPart.Position.Y <= oreZone.Position.Y then
			plr:LoadCharacter()
		end
	end
	
	
	local oresWide = math.ceil(oreZone.Size.X / stones["Light Stone"].Size.X)
	local oresLong = math.ceil(oreZone.Size.Z / stones["Light Stone"].Size.Z)
	local oresDeep = otherConfig.OreDepth
	
	local oreStart = oreZone.Position + Vector3.new(-oreZone.Size.X/2, oreZone.Size.Y/2, -oreZone.Size.Z/2) + Vector3.new(stones["Light Stone"].Size.X/2, -stones["Light Stone"].Size.Y/2, stones["Light Stone"].Size.Z/2)
	
	for y = 0, (oresDeep - 1) do
		for x = 0, (oresWide - 1) do
			for z = 0, (oresLong - 1) do
				
				local orePosition = oreStart + Vector3.new(x * stones["Light Stone"].Size.X, -y * stones["Light Stone"].Size.Y, z * stones["Light Stone"].Size.Z)
				
				local availableOres = {}
				for i, ore in pairs(ores) do
					local config = oresConfig[ore.Name] or stonesConfig[ore.Name]
					if config.minDepth <= y and config.maxDepth >= y then
						for n = 1, config.chance do
							table.insert(availableOres, ore)
						end
					end
				end
				
				local chosenOre = availableOres[Random.new():NextInteger(1, #availableOres)]:Clone()
				chosenOre.Position = orePosition
				chosenOre.Parent = workspaceOresFolder
				
				local oreHealth = Instance.new("NumberValue")
				oreHealth.Name = "HEALTH"
				oreHealth.Value = oresConfig[chosenOre.Name] and oresConfig[chosenOre.Name].health or stonesConfig[chosenOre.Name].health
				oreHealth.Parent = chosenOre
			end
		end
	end
	
	task.wait(otherConfig.QuarryRefreshTime)
end