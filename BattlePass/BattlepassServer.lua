local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("BattlepassDataStore")

local missions = {
	"Play for 10 minutes",
	"Walk for 500 studs",
	"Jump 10 times",
	"Stand still for 10 seconds",
}

local tiers = 30

--Data saving function
function saveData(plr)
	
	local cash = plr.leaderstats.Cash.Value
	
	ds:SetAsync(plr.UserId .. "Cash", cash)
	
	local tier = plr.Tier.Value
	local lastMission = plr.LastMission.Value
	local currentMissions = {}
	
	for i, mission in pairs(plr.Missions:GetChildren()) do
		
		currentMissions[mission.Name] = mission.Value
		if mission:FindFirstChild("Completed") then
			currentMissions[mission.Name] = -1
		end
	end
	
	local bpData = {["CurrentMissions"] = currentMissions, ["LastMission"] = lastMission, ["Tier"] = tier}
	
	ds:SetAsync(plr.UserId .. "Battlepass", bpData)
end


game.Players.PlayerAdded:Connect(function(plr)
	
	--Character related missions
	plr.CharacterAdded:Connect(function(char)
		
		local missionsFolder = plr:WaitForChild("Missions")
		
		for i, mission in pairs(missionsFolder:GetChildren()) do
			
			if not mission:FindFirstChild("Completed") then
				if mission.Name == "Walk for 500 studs" then --Walk for 500 studs
					
					spawn(function()
						local lastPosition = char.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
						
						while wait() do	
							if not mission:FindFirstChild("Completed") then
								local currentPos = char.HumanoidRootPart.Position * Vector3.new(1, 0, 1)
								
								mission.Value += (lastPosition - currentPos).Magnitude
								
								lastPosition = currentPos
								
								if mission.Value >= 500 then
									
									local complete = Instance.new("StringValue", mission)
									complete.Name = "Completed"
									plr.Tier.Value += 1
									break
								end
							end
						end
					end)
					
					
				elseif mission.Name == "Jump 10 times" then --Jump 10 times
					
					char.Humanoid.Jumping:Connect(function(active)
						
						if not mission:FindFirstChild("Completed") then
							if active then
								
								mission.Value += 1
							end
							
							if mission.Value >= 10 then
								
								local complete = Instance.new("StringValue", mission)
								complete.Name = "Completed"
								plr.Tier.Value += 1
							end
						end
					end)
					
					
				elseif mission.Name == "Stand still for 10 seconds" then --Stand still for 10 seconds
					
					spawn(function()
						local startTime = os.time()
						
						while wait() do
							
							if char.Humanoid.MoveDirection.Magnitude > 0 then
								
								startTime = os.time()
								
							else
								
								if os.time() - startTime >= 10 then
									mission.Value = 10
									break
								end
							end
							
							mission.Value = os.time() - startTime
						end
						
						local complete = Instance.new("StringValue", mission)
						complete.Name = "Completed"
						plr.Tier.Value += 1
					end)
				end
			end
		end
	end)
	
	--Leaderboard values
	local ls = Instance.new("Folder", plr)
	ls.Name = "leaderstats"
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = ls
	
	
	local cashData = ds:GetAsync(plr.UserId .. "Cash")
	
	cash.Value = cashData or 0
	
	--Battlepass data
	local bpData = ds:GetAsync(plr.UserId .. "Battlepass") or {["CurrentMissions"] = nil, ["LastMission"] = 0, ["Tier"] = 0}
	
	local currentMissions = bpData["CurrentMissions"]
	
	local tier = bpData["Tier"]
	
	local lastMission = bpData["LastMission"]
	
	if os.time() - lastMission >= 24*60*60 then--24*60*60 then --Reset missions after 24 hours
		
		lastMission = os.time()
		
		currentMissions = {}
		
		for i = 1, math.clamp(tiers - tier, 0, 3) do --Make sure the user doesn't complete more tiers than there are
			
			local mission
			repeat
				mission = missions[math.random(#missions)]
			until not currentMissions[mission]
			
			currentMissions[mission] = 0
		end
	end
	
	local lastValue = Instance.new("IntValue", plr)
	lastValue.Name = "LastMission"
	lastValue.Value = lastMission
	
	local tierValue = Instance.new("IntValue", plr) --Current tier
	tierValue.Name = "Tier"
	tierValue.Value = tier
	
	tierValue:GetPropertyChangedSignal("Value"):Connect(function() --Reward for tiers
		
		cash.Value += tierValue.Value * 100
	end)
	
	local missionsFolder = Instance.new("Folder", plr) --Missions stored in here
	missionsFolder.Name = "Missions"
	
	for currentMission, progress in pairs(currentMissions) do
		
		local missionValue = Instance.new("NumberValue", missionsFolder)
		missionValue.Name = currentMission
		
		missionValue.Value = progress
		
		if progress >= 0 then
			--Play for 10 minutes
			if currentMission == "Play for 10 minutes" then
				spawn(function()
					local timeJoined = os.time()
					
					while wait() do

						local timePlayed = progress + math.floor((os.time() - timeJoined)/60)

						if plr and timePlayed < 10 then

							plr.Missions["Play for 10 minutes"].Value = timePlayed
							
						else
							plr.Missions["Play for 10 minutes"].Value = 10
							break
						end
					end
					
					if plr then
						
						tierValue += 1
						local complete = Instance.new("StringValue", missionValue)
						complete.Name = "Completed"
					end
				end)
			end
			
		else
			local complete = Instance.new("StringValue", missionValue)
			complete.Name = "Completed"
			missionValue.Value = string.gsub(currentMission, "%D", "")
		end
	end
end)

--Save data using function
game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
	for i, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)