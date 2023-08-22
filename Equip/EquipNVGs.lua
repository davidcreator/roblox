game.ReplicatedStorage.NVGsToggled.OnServerEvent:Connect(function(plr, equipping)
	
	
	local char = plr.Character
	local humanoid = char:WaitForChild("Humanoid")
	
	
	if equipping then
		
		humanoid:AddAccessory(script.NVGs:Clone())
		
		
	else
		
		char.NVGs:Destroy()
	end
end)