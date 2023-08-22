local dss = game:GetService("DataStoreService")
local questsDS = dss:GetDataStore("quests data")

local quests = { --["QUEST DESCRIPTION"] = {GOAL, CASH REWARD}
	["Play for 10 minutes"] = {10, 500},
	["Walk 500 studs"] = {500, 100},
	["Stand still for 10 seconds"] = {10, 50},
	["Jump 10 times"] = {10, 80},
}
local numQuests = 3 --Number of quests given daily


function saveData(plr)
	
	local cash = plr.leaderstats.Cash.Value
	
	local questsFolder = plr.Quests
	local lastRefresh = questsFolder.LastRefresh.Value
	local currentQuests = {}
	
	for i, child in pairs(questsFolder:GetChildren()) do
		if child:IsA("Folder") then
			
			local questDesc = child.Name
			local progress = child.Progress.Value
			local completed = child:FindFirstChild("Completed") and true
			
			currentQuests[questDesc] = {progress, completed}
		end
	end
	
	local dataList = {}
	dataList.cash = cash
	dataList.refresh = lastRefresh
	dataList.quests = currentQuests
	
	questsDS:SetAsync(plr.UserId, dataList)
end

game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for i, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)


game.Players.PlayerAdded:Connect(function(plr)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = leaderstats
	
	local questsFolder = Instance.new("Folder")
	questsFolder.Name = "Quests"
	questsFolder.Parent = plr
	
	
	plr.CharacterAdded:Connect(function(char)
		local currentQuests = {}
		repeat 
			currentQuests = questsFolder:GetChildren()
			task.wait()
		until #currentQuests == (numQuests + 1)
		
		for i, child in pairs(currentQuests) do
			if child:IsA("Folder") and not child:FindFirstChild("Completed") then
				
				if child.Name == "Walk 500 studs" then
					local lastPos = char.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
					
					task.spawn(function()
						while child.Progress.Value ~= child.Goal.Value do 
							local currentPos = char.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
							local distance = (lastPos - currentPos).Magnitude
							
							child.Progress.Value = math.clamp(child.Progress.Value + distance, 0, child.Goal.Value)

							lastPos = currentPos

							task.wait()
						end
						
						local completedValue = Instance.new("BoolValue")
						completedValue.Name = "Completed"
						completedValue.Parent = child
						
						cash.Value += quests[child.Name][2]
					end)
					
				elseif child.Name == "Jump 10 times" then
					char.Humanoid.Jumping:Connect(function(active)

						if active then
							child.Progress.Value = math.clamp(child.Progress.Value + 1, 0, child.Goal.Value)
						end

						if child.Progress.Value == child.Goal.Value and not child:FindFirstChild("Completed") then

							local completed = Instance.new("BoolValue")
							completed.Name = "Completed"
							completed.Parent = child
							
							cash.Value += quests[child.Name][2]
						end
					end)
					
				elseif child.Name == "Stand still for 10 seconds" then
					
					local startTime = os.time()
					
					task.spawn(function()
						while child.Progress.Value ~= child.Goal.Value do
							
							if char.Humanoid.MoveDirection.Magnitude > 0 then
								startTime = os.time()
							end
							
							local timeStill = os.time() - startTime
							child.Progress.Value = math.clamp(timeStill, 0, child.Goal.Value)

							task.wait()
						end

						local completed = Instance.new("BoolValue")
						completed.Name = "Completed"
						completed.Parent = child
						
						cash.Value += quests[child.Name][2]
					end)
				end
			end
		end
	end)
	
	
	local data = questsDS:GetAsync(plr.UserId)
	local cashData = 0
	local lastRefresh = os.time()
	local currentQuests = {}
	
	if data then
		cashData = data.cash
		lastRefresh = data.refresh
		currentQuests = data.quests
	end
	
	if not data or os.time() - lastRefresh >= (24*60*60) then

		currentQuests = {}
		lastRefresh = os.time()

		local questDescs = {}
		for desc, info in pairs(quests) do
			table.insert(questDescs, desc)
		end

		for i = 1, numQuests do

			local randomIndex = math.random(1, #questDescs)
			local randomQuest = questDescs[randomIndex]
			table.remove(questDescs, randomIndex)

			currentQuests[randomQuest] = {0, false}
		end
	end
	
	cash.Value = cashData
	
	local refreshValue = Instance.new("NumberValue")
	refreshValue.Name = "LastRefresh"
	refreshValue.Value = lastRefresh
	refreshValue.Parent = questsFolder
	
	for questDesc, info in pairs(currentQuests) do
		
		local questFolder = Instance.new("Folder")
		questFolder.Name = questDesc
		questFolder.Parent = questsFolder
		
		local progressValue = Instance.new("NumberValue")
		progressValue.Name = "Progress"
		progressValue.Value = info[1]
		progressValue.Parent = questFolder
		
		local goalValue = Instance.new("NumberValue")
		goalValue.Name = "Goal"
		goalValue.Value = quests[questDesc][1]
		goalValue.Parent = questFolder
		
		local rewardValue = Instance.new("NumberValue")
		rewardValue.Name = "Reward"
		rewardValue.Value = quests[questDesc][2]
		rewardValue.Parent = questFolder
		
		local completedValue
		if info[2] == true then
			completedValue = Instance.new("BoolValue")
			completedValue.Name = "Completed"
			completedValue.Parent = questFolder
		end
		
		if questDesc == "Play for 10 minutes" and not completedValue then
			local previous = os.time()
			
			task.spawn(function()
				while task.wait(1) do
					local now = os.time()
					local timeDiff = (now - previous) / 60
					
					progressValue.Value = math.clamp(progressValue.Value + timeDiff, 0, goalValue.Value)
					
					previous = now
					
					if progressValue.Value == 10 then
						break
					end
				end
				
				completedValue = Instance.new("BoolValue")
				completedValue.Name = "Completed"
				completedValue.Parent = questFolder
				
				cash.Value += quests[questDesc][2]
			end)
		end
	end
end)