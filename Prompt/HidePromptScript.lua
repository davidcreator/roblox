game.ReplicatedStorage.PickpocketRE.OnClientEvent:Connect(function()
	
	script.Parent.HumanoidRootPart:WaitForChild("PickpocketPart"):WaitForChild("ProximityPrompt").Enabled = false
end)