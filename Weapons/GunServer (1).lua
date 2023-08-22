game.Players.PlayerAdded:Connect(function(plr)			
	plr.CharacterAdded:Connect(function(char)
				
		local M6D = Instance.new("Motor6D")
		M6D.Name = "ToolGrip"
		M6D.Parent = char.HumanoidRootPart
    end)
end)

game.ReplicatedStorage.ConnectM6D.OnServerEvent:Connect(function(plr, location)

      local char = plr.Character
      char.HumanoidRootPart.ToolGrip.Part0 = char.HumanoidRootPart
      char.HumanoidRootPart.ToolGrip.Part1 = location
end)

game.ReplicatedStorage.DisconnectM6D.OnServerEvent:Connect(function(plr)
	
    plr.Character.HumanoidRootPart.ToolGrip.Part1 = nil
end)