game.Players.PlayerAdded:connect(function(player)
	
	local leaderstats = Instance.new("Folder",player)
 	leaderstats.Name = "leaderstats"

 	local cash = Instance.new("IntValue",leaderstats)
 	cash.Name = "Cash"
	cash.Value = 0

	local kills = Instance.new("IntValue",leaderstats)
	kills.Name = "Kills"
	kills.Value = 0
	
 
	player.CharacterAdded:connect(function(character)
  		character:WaitForChild("Humanoid").Died:connect(function()
	
   			local CreatorTag = character.Humanoid:FindFirstChild("creator")

   			if CreatorTag and CreatorTag.Value then
	
     			local stats = CreatorTag.Value:WaitForChild("leaderstats")

				stats["Cash"].Value = stats["Cash"].Value + 20
				stats["Kills"].Value = stats["Kills"].Value + 1			
   			end
		end)
	end)
end)