local uis = game:GetService("UserInputService")

local toggleSprintEvent = game.ReplicatedStorage:WaitForChild("ToggleSprint")


uis.InputBegan:Connect(function(key, processed)
	
	if processed then return end
	
	if key.KeyCode == Enum.KeyCode.LeftControl then
		
		toggleSprintEvent:FireServer(true)
		
	end
	
end)


uis.InputEnded:Connect(function(key, processed)
	
	if processed then return end
	
	if key.KeyCode == Enum.KeyCode.LeftControl then
		
		toggleSprintEvent:FireServer(false)
		
	end
	
end)