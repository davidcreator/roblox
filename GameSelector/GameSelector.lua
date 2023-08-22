local Minigames = game:GetService("ServerStorage"):WaitForChild("Minigames"):GetChildren()

while true do
	
	wait(4)
	
	local minigame = Minigames[math.random(1,#Minigames)]:Clone()
	
	local spawns = minigame.Minigame.Spawns:GetChildren()
	
	minigame.Minigame.Parent = workspace
	
	local plrs = game:GetService("Players"):GetChildren()
	
	local plrsalive = {}
	
	for i,plr in pairs(plrs) do
		if plr.Character then
			plr.Character:FindFirstChild("HumanoidRootPart").CFrame = spawns[i].CFrame + Vector3.new(0,10,0)
			table.insert(plrsalive, plr)
			local tag = Instance.new("BoolValue", plr.Character)
			tag.Name = "Alive"
		end
	end
	
	
	if minigame.Name == "SpinnerMinigame" then
		for i = 1, 3000 do
			wait(0.01)
			workspace.Minigame:WaitForChild("Spinner").Orientation = Vector3.new(0, workspace.Minigame.Spinner.Orientation.Y + i/160, 0)
			
			workspace.Minigame.Lava.Touched:Connect(function(touch)
				if touch.Parent:FindFirstChild("Humanoid") then
					touch.Parent:FindFirstChild("Humanoid").Health = 0
					for i = 1,#plrsalive do
						if plrsalive[i].Name == touch.Parent.Name then
							table.remove(plrsalive, i)
						end
					end
				end
			end)
			
			
			workspace.Minigame.Spinner.Touched:Connect(function(touch)
				if touch.Parent:FindFirstChild("Humanoid") then
					touch.Parent:FindFirstChild("Humanoid").Health = 0
					for i = 1,#plrsalive do
						if plrsalive[i].Name == touch.Parent.Name then
							table.remove(plrsalive, i)
						end
					end
				end
			end)
			if #plrsalive == 0 then
				break
			end 
		end
	end
	
	
	workspace.Minigame:Destroy()
	
	local plrs = game:GetService("Players"):GetChildren()
	
	for i, plr in pairs(plrs) do
		plr:LoadCharacter()
	end
end