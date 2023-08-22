local enterId = script.Parent:WaitForChild("EnterId")
local enterColour = script.Parent:WaitForChild("EnterColour")

local removeHats = script.Parent:WaitForChild("RemoveHats")

local partColours = script.Parent:WaitForChild("PartColourSelector"):GetChildren()

local selectedPart = nil


for i, partColour in pairs(partColours) do
	
	partColour.MouseButton1Click:Connect(function()
		
		selectedPart = partColour.Name
	end)
end


enterColour.FocusLost:Connect(function(enterPressed)
	
	if enterPressed then
		
		local text = enterColour.Text
		local textNoSpaces = string.gsub(text, " ", "")
		
		local splitText = string.split(textNoSpaces, ",")
		
		local rgb = Color3.fromRGB(splitText[1], splitText[2], splitText[3])
		
		
		if selectedPart then
			
			game.ReplicatedStorage.OnColourChanged:FireServer(rgb, selectedPart)
		end
	end
end)


enterId.FocusLost:Connect(function(enterPressed)
	
	if enterPressed then
		
		local id = enterId.Text
		
		game.ReplicatedStorage.OnAssetInserted:FireServer(id)
	end
end)


removeHats.MouseButton1Click:Connect(function()
	
	game.ReplicatedStorage.OnHatsRemoved:FireServer()
end)