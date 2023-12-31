--Data handling
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("DATA STORES")


function saveData(plr)

	if not plr:FindFirstChild("FAILED TO LOAD DATA") then
		local cash = plr.leaderstats.Cash.Value

		local success, err = nil, nil
		while not success do
			success, err = pcall(function()
				return ds:SetAsync(plr.UserId, cash)
			end)
			warn(err)
			task.wait(0.1)
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


	local success, data = pcall(function()
		return ds:GetAsync(plr.UserId)
	end)

	if success then
		cashValue.Value = data or 0

	else
		local failedValue = Instance.new("StringValue")
		failedValue.Name = "FAILED TO LOAD DATA"
		task.wait(1)
		failedValue.Parent = plr
	end
end)


--Main game
local rs = game.ReplicatedStorage:WaitForChild("JuggernautReplicatedStorage")
local config = require(rs:WaitForChild("Settings"))
local weapons = rs:WaitForChild("Weapons")
local maps = rs:WaitForChild("Maps")

local status = Instance.new("StringValue")
status.Name = "STATUS"
status.Parent = rs

local rand = Random.new()


while true do
	
	while true do
		local numPlrs = 0
		
		for _, plr in pairs(game.Players:GetPlayers()) do
			local char = plr.Character
			if char and char.Humanoid.Health > 0 then
				numPlrs += 1
			end
		end
		
		if numPlrs < config.PlayersRequiredToStart then
			local numPlayersNeeded = config.PlayersRequiredToStart - numPlrs
			status.Value = "Waiting for " .. numPlayersNeeded .. " more player" .. (numPlayersNeeded == 1 and "" or "s")
		else
			break
		end
		task.wait(0.2)
	end
	
	
	for i = config.IntermissionTime, 0, -1 do
		status.Value = "Selecting map in " .. i .. " second" .. (i == 1 and "" or "s")
		task.wait(1)
	end
	
	
	local chosenMap = maps:GetChildren()[rand:NextInteger(1, #maps:GetChildren())]:Clone()
	chosenMap.Parent = workspace
	
	for i = config.MapWaitTime, 0, -1 do
		status.Value = "Entering " .. chosenMap.Name .. " in " .. i .. " second" .. (i == 1 and "" or "s")
		task.wait(1)
	end
	
	
	local playersInGame = {}

	for _, plr in pairs(game.Players:GetPlayers()) do
		local char = plr.Character
		if char and char.Humanoid.Health > 0 then
			table.insert(playersInGame, plr)
		end
	end
	
	if #playersInGame < config.PlayersRequiredToStart then
		break
		
	else
		local mapSpawns = chosenMap.Spawns:GetChildren()
		for i, mapSpawn in pairs(mapSpawns) do
			if i <= #playersInGame then
				playersInGame[i].Character.HumanoidRootPart.CFrame = mapSpawn.CFrame
			end
		end
		
		
		local juggernaut = playersInGame[rand:NextInteger(1, #playersInGame)]
		table.remove(playersInGame, table.find(playersInGame, juggernaut))
		local juggernautCharacter = juggernaut.Character
		
		for property, value in pairs(config.JuggernautHumanoidProperties) do
			juggernautCharacter.Humanoid[property] = value
		end
		juggernautCharacter.Humanoid.Health = juggernautCharacter.Humanoid.MaxHealth
		
		for _, tool in pairs(weapons.JUGGERNAUT:GetChildren()) do
			tool:Clone().Parent = juggernaut.Backpack
		end
		
		local highlight = Instance.new("Highlight")
		highlight.OutlineColor = Color3.fromRGB(123, 46, 255)
		highlight.FillTransparency = 1
		highlight.OutlineTransparency = 0
		highlight.Parent = juggernautCharacter
		
		
		local juggernautHealth = Instance.new("IntValue")
		juggernautHealth.Name = "JUGGERNAUT HEALTH"
		juggernautHealth.Value = juggernautCharacter.Humanoid.Health
		juggernautHealth.Parent = rs
		
		juggernautCharacter.Humanoid.HealthChanged:Connect(function()
			if not juggernautCharacter or not juggernautCharacter:FindFirstChild("Humanoid") or juggernautCharacter.Humanoid.Health <= 0 then
				juggernautHealth.Value = 0
				juggernautCharacter = nil
			else
				juggernautHealth.Value = juggernautCharacter.Humanoid.Health
			end
		end)
		
		
		for _, plr in pairs(playersInGame) do
			local char = plr.Character
			
			if plr ~= juggernaut then
				for property, value in pairs(config.SurvivorHumanoidProperties) do
					char.Humanoid[property] = value
				end
				char.Humanoid.Health = char.Humanoid.MaxHealth
				
				for _, tool in pairs(weapons.SURVIVORS:GetChildren()) do
					tool:Clone().Parent = plr.Backpack
				end
				
				char.Humanoid.Died:Connect(function()
					table.remove(playersInGame, table.find(playersInGame, plr))
				end)
			end
		end
		
		
		local roundStarted = tick()
		local winner = "SURVIVORS"
		
		while tick() - roundStarted < config.RoundDuration do
			
			local roundCurrentLength = tick() - roundStarted
			local roundEndsIn = math.round(config.RoundDuration - roundCurrentLength)
			
			status.Value = "Round ends in " .. roundEndsIn .. " second" .. (roundEndsIn == 1 and "" or "s")
			
			
			if #playersInGame == 0 then
				winner = "JUGGERNAUT"
				break
				
			elseif not juggernautCharacter then
				break
			end
			
			
			game:GetService("RunService").Heartbeat:Wait()
		end
		
		
		if winner == "SURVIVORS" then
			status.Value = "The survivors won!"
			
			for _, plr in pairs(playersInGame) do
				if plr then
					plr.leaderstats.Cash.Value += config.SurviveReward
				end
			end
			
		else
			status.Value = "The Juggernaut won by eliminating everyone!"
			
			if juggernaut then
				juggernaut.leaderstats.Cash.Value += config.JuggernautWinReward
			end
		end
		
		
		for _, plr in pairs(game.Players:GetPlayers()) do
			plr:LoadCharacter()
		end
		
		juggernautHealth:Destroy()
		chosenMap:Destroy()
		
		task.wait(config.RoundEndTime)
	end
end