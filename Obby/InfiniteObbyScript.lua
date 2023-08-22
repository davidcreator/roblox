local spawns = workspace:WaitForChild("Spawns")


local dss = game:GetService("DataStoreService")
local obbyDS = dss:GetDataStore("StagesDS")


function saveData(plr)
	
	pcall(function()
		obbyDS:SetAsync(plr.UserId, plr.leaderstats.Stages.Value)
	end)
end


game.Players.PlayerAdded:Connect(function(plr)
	
	local freeSpawn
	
	for i, child in pairs(spawns:GetChildren()) do
		
		if not child:FindFirstChildOfClass("StringValue") then
			
			freeSpawn = child
			
			local value = Instance.new("StringValue", child)
			value.Name = plr.Name
		end
	end
	
	plr.CharacterAdded:Connect(function(char)
		
		char.HumanoidRootPart:GetPropertyChangedSignal("CFrame"):Wait()
		char.HumanoidRootPart.CFrame = freeSpawn.CFrame + Vector3.new(0, 10, 0)
	end)
	
	
	local leaderstats = Instance.new("Folder", plr)
	leaderstats.Name = "leaderstats"
	
	local stagesValue = Instance.new("IntValue")
	stagesValue.Name = "Stages"
	stagesValue.Parent = leaderstats
	
	local data
	
	pcall(function()
		data = obbyDS:GetAsync(plr.UserId)
	end)
	stagesValue.Value = data or 0
	
	
	local stagesList = game.ServerStorage:WaitForChild("Stages"):GetChildren()
	
	while wait() do
		
		local randomStage = stagesList[math.random(#stagesList)]:Clone()
		
		for i, descendant in pairs(randomStage:GetDescendants()) do
			
			if descendant:IsA("BasePart") and descendant.Color == Color3.fromRGB(196, 40, 28) then
				
				local debounce = false
				
				descendant.Touched:Connect(function(hit)
					
					if game.Players:GetPlayerFromCharacter(hit.Parent) and not debounce then
						debounce = true
						game.Players:GetPlayerFromCharacter(hit.Parent):LoadCharacter()
						wait(0.1)
						debounce = false
					end
				end)
			end
			
			if descendant:IsA("BasePart") and descendant.Name == "Spinner" then
				
				spawn(function()
					while wait() do
						descendant.Orientation = descendant.Orientation + Vector3.new(0, 7, 0)
					end
				end)
			end
		end
		
		randomStage:SetPrimaryPartCFrame(freeSpawn.CFrame + (freeSpawn.CFrame.LookVector * (randomStage.PrimaryPart.Size.Z / 2 + freeSpawn.Size.Z / 2)))
		randomStage.Parent = freeSpawn
		
		randomStage.End.Touched:Wait()
		
		freeSpawn:ClearAllChildren()
		
		plr:LoadCharacter()
		
		stagesValue.Value += 1
	end
end)



game.Players.PlayerRemoving:Connect(function(plr)
	
	local takenSpawn
	
	for i, child in pairs(spawns:GetChildren()) do
		
		if child:FindFirstChild(plr.Name) then
			
			child:ClearAllChildren()
		end
	end
	
	saveData(plr)
end)

game:BindToClose(function()
	for i, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)