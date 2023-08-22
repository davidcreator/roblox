--SAVING CASH
local dss = game:GetService("DataStoreService")
local miningDS = dss:GetDataStore("MiningData")


function saveData(player)
	
	miningDS:SetAsync(player.UserId, player.leaderstats.Cash.Value)
end

game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
	
	for i, player in pairs(game.Players:GetPlayers()) do
		saveData(player)
	end
end)


game.Players.PlayerAdded:Connect(function(player)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = leaderstats
	
	local cashData = miningDS:GetAsync(player.UserId) or 0
	
	cash.Value = cashData
end)


--BREAKING ORES WITH PICKAXE
local oreZone = workspace:WaitForChild("OreArea")

local re = game.ReplicatedStorage:WaitForChild("MiningRE")

local cooldowns = {}

re.OnServerEvent:Connect(function(player, target, mouseCF, camCF)
	
	if not cooldowns[player] and player.Character:FindFirstChild("Pickaxe") and target and target.Parent == oreZone then

		local hrp = player.Character.HumanoidRootPart

		local rayParams = RaycastParams.new()
		rayParams.FilterType = Enum.RaycastFilterType.Whitelist
		rayParams.FilterDescendantsInstances = {oreZone}

		local rayResult = workspace:Raycast(camCF.Position, CFrame.new(camCF.Position, mouseCF.Position).LookVector * 1000, rayParams)
		
		if rayResult and rayResult.Instance == target and (hrp.Position - rayResult.Position).Magnitude < 20 then

			cooldowns[player] = true
			
			target.Health.Value -= 1
			
			re:FireClient(player, target.Name, target.Health.Value)

			if target.Health.Value <= 0 then

				local reward = target.CashValue.Value

				target:Destroy()

				player.leaderstats.Cash.Value += reward
			end

			wait(1)
			cooldowns[player] = false
		end
	end
end)


--ORE GENERATION
local ores = game.ReplicatedStorage:WaitForChild("Ores")

local width = 10
local height = 60

while true do
	
	for i, player in pairs(game.Players:GetPlayers()) do
		player:LoadCharacter()
	end
	
	oreZone:ClearAllChildren()
	
	local oreSize = oreZone.Size.X / width
	
	local start = oreZone.Position + Vector3.new(-oreZone.Size.X/2 + oreSize/2, -oreSize/2, -oreZone.Size.Z/2 + oreSize/2)
	
	for y = 0, height - 1 do
		
		for x = 0, width - 1 do
			for z = 0, width - 1 do
				
				local availableOres = {}
				
				for a, ore in pairs(ores:GetChildren()) do
					
					local minY = ore.MinHeight.Value
					local maxY = ore.MaxHeight.Value
					
					if y >= minY and y <= maxY then
						
						local rarity = ore.Rarity.Value
						
						for b = 1, rarity do
							table.insert(availableOres, ore)
						end
					end
				end
				
				local randomOre = availableOres[math.random(1, #availableOres)]:Clone()
				randomOre.Size = Vector3.new(oreSize, oreSize, oreSize)
				
				local pos = start + Vector3.new(oreSize * x, -oreSize * y, oreSize * z)
				randomOre.Position = pos
				
				randomOre.Parent = oreZone
			end
		end
	end
	
	wait(600)
end