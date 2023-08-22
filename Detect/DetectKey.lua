local uis = game:GetService("UserInputService")


local char = script.Parent


local equipRE = game.ReplicatedStorage:WaitForChild("NVGsToggled")


local defaultAmbient = game.Lighting.OutdoorAmbient



uis.InputBegan:Connect(function(input, processed)
	
	
	if processed then return end
	
	
	if input.KeyCode == Enum.KeyCode.E then
		
		
		if not char:FindFirstChild("NVGs") then
			
			equipRE:FireServer(true)
			
			
			game.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
			game.Lighting.ColorCorrection.Enabled = true
			
		else
			
			equipRE:FireServer(false)
			
			
			game.Lighting.OutdoorAmbient = defaultAmbient
			game.Lighting.ColorCorrection.Enabled = false
		end
	end
end)