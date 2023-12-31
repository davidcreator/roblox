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
		failedValue.Parent = plr
	end
end)


--Main game loop
local rs = game.ReplicatedStorage:WaitForChild("CTPReplicatedStorage")
local config = require(rs:WaitForChild("CONFIGURATION"))
local maps = rs:WaitForChild("Maps")
local weapons = rs:WaitForChild("Weapons")

local statusValue = Instance.new("StringValue")
statusValue.Name = "STATUS"
statusValue.Parent = rs


while true do

	local plrsInGame = {}
	while true do
		plrsInGame = {}
		for i, plr in pairs(game.Players:GetPlayers()) do
			if plr.Character and plr.Character.Humanoid.Health > 0 then
				table.insert(plrsInGame, plr)
			end
		end

		if #plrsInGame >= config.MinimumPlayersRequired then
			break
		else
			local neededPlayers = config.MinimumPlayersRequired - #plrsInGame
			statusValue.Value = "Waiting for " .. neededPlayers .. " more player" .. (neededPlayers ~= 1 and "s" or "")

			task.wait(1)
		end
	end

	statusValue.Value = "Intermission"
	task.wait(config.IntermissionTime)

	local chosenMap = maps:GetChildren()[Random.new():NextInteger(1, #maps:GetChildren())]:Clone()
	chosenMap.Parent = workspace

	statusValue.Value = "Now entering " .. chosenMap.Name

	task.wait(config.MapWaitTime)


	for i, plr in pairs(plrsInGame) do
		local chosenTeam = i%2==1 and "Team1" or "Team2"
		plr.Team = config[chosenTeam]

		for x, tool in pairs(weapons[chosenTeam .. "Weapons"]:GetChildren()) do
			tool:Clone().Parent = plr.Backpack
		end

		local char = plr.Character
		char.HumanoidRootPart.CFrame = chosenMap.PlayerSpawns[chosenTeam .. "Spawn"].CFrame

		local connection = plr.CharacterAdded:Connect(function(newChar)
			local newHRP = newChar:WaitForChild("HumanoidRootPart")
			newHRP:GetPropertyChangedSignal("CFrame"):Wait()
			newHRP.CFrame = chosenMap.PlayerSpawns[chosenTeam .. "Spawn"].CFrame

			for x, tool in pairs(weapons[chosenTeam .. "Weapons"]:GetChildren()) do
				tool:Clone().Parent = plr.Backpack
			end
		end)

		chosenMap.Destroying:Connect(function()
			connection:Disconnect()
		end)
	end
	
	
	local scoresFolder = Instance.new("Folder")
	scoresFolder.Name = "SCORES"
	scoresFolder.Parent = rs

	local team1Score = Instance.new("IntValue")
	team1Score.Name = "TEAM 1 SCORE"
	team1Score.Parent = scoresFolder
	local team2Score = Instance.new("IntValue")
	team2Score.Name = "TEAM 2 SCORE"
	team2Score.Parent = scoresFolder
	
	local contestedValue = Instance.new("NumberValue")
	contestedValue.Name = ""
	contestedValue.Parent = scoresFolder

	
	local point = chosenMap:WaitForChild("Point"):WaitForChild("Point")
	point.Color = Color3.fromRGB(168, 168, 168)
	
	local charactersOnPoint = {}

	local gameStart = tick()
	
	local timePerPoint = 1 / config.PointsPerSecond
	local lastPointGiven = 0
	
	local pointTakenBy = nil
	local lastPointContested = nil
	
	while true do
		game:GetService("RunService").Heartbeat:Wait()

		local timeLeft = config.RoundTime - math.round((tick() - gameStart))
		local mins = math.floor(timeLeft / 60)
		local secs = timeLeft - (mins * 60)
		if string.len(secs) < 2 then
			secs = "0" .. tostring(secs)
		end
		statusValue.Value = mins .. ":" .. secs
		
		
		for i, plr in pairs(plrsInGame) do
			local char = plr.Character
			if char.Humanoid.Health > 0 and (char.HumanoidRootPart.Position * Vector3.new(1, 0, 1) - point.Position * Vector3.new(1, 0, 1)).Magnitude <= point.Size.Z/2 then
				if not table.find(charactersOnPoint, char) then
					table.insert(charactersOnPoint, char)
				end
			elseif table.find(charactersOnPoint, char) then
				table.remove(charactersOnPoint, table.find(charactersOnPoint, char))
			end
		end
		
		
		local numTeam1 = 0
		local numTeam2 = 0
		for i, charOnPoint in pairs(charactersOnPoint) do
			local plr = game.Players:GetPlayerFromCharacter(charOnPoint)
			if plr then
				if plr.Team == config.Team1 then
					numTeam1 += 1
				elseif plr.Team == config.Team2 then
					numTeam2 += 1
				end
			end
		end
		
		if numTeam1 > 0 and numTeam2 == 0 then
			if not lastPointContested or lastPointContested[1] ~= "Team1" then
				lastPointContested = {"Team1", tick()}
			elseif lastPointContested[1] == "Team1" then
				local timeContested = tick() - lastPointContested[2]
				if timeContested >= config.TimeToCapture then
					pointTakenBy = "Team1"
				end
			end
			
		elseif numTeam2 > 0 and numTeam1 == 0 then
			if not lastPointContested or lastPointContested[1] ~= "Team2" then
				lastPointContested = {"Team2", tick()}
			elseif lastPointContested[1] == "Team2" then
				local timeContested = tick() - lastPointContested[2]
				if timeContested >= config.TimeToCapture then
					pointTakenBy = "Team2"
				end
			end
			
		elseif (numTeam1 ~= 0 and numTeam2 ~= 0) or (numTeam1 == 0 and numTeam2 == 0) then
			lastPointContested = nil
		end
		
		if lastPointContested then
			contestedValue.Name = lastPointContested[1]
			contestedValue.Value = tick() - lastPointContested[2]
		else
			contestedValue.Name = ""
			contestedValue.Value = 0
		end
		
		
		if pointTakenBy then
			point.Color = config[pointTakenBy].TeamColor.Color
			
			if tick() - lastPointGiven >= timePerPoint then
				if pointTakenBy == "Team1" then
					team1Score.Value += 1
				elseif pointTakenBy == "Team2" then
					team2Score.Value += 1
				end
				lastPointGiven = tick()
			end
		else
			point.Color = Color3.fromRGB(168, 168, 168)
		end

		numPlrs = 0
		for i, plr in pairs(game.Players:GetPlayers()) do
			if plr then
				numPlrs += 1
			end
		end
		if numPlrs < config.MinimumPlayersRequired then
			break

		elseif config.StopOncePointsReached then
			if team1Score.Value >= config.PointsRequiredToStop or team2Score.Value >= config.PointsRequiredToStop then
				break
			end

		elseif timeLeft <= 0 then
			break
		end
	end

	if team1Score.Value > team2Score.Value then
		statusValue.Value = "Team " .. config.Team1.Name .. " wins!"

		for i, plr in pairs(plrsInGame) do
			if plr.Team == config.Team1 then
				plr.leaderstats.Cash.Value += config.WinReward
			end
		end

	elseif team2Score.Value > team1Score.Value then
		statusValue.Value = "Team " .. config.Team2.Name .. " wins!"

		for i, plr in pairs(plrsInGame) do
			if plr.Team == config.Team2 then
				plr.leaderstats.Cash.Value += config.WinReward
			end
		end

	else
		statusValue.Value = "Draw!"
	end

	for i, plr in pairs(plrsInGame) do
		plr.Team = nil
		plr:LoadCharacter()
	end

	scoresFolder:Destroy()
	chosenMap:Destroy()

	task.wait(config.RoundFinishedTime)
end