local re = game.ReplicatedStorage:WaitForChild("InventoryRE")

--Equip tool on client request
re.OnServerEvent:Connect(function(player, toolName)
	
	if player.Character and toolName then
		
		if player.Backpack:FindFirstChild(toolName) then
			player.Character.Humanoid:EquipTool(player.Backpack[toolName])
			
		elseif player.Character:FindFirstChild(toolName) then
			player.Character.Humanoid:UnequipTools()
		end
	end
end)