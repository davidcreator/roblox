script.Parent:WaitForChild("Humanoid").Died:Connect(function()
	
	game.ReplicatedStorage.DiedRE:FireServer()
end)