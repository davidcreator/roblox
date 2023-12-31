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
local rs = game.ReplicatedStorage:WaitForChild("CTFReplicatedStorage")
local config = require(rs:WaitForChild("CONFIGURATION"))
local maps = rs:WaitForChild("Maps")
local weapons = rs:WaitForChild("Weapons")
local flag = rs:WaitForChild("Flag"):WaitForChild("Flag")

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
	
	
	local team1FlagSpawn = chosenMap.FlagSpawns.Team1Flag
	local team2FlagSpawn = chosenMap.FlagSpawns.Team2Flag
	
	local team1Flag = flag:Clone()
	team1Flag.Base.Color = config.Team1.TeamColor.Color
	team1Flag.FlagModel.Flag.Color = config.Team1.TeamColor.Color
	team1Flag:SetPrimaryPartCFrame(team1FlagSpawn.CFrame * CFrame.Angles(0, 0, math.rad(-90)))
	team1Flag.Parent = chosenMap
	
	local team2Flag = flag:Clone()
	team2Flag.Base.Color = config.Team2.TeamColor.Color
	team2Flag.FlagModel.Flag.Color = config.Team2.TeamColor.Color
	team2Flag:SetPrimaryPartCFrame(team2FlagSpawn.CFrame * CFrame.Angles(0, 0, math.rad(-90)))
	team2Flag.Parent = chosenMap
	
	local scoresFolder = Instance.new("Folder")
	scoresFolder.Name = "SCORES"
	scoresFolder.Parent = rs
	
	local team1Score = Instance.new("IntValue")
	team1Score.Name = "TEAM 1 SCORE"
	team1Score.Parent = scoresFolder
	local team2Score = Instance.new("IntValue")
	team2Score.Name = "TEAM 2 SCORE"
	team2Score.Parent = scoresFolder
	
	local flag1Taken = false
	local flag2Taken = false
	
	team1Flag.Base.Touched:Connect(function(hit)
		
		local charTouched = hit.Parent
		local plrTouched = game.Players:GetPlayerFromCharacter(charTouched)
		if plrTouched and plrTouched.Team == config.Team2 and charTouched.Humanoid.Health > 0 and not flag1Taken then
			flag1Taken = charTouched
			
			local flagOnBack = team1Flag.FlagModel:Clone()
			for i, desc in pairs(flagOnBack:GetDescendants()) do
				if desc:IsA("BasePart") then
					desc.CanCollide = false
					desc.Anchored = false
					
					if desc ~= flagOnBack.PrimaryPart then
						local wc = Instance.new("WeldConstraint")
						wc.Part0 = flagOnBack.PrimaryPart
						wc.Part1 = desc
						wc.Parent = flagOnBack.PrimaryPart
					end
				end
			end
			local torso = charTouched:FindFirstChild("UpperTorso") or charTouched:FindFirstChild("Torso") or charTouched.HumanoidRootPart
			flagOnBack:SetPrimaryPartCFrame((torso.CFrame - torso.CFrame.LookVector/2) * CFrame.Angles(0, 0, math.rad(-90)))
			local wc = Instance.new("WeldConstraint")
			wc.Part0 = torso
			wc.Part1 = flagOnBack.PrimaryPart
			wc.Parent = flagOnBack
			
			flagOnBack.Name = "FLAG"
			flagOnBack.Parent = charTouched
			
			for i, desc in pairs(team1Flag.FlagModel:GetDescendants()) do
				if desc:IsA("BasePart") then
					desc.Transparency = 1
					desc.CanCollide = false
				end
			end
			
			charTouched.Humanoid.Died:Wait()
			if flag1Taken == charTouched then
				flag1Taken = false
				
				for i, desc in pairs(team1Flag.FlagModel:GetDescendants()) do
					if desc:IsA("BasePart") then
						desc.Transparency = 0
					end
				end
			end
			
		elseif flag2Taken == charTouched and charTouched.Humanoid.Health > 0  and plrTouched.Team == config.Team1 then
			flag2Taken = false
			charTouched["FLAG"]:Destroy()
			team1Score.Value += 1
			for i, desc in pairs(team2Flag.FlagModel:GetDescendants()) do
				if desc:IsA("BasePart") then
					desc.Transparency = 0
					desc.CanCollide = false
				end
			end
		end
	end)
	
	team2Flag.Base.Touched:Connect(function(hit)

		local charTouched = hit.Parent
		local plrTouched = game.Players:GetPlayerFromCharacter(charTouched)
		if plrTouched and plrTouched.Team == config.Team1 and charTouched.Humanoid.Health > 0 and not flag2Taken then
			flag2Taken = charTouched

			local flagOnBack = team2Flag.FlagModel:Clone()
			for i, desc in pairs(flagOnBack:GetDescendants()) do
				if desc:IsA("BasePart") then
					desc.CanCollide = false
					desc.Anchored = false

					if desc ~= flagOnBack.PrimaryPart then
						local wc = Instance.new("WeldConstraint")
						wc.Part0 = flagOnBack.PrimaryPart
						wc.Part1 = desc
						wc.Parent = flagOnBack.PrimaryPart
					end
				end
			end
			local torso = charTouched:FindFirstChild("UpperTorso") or charTouched:FindFirstChild("Torso") or charTouched.HumanoidRootPart
			flagOnBack:SetPrimaryPartCFrame((torso.CFrame - torso.CFrame.LookVector/2) * CFrame.Angles(0, 0, math.rad(-90)))
			local wc = Instance.new("WeldConstraint")
			wc.Part0 = torso
			wc.Part1 = flagOnBack.PrimaryPart
			wc.Parent = flagOnBack
			
			flagOnBack.Name = "FLAG"
			flagOnBack.Parent = charTouched

			for i, desc in pairs(team2Flag.FlagModel:GetDescendants()) do
				if desc:IsA("BasePart") then
					desc.Transparency = 1
				end
			end

			charTouched.Humanoid.Died:Wait()
			if flag2Taken == charTouched then
				flag2Taken = false

				for i, desc in pairs(team2Flag.FlagModel:GetDescendants()) do
					if desc:IsA("BasePart") then
						desc.Transparency = 0
					end
				end
			end

		elseif flag1Taken == charTouched and charTouched.Humanoid.Health > 0 and plrTouched.Team == config.Team2 then
			flag1Taken = false
			charTouched["FLAG"]:Destroy()
			team2Score.Value += 1
			for i, desc in pairs(team1Flag.FlagModel:GetDescendants()) do
				if desc:IsA("BasePart") then
					desc.Transparency = 0
					desc.CanCollide = false
				end
			end
		end
	end)
	
	
	local gameStart = tick()
	
	while true do
		game:GetService("RunService").Heartbeat:Wait()
		
		local timeLeft = config.RoundTime - math.round((tick() - gameStart))
		local mins = math.floor(timeLeft / 60)
		local secs = timeLeft - (mins * 60)
		if string.len(secs) < 2 then
			secs = "0" .. tostring(secs)
		end
		statusValue.Value = mins .. ":" .. secs
		
		numPlrs = 0
		for i, plr in pairs(game.Players:GetPlayers()) do
			if plr then
				numPlrs += 1
			end
		end
		if numPlrs < config.MinimumPlayersRequired then
			break
			
		elseif config.StopOnceFlagsReached then
			if team1Score.Value >= config.FlagsRequiredToStop or team2Score.Value >= config.FlagsRequiredToStop then
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