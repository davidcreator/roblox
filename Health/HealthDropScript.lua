local healthDropModel = script:WaitForChild("HealthDrop")

local healthGain = 60


game.Players.PlayerAdded:Connect(function(plr)
	
	plr.CharacterAdded:Connect(function(char)
		
		local humanoid = char:WaitForChild("Humanoid")
		
		humanoid.Died:Connect(function()
			
			local deathPos = char.HumanoidRootPart.Position
			
			wait(1)
			
			local newHealthModel = healthDropModel:Clone()
			newHealthModel.Position = deathPos
			newHealthModel.CanCollide = false
			newHealthModel.Anchored = true
			newHealthModel.Parent = workspace
			
			newHealthModel.Touched:Connect(function(hit)
				
				local humanoid = hit.Parent:FindFirstChild("Humanoid") or hit.Parent.Parent:FindFirstChild("Humanoid")
				
				if humanoid then
					
					newHealthModel:Destroy()
					
					humanoid.Health += healthGain
				end
			end)
		end)
	end)
end)