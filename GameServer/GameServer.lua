local re = game.ReplicatedStorage:WaitForChild("RemoteEvent")

local maps = game.ReplicatedStorage:WaitForChild("Maps"):GetChildren()


local gameLength = 120



while true do
	
	
	local chosenMap = maps[math.random(1, #maps)]:Clone()
	chosenMap.Parent = workspace
	
	re:FireAllClients("status", "Map chosen: " .. chosenMap.Name)
	
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		plr:LoadCharacter()
	end
	
	
	wait(3)
	
	
	local speedMultiplier = 1
	
	local plrsCompleted = {}
	
	chosenMap.Finish.Touched:Connect(function(hit)
		
		local player = game.Players:GetPlayerFromCharacter(hit.Parent)
		
		if player and not table.find(plrsCompleted, player) then
			
			table.insert(plrsCompleted, player)

			re:FireAllClients("chat", player.Name .. " has made it to the end.")
			
			re:FireClient(player, "finished", chosenMap.Finish)
			
			player.leaderstats.Money.Value += 300 / speedMultiplier
			
			speedMultiplier *= 2
		end
	end)
	
	
	for i, killPart in pairs(chosenMap.KillParts:GetChildren()) do
		
		killPart.Touched:Connect(function(hit)
			
			local player = game.Players:GetPlayerFromCharacter(hit.Parent)
			
			if player then
				
				player:LoadCharacter()
			end
		end)
	end
	
	
	for i = gameLength, 0, -1 do
		
		wait(1 / speedMultiplier)
		
		local timeMins = math.floor(i / 60)
		local timeSecs = i % 60
		
		if string.len(timeSecs) < 2 then timeSecs = "0" .. timeSecs end
		
		re:FireAllClients("status", timeMins .. ":" .. timeSecs)
		
		
		if #plrsCompleted == #game.Players:GetPlayers() then
			
			break
		end
	end
	
	chosenMap:Destroy()
end