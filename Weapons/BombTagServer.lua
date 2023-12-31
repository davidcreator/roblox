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



local rs = game.ReplicatedStorage:WaitForChild("BombTagReplicatedStorage")
local config = require(rs:WaitForChild("CONFIGURATION"))
local maps = rs:WaitForChild("Maps")


local status = Instance.new("StringValue")
status.Name = "STATUS"
status.Parent = rs

local currentTagged = Instance.new("ObjectValue")
currentTagged.Name = "CURRENT TAGGED PLAYER"
currentTagged.Parent = rs

local explodeTimer = Instance.new("IntValue")
explodeTimer.Name = "EXPLODE TIMER"
explodeTimer.Parent = rs


function getPlayers(playerList)
	
	local playerList = playerList or game.Players:GetPlayers()
	local playersInGame = {}

	for i, plr in pairs(playerList) do
		local char = plr.Parent == game.Players and plr.Character or plr
		if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
			table.insert(playersInGame, char)
		end
	end
	return playersInGame
end


while true do
	
	local playersInGame = {}
	
	while #playersInGame < config.MinimumPlayersNeeded do
		playersInGame = getPlayers()
		
		if #playersInGame < config.MinimumPlayersNeeded then
			local neededPlayers = config.MinimumPlayersNeeded - #playersInGame
			
			status.Value = "Waiting for " .. neededPlayers .. " more player" .. (neededPlayers ~= 1 and "s" or "")

			task.wait(1)
		end
	end
	
	for i = config.IntermissionTime, 0, -1 do
		status.Value = "Choosing map in " .. i .. " seconds"
		task.wait(1)
	end
	
	local chosenMap = maps:GetChildren()[Random.new():NextInteger(1, #maps:GetChildren())]:Clone()
	chosenMap.Parent = workspace
	
	status.Value = "Now entering " .. chosenMap.Name
	
	task.wait(config.MapWaitTime)
	
	
	playersInGame = getPlayers()
	
	if #playersInGame < config.MinimumPlayersNeeded then
		break
	else
		
		local tagDebounce = false
		for i, char in pairs(playersInGame) do
			
			char.Humanoid.WalkSpeed = config.SurvivorSpeed
			char.HumanoidRootPart.CFrame = chosenMap.SPAWN.CFrame
			
			char.Humanoid.Touched:Connect(function(hit)
				if not tagDebounce and currentTagged.Value then
					
					local hitChar = hit.Parent
					if game.Players:GetPlayerFromCharacter(hitChar) then
						
						if char == currentTagged.Value then
							tagDebounce = true
							
							char.Humanoid.WalkSpeed = config.SurvivorSpeed
							hitChar.Humanoid.WalkSpeed = config.TaggedSpeed
							
							currentTagged.Value = hitChar
							
							task.wait(config.TagCooldown)
							tagDebounce = false
							
						elseif hitChar == currentTagged.Value then
							tagDebounce = true
							
							hitChar.Humanoid.WalkSpeed = config.SurvivorSpeed
							char.Humanoid.WalkSpeed = config.TaggedSpeed

							currentTagged.Value = char

							task.wait(config.TagCooldown)
							tagDebounce = false
						end
					end
				end
			end)
		end
		
		local iterations = 0
		while true do
			iterations += 1
			
			playersInGame = getPlayers(playersInGame)
			
			if #playersInGame > 1 then
				local randomChar = playersInGame[Random.new():NextInteger(1, #playersInGame)]
				randomChar.Humanoid.WalkSpeed = config.TaggedSpeed
				
				if iterations == 1 then
					randomChar.HumanoidRootPart.Anchored = true
					
					for i = config.PreparationTime, 0, -1 do
						status.Value = randomChar.Name .. " is tagged. You have " .. i .. "s to run."
						task.wait(1)
					end
					currentTagged.Value = randomChar
					status.Value = randomChar.Name .. " is tagged"
					randomChar.HumanoidRootPart.Anchored = false
					
				else
					currentTagged.Value = randomChar
					status.Value = randomChar.Name .. " is tagged"
				end
				
				local explodesIn = config.BombExplodeTimes[#playersInGame]
				explodeTimer.Value = explodesIn
				
				local bombTimerStarted = tick()
				while tick() - bombTimerStarted < explodesIn do
					
					game:GetService("RunService").Heartbeat:Wait()
					explodeTimer.Value = explodesIn - math.round(tick() - bombTimerStarted)
					
					if not currentTagged.Value or #getPlayers(playersInGame) < 2 then
						break
					end
				end
				
				if currentTagged.Value and #getPlayers(playersInGame) >= 2 then
					local explosion = Instance.new("Explosion")
					explosion.DestroyJointRadiusPercent = 0
					explosion.Position = currentTagged.Value.HumanoidRootPart.Position
					explosion.Parent = workspace
					
					currentTagged.Value.Humanoid.Health = 0
					currentTagged.Value = nil
				end
			else
				break
			end
		end
		
		local winner = game.Players:GetPlayerFromCharacter(playersInGame[1])
		if winner then
			winner.leaderstats.Cash.Value += config.SurviveReward
			status.Value = winner.Name .. " wins!"
		end
		
		chosenMap:Destroy()
		for i, plr in pairs(game.Players:GetPlayers()) do
			plr:LoadCharacter()
		end
		
		task.wait(config.RoundEndTime)
	end
end