game.Players.CharacterAutoLoads = false


local dss = game:GetService("DataStoreService")
local obbyDS = dss:GetDataStore("ObbyData")


local checkpoints = workspace:WaitForChild("Checkpoints")



game.Players.PlayerAdded:Connect(function(plr)
	
	local stageData
	pcall(function() 
		stageData = obbyDS:GetAsync("Stage-" .. plr.UserId) 
	end)
	
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr
	
	local stage = Instance.new("StringValue")
	stage.Name = "Stage"
	stage.Value = stageData or "1"
	stage.Parent = ls
	
	
	plr.CharacterAdded:Connect(function(char)
		
		local hrp = char:WaitForChild("HumanoidRootPart")
		
		hrp:GetPropertyChangedSignal("CFrame"):Wait()
		
		hrp.CFrame = checkpoints[stage.Value].CFrame
		
		
		char.Humanoid.Died:Connect(function()
			
			plr:LoadCharacter()
		end)
		
		
		char.Humanoid.Touched:Connect(function(part)
			
			if part.Parent == checkpoints then
				
				
				if part.Name ~= "End" and stage.Value ~= "End" then
					
					if tonumber(part.Name) > tonumber(stage.Value) then
						
						stage.Value = part.Name
					end
					
				elseif part.Name == "End" then
					stage.Value = part.Name
				end
			end
		end)
	end)
	
	
	plr:LoadCharacter()
end)


local function saveData(plr)
	
	pcall(function()
		obbyDS:SetAsync("Stage-" .. plr.UserId, plr.leaderstats.Stage.Value)
	end)
end


game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()
	
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		saveData(plr)
	end
end)
