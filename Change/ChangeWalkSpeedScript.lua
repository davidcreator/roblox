local toggleSprintEvent = game.ReplicatedStorage:WaitForChild("ToggleSprint")

toggleSprintEvent.OnServerEvent:Connect(function(plr, turnOnSprint)
	
	local char = plr.Character
	
	if not char:FindFirstChild("Humanoid") then return end
	
	if turnOnSprint == true then
		
		char:FindFirstChild("Humanoid").WalkSpeed = 50
		
	else
		
		char:FindFirstChild("Humanoid").WalkSpeed = 16
		
	end
	
end)