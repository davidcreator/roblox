local hungerFolder = Instance.new("Folder")

hungerFolder.Name = "HungerFolder"
hungerFolder.Parent = game.ReplicatedStorage


game.Players.PlayerAdded:Connect(function(plr)
	
	local hungerValue = Instance.new("IntValue")
	
	hungerValue.Value = 100
	
	hungerValue.Name = plr.Name .. " Hunger"
	hungerValue.Parent = hungerFolder
	
	
	plr.CharacterAdded:Connect(function(char)
		
		local humanoid = char:WaitForChild("Humanoid")
		
		humanoid.Touched:Connect(function(partTouched)
			
			if partTouched:FindFirstChild("HungerAmount") then
				
				hungerValue.Value = math.clamp(hungerValue.Value + partTouched.HungerAmount.Value, 0, 100)
				
				partTouched:Destroy()
			end
		end)
		
		hungerValue:GetPropertyChangedSignal("Value"):Connect(function()
			
			if hungerValue.Value < 1 then
				
				humanoid.Health = 0
				
				hungerValue.Value = 100
			end
		end)
		
		while wait(1) do
			
			if humanoid:GetState() == Enum.HumanoidStateType.Dead then break end
			
			hungerValue.Value = math.clamp(hungerValue.Value - 1, 0, 100)
		end
	end)
end)