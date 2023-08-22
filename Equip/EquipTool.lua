game.ReplicatedStorage.EquipToolRE.OnServerEvent:Connect(function(plr, tool, parent)
	
	local char = plr.Character
	
	if char then
		
		if parent ~= char then

			char.Humanoid:UnequipTools()
			char.Humanoid:EquipTool(tool)
			
			
		else
			
			tool.Parent = plr.Backpack
		end
		
		game.ReplicatedStorage.EquipToolRE:FireClient(plr)
	end
end)