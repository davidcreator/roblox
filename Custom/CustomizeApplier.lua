game.ReplicatedStorage.OnColourChanged.OnServerEvent:Connect(function(plr, rgb, selectedPart)
	
	
	local char = plr.Character
	local bc = char:WaitForChild("Body Colors")
	
	
	if selectedPart == "All" then

		bc.HeadColor3, bc.LeftArmColor3, bc.RightArmColor3, bc.TorsoColor3, bc.LeftLegColor3, bc.RightLegColor3 = rgb, rgb, rgb, rgb, rgb, rgb
		
		
	else
		bc[selectedPart] = rgb
	end
end)


game.ReplicatedStorage.OnAssetInserted.OnServerEvent:Connect(function(plr, id)
	
	local char = plr.Character
	
	pcall(function()

		local model = game:GetService("InsertService"):LoadAsset(id)
		
		for i, child in pairs(model:GetChildren()) do
			
			
			if child:IsA("Accessory") or child:IsA("ShirtGraphic") then
				
				child.Parent = char
				
				
			elseif child:IsA("Shirt") then 
				
				char.Shirt:Destroy()
				child.Parent = char
				
				
			elseif child:IsA("Pants") then
				
				char.Pants:Destroy()
				child.Parent = char
				
				
			elseif child:IsA("Decal") then
				
				char.Head.face:Destroy()
				child.Parent = char.Head
			end
		end
	end)
end)


game.ReplicatedStorage.OnHatsRemoved.OnServerEvent:Connect(function(plr)
	
	local char = plr.Character
	
	for i, child in pairs(char:GetChildren()) do
		
		if child:IsA("Accessory") then child:Destroy() end
	end
end)