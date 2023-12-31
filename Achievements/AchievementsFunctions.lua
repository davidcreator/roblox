local functions = {}


local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("Achievements Data Store")

local remote = script.Parent:WaitForChild("AchievementsRemoteEvent")


function functions.LoadPlayerAchievements(plr:Player)
	if not game:GetService("RunService"):IsServer() then return end
	
	if plr.Parent == game.Players and not plr:FindFirstChild("ACHIEVEMENTS FOLDER") then
		
		local plrData
		local success, err
		
		while not success do
			success, err = pcall(function()
				plrData = ds:GetAsync(plr.UserId) or {}
			end)
			
			if not success then
				warn(err)
			end
			
			task.wait(0.5)
		end

		if success then
			local newFolder = Instance.new("Folder")
			newFolder.Name = "ACHIEVEMENTS FOLDER"
			newFolder.Parent = plr
			
			for _, achName in pairs(plrData) do
				local newAchievementValue = Instance.new("StringValue")
				newAchievementValue.Name = achName
				newAchievementValue.Parent = newFolder
			end
		end
	end
end

function functions.SavePlayerAchievements(plr:Player)
	if not game:GetService("RunService"):IsServer() then return end
	
	if plr.Parent == game.Players and plr:FindFirstChild("ACHIEVEMENTS FOLDER") then
		
		local plrAchievements = {}
		for _, achievementValue in pairs(plr["ACHIEVEMENTS FOLDER"]:GetChildren()) do
			table.insert(plrAchievements, achievementValue.Name)
		end
		
		local success, err

		while not success do
			success, err = pcall(function()
				return ds:SetAsync(plr.UserId, plrAchievements)
			end)

			task.wait(0.1)
		end
	end
end

function functions.AwardAchievement(plr:Player, achName:string)
	
	if not game:GetService("RunService"):IsServer() then return end

	if plr.Parent == game.Players and plr:FindFirstChild("ACHIEVEMENTS FOLDER") and not plr["ACHIEVEMENTS FOLDER"]:FindFirstChild(achName) then
		
		remote:FireClient(plr, "AWARD ACHIEVEMENT", achName)
		
		local newAchievementValue = Instance.new("StringValue")
		newAchievementValue.Name = achName
		newAchievementValue.Parent = plr["ACHIEVEMENTS FOLDER"]
	end
end


return functions