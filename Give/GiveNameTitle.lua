game.Players.PlayerAdded:Connect(function(plr)
	
	
	plr.CharacterAdded:Connect(function(char)
		
		
		local nameGui = Instance.new("BillboardGui")
	
		nameGui.StudsOffset = Vector3.new(0, 2, 0)
		
		nameGui.Size = UDim2.new(0, 200, 0, 50)
		
		nameGui.Name = "NameGui"
		nameGui.Parent = char.Head
		
		
		local nameLabel = Instance.new("TextLabel")
		
		nameLabel.Text = plr.Name
		
		nameLabel.TextScaled = true
		
		nameLabel.Size = UDim2.new(0, 200, 0, 50)
		
		nameLabel.BackgroundTransparency = 1
		
		nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		
		nameLabel.Name = "NameLabel"
		nameLabel.Parent = nameGui
		
	end)
	
end)