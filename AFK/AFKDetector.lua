local uis = game:GetService("UserInputService")


uis.WindowFocusReleased:Connect(function()
	
	game.ReplicatedStorage.IsAFK:FireServer(true)
end)


uis.WindowFocused:Connect(function()

	game.ReplicatedStorage.IsAFK:FireServer(false)
end)