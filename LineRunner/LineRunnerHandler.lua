local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("HighScoreDS")


local container = Instance.new("Folder", workspace)
container.Name = "Obstacles"


game.Players.PlayerAdded:Connect(function(plr)
	
	
	local ls = Instance.new("Folder", plr)
	ls.Name = "leaderstats"
	
	
	local score = Instance.new("IntValue")
	score.Name = "Score"
	score.Parent = ls
	
	local hs = Instance.new("IntValue")
	hs.Name = "High Score"
	hs.Parent = ls
	
	
	coroutine.resume(coroutine.create(function()
		
		pcall(function()
			local data = ds:GetAsync(plr.UserId .. "-HighScore")
			hs.Value = data or 0
		end)
	end))
	
	
	plr.CharacterAdded:Connect(function(char)
		
		
		container:ClearAllChildren()
		
		
		local startZ = char.HumanoidRootPart.Position.Z
		local oldZ = startZ
		
		score.Value = 0
		
		
		local stages = 0
		
		
		game:GetService("RunService").Heartbeat:Connect(function()
			
			
			local newZ = char.HumanoidRootPart.Position.Z
			local ptsIncrease = (newZ - oldZ) * 10

			if ptsIncrease > 0 then score.Value += ptsIncrease end

			oldZ = newZ


			if score.Value > hs.Value then

				hs.Value = score.Value
			end
		end)
		
		
		while char.Humanoid.Health > 0 do
			
			
			if char.HumanoidRootPart.Velocity.Magnitude > 0 or not container:FindFirstChild("10") then
				
				stages += 1
				
				
				local newStage = script:GetChildren()[math.random(1, #script:GetChildren())]:Clone()
				newStage.Name = stages
				
				newStage.PrimaryPart = newStage.Start
				
				if stages > 1 then 
					newStage:SetPrimaryPartCFrame(container[stages - 1].End.CFrame)
				end
				
				newStage.Parent = container
				
				
				for i, child in pairs(newStage:GetChildren()) do
					
					
					if child.Name == "Kill" then
						
						
						for x, descendant in pairs(child:GetDescendants()) do
							
							
							if descendant:IsA("Part") then
								
								descendant.Touched:Connect(function(touched)
									
									
									if touched.Parent:FindFirstChild("Humanoid") then
										
										touched.Parent.Humanoid.Health = 0
									end
								end)
							end
						end
						
						
					elseif child.Name == "Coin" then
						
						
						local bav = Instance.new("BodyAngularVelocity", child)
						bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
						bav.AngularVelocity = Vector3.new(0, 10, 0)
						
						local bp = Instance.new("BodyPosition", child)
						bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						bp.Position = child.Position
						
						child.Anchored = false
						
						
						
						child.Touched:Connect(function(touched)
							
							if game.Players:GetPlayerFromCharacter(touched.Parent) and touched.Parent.Humanoid.Health > 0 then
								
								child:Destroy()
								
								score.Value = score.Value + 300
							end
						end)
						
						
					elseif child.Name == "End" or child.Name == "Start" then
						
						child.CanCollide = false
						child.Transparency = 1
					end		
				end
					
				
				coroutine.resume(coroutine.create(function()
					
					while wait() do
						
						local zTravelled = char.HumanoidRootPart.Position.Z - startZ
						local stageLength = newStage.End.Position.Z - newStage.Start.Position.Z
						
						if stageLength * tonumber(newStage.Name) < zTravelled then
						
							newStage:Destroy()
							break
						end
					end
				end))
			end
			
			wait(2)
		end
	end)
end)


game.Players.PlayerRemoving:Connect(function(plr)
	
	pcall(function()
		ds:SetAsync(plr.UserId .. "-HighScore", plr.leaderstats["High Score"].Value)
	end)
end)


game:BindToClose(function()
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		pcall(function()
			ds:SetAsync(plr.UserId .. "-HighScore", plr.leaderstats["High Score"].Value)
		end)
	end
end)