local frame = script.Parent
frame.Draggable, frame.Active = true, true

local plrList = frame:WaitForChild("PlayerList")


local plrChosen = nil


function updatePlayers()
	
	for i, child in pairs(plrList:GetChildren()) do
		
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		local button = script.PlayerName:Clone()
		
		button.Text = plr.Name
		
		button.Parent = plrList
		
		
		if plrChosen == plr then
			button.BackgroundColor3 = Color3.fromRGB(213, 212, 202)
		end
		
		
		button.MouseButton1Click:Connect(function()
			
			plrChosen = plr
			
			for i, child in pairs(plrList:GetChildren()) do
				
				if child:IsA("TextButton") then child.BackgroundColor3 = Color3.fromRGB(252, 250, 239) end
			end
			
			button.BackgroundColor3 = Color3.fromRGB(213, 212, 202)
		end)
	end
end

updatePlayers()
game.Players.PlayerAdded:Connect(updatePlayers)
game.Players.PlayerRemoving:Connect(updatePlayers)



for i, child in pairs(frame:GetChildren()) do
	
	if child:IsA("TextButton") then
		
		
		child.MouseButton1Click:Connect(function()
			
			game.ReplicatedStorage.AdminClicked:FireServer(plrChosen, child.Name)
		end)
	end
end