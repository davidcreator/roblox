local cooldowns = {}


game.Players.PlayerAdded:Connect(function(player)
	
	player.CharacterAdded:Connect(function(character)
		
		local m6d = Instance.new("Motor6D", character.RightHand)
		m6d.Part0 = character.RightHand
		m6d.Name = "ToolM6D"
	end)
end)


game.ReplicatedStorage.SwordRE.OnServerEvent:Connect(function(player, instruction, bodyAttach)
	
	if instruction == "connectm6d" then
		
		player.Character.RightHand.ToolM6D.Part1 = bodyAttach
		
	elseif instruction == "disconnectm6d" then
		
		player.Character.RightHand.ToolM6D.Part1 = nil
		
		
	elseif instruction == "attack" then
		
		if cooldowns[player] then return end
		
		cooldowns[player] = true
		
		
		game.ReplicatedStorage.SwordRE:FireAllClients(bodyAttach)
		
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {player.Character}
		
		local raycastResults = workspace:Raycast(player.Character.HumanoidRootPart.Position, player.Character.HumanoidRootPart.CFrame.LookVector * 3, raycastParams)
		
		if raycastResults and raycastResults.Instance.Parent:FindFirstChild("Humanoid") then
			
			raycastResults.Instance.Parent.Humanoid:TakeDamage(20)
		end
		
		wait(0.5)
		
		cooldowns[player] = false
	end
end)