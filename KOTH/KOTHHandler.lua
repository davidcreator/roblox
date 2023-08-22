local hill = script.Parent:WaitForChild("Hill")
local hitbox = script.Parent:WaitForChild("HillHitbox")

local plrsOnHill = {}

while wait(10) do
	
	for secsInGame = 30, 0, -1 do
		
		hitbox.Touched:Connect(function(touch)	
			local plr = game.Players:GetPlayerFromCharacter(touch.Parent)
			if plr and not plrsOnHill[plr] then		
				table.insert(plrsOnHill, plr)
			end
		end)
		
		hitbox.TouchEnded:Connect(function(touch)
			local plr = game.Players:GetPlayerFromCharacter(touch.Parent)
			if plr and plrsOnHill[plr] then	
				table.remove(plrsOnHill, plrsOnHill[plr])
			end
		end)
			
		for i, plrOnHill in pairs(plrsOnHill) do
			
			if not plrOnHill:FindFirstChild("HillPoints") then
				
				local hillPoints = Instance.new("IntValue")
				hillPoints.Name = "HillPoints"
				
				hillPoints.Parent = plrOnHill
				
			end
			plrOnHill.HillPoints.Value = plrOnHill.HillPoints.Value + 1
			
		end	
		wait(1)	
	end
	
	local winner	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		if plr:FindFirstChild("HillPoints") then
			
			
			if not winner then winner = plr end
			
			if plr.HillPoints.Value > winner.HillPoints.Value then winner = plr end
		end	
	end
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		if plr:FindFirstChild("HillPoints") then plr.HillPoints:Destroy() end
	end
	print(winner.Name .. " wins!")
end