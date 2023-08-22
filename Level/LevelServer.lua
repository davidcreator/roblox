local dss = game:GetService("DataStoreService")
local levelDS = dss:GetDataStore("Levels")


function incrementExp(player, increment)
	
	for i = player.Stats.Experience.Value, player.Stats.Experience.Value + increment do
		
		player.Stats.Experience.Value = i
		
		wait()
	end
end


function saveData(player)
	
	pcall(function()
		
		local level = player.Stats.Level.Value
		local exp = player.Stats.Experience.Value
		
		levelDS:SetAsync(player.UserId .. "Level", {level, exp})
	end)
end


game.Players.PlayerAdded:Connect(function(player)
	
	
	local statsFolder = Instance.new("Folder", player)
	statsFolder.Name = "Stats"
	
	local levelVal = Instance.new("IntValue", statsFolder)
	levelVal.Name = "Level"
	levelVal.Value = 1
	
	local expVal = Instance.new("IntValue", statsFolder)
	expVal.Name = "Experience"
	
	
	pcall(function()
		
		local data = levelDS:GetAsync(player.UserId .. "Level")
		
		if data then
			
			levelVal.Value = data[1]
			expVal.Value = data[2]
		end
	end)
	
	
	expVal:GetPropertyChangedSignal("Value"):Connect(function()
		
		local neededExp = math.floor(levelVal.Value ^ 1.5 + 0.5) * 500
		
		if expVal.Value >= neededExp then
			
			levelVal.Value += 1
		end
	end)
	
	
	while wait(0.2) do
		
		incrementExp(player, 100)
	end
end)


game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
	
	for i, player in pairs(game.Players:GetPlayers()) do
		
		saveData(player)
	end
end)