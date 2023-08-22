local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local SaveDataStore = DataStoreService:GetDataStore("SaveData")


local function SavePlayerData(player)
	
	local success, errormsg = pcall(function()
	
		local SaveData = {}
		
		for i, stats in pairs(player.leaderstats:GetChildren()) do
			
			SaveData[stats.Name] = stats.Value
		end	
		SaveDataStore:SetAsync(player.UserId, SaveData)
	end)
	
	if not success then 
		return errormsg
	end			
end	


Players.PlayerAdded:Connect(function(player)
	
	local Stats = Instance.new("Folder")
	Stats.Name = "leaderstats"
	Stats.Parent = player
	
	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = 0
	level.Parent = Stats
	
	local experience = Instance.new("IntValue")
	experience.Name = "Total XP"
	experience.Value = 0
	experience.Parent = Stats
	

	local Data = SaveDataStore:GetAsync(player.UserId)
	
	if Data then
		
		for i, stats in pairs(Stats:GetChildren()) do
			
			stats.Value = Data[stats.Name]
		end		
			
	else		
		print(player.Name .. " has no data.")			
	end
			
	
	local expToLevelUp
		
	local expForPreviousLevel = 0
	
	
	while wait() do
		
		local levelBar = player.PlayerGui:WaitForChild("LevelBar")	
		
		if level.Value < 1 then 
			
			expToLevelUp = 100 
			
		else
			
			expToLevelUp = math.floor(level.Value ^ 1.3) * 200 + math.floor(level.Value ^ 4)
		end
		
		
		if experience.Value >= expToLevelUp then
			
			level.Value = level.Value + 1	
		end
		
		expForPreviousLevel = math.floor((level.Value - 1) ^ 1.3) * 200 + math.floor((level.Value - 1) ^ 4)
		
		
		local expDifference = expToLevelUp - expForPreviousLevel

		local expDifference2 = experience.Value - expForPreviousLevel
			
		
		levelBar.Bar:TweenSize(
			UDim2.new(levelBar.BarBackground.Size.X.Scale * (expDifference2 / expDifference), 0, levelBar.BarBackground.Size.Y.Scale, 0), 
			Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.001
		)
		
		levelBar.Experience.Text = expDifference2 .. "/" .. expDifference
		
		levelBar.Level.Text = "Level: " .. level.Value
		
		
		experience.Value = experience.Value + 1
	end			
end)


Players.PlayerRemoving:Connect(function(player)
	
	local errormsg = SavePlayerData(player)
	
	if errormsg then	
		warn(errormsg)		
	end	
end)

game:BindToClose(function()
	for i, player in pairs(Players:GetPlayers()) do	
		
		local errormsg = SavePlayerData(player)
		if errormsg then
			warn(errormsg)
		end			
	end
	wait(2)	
end)