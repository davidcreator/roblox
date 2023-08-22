local dss = game:GetService("DataStoreService")
local logDS = dss:GetDataStore("CombatLogData")



game.Players.PlayerAdded:Connect(function(plr)
	
	
	plr.CharacterAdded:Connect(function(char)
		
		
		local humanoid = char:WaitForChild("Humanoid")
		
		
		local data
		pcall(function()
			
			data = logDS:GetAsync(plr.UserId .. "-combat")
		end)
		
		
		if data then 
			
			humanoid.Health = data
			
			pcall(function()
				logDS:RemoveAsync(plr.UserId .. "-combat")
			end)
		end		
		
		
		local oldHealth = humanoid.Health
		
		
		humanoid.HealthChanged:Connect(function(newHealth)
			
			
			if plr:FindFirstChild("InCombat") then
				
				plr.InCombat.Value = newHealth
			end
			
			
			if newHealth < oldHealth then
				
				if plr:FindFirstChild("InCombat") then
					plr.InCombat:Destroy()
				end
				
				local value = Instance.new("NumberValue")
				value.Name = "InCombat"
				
				value.Parent = plr
				
				game:GetService("Debris"):AddItem(value, 5)
			end
			
			
			oldHealth = newHealth
		end)
	end)
end)


game.Players.PlayerRemoving:Connect(function(plr)
	
	if plr:FindFirstChild("InCombat") then
		
		
		pcall(function()
			
			logDS:SetAsync(plr.UserId .. "-combat", plr.InCombat.Value)
		end)
	end
end)