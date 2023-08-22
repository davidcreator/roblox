local players = game:GetService("Players")

local length = 30

local PlrsAlive = {}

players.PlayerAdded:Connect(function(plr)
	plr:LoadCharacter()
end)


while true do
	
	repeat wait(1) until players.NumPlayers >= 2
	
	wait(5)
	
	local Maps = game:GetService("ServerStorage").Maps:GetChildren()
	
	local ChosenMap = Maps[math.random(1,#Maps)]
	
	map = ChosenMap:Clone()
	map.Parent = workspace
	
	
	local spawns = map:FindFirstChild("Spawns"):GetChildren()
	
	for i, player in pairs(players:GetChildren()) do
		if player.character then
			char = player.character
			
			char:FindFirstChild("HumanoidRootPart").CFrame = spawns[i].CFrame + Vector3.new(0,10,0)
			
			local tag = Instance.new("BoolValue",char)
			tag.Name = "PlayerAlive"
			
			table.insert(PlrsAlive, player)
		end  
	end

	for i, x in pairs(game:GetService("ServerStorage").Weapons:GetChildren()) do
		if x.ClassName == "Tool" then
			for i, player in pairs(players:GetChildren()) do
				x:Clone().Parent = player.Backpack
			end
		end
	end
	
	for i = 0, length do
		wait(1)
		for x, player in pairs(players:GetChildren()) do
			if player then 
				if player.Character then
					if not player.Character:FindFirstChild("PlayerAlive") then
						table.remove(PlrsAlive, x)
					end
				end
			else
				table.remove(PlrsAlive, x)
			end
		end
		if #PlrsAlive < 2 then break end		
	end
	
	
	for i, player in pairs(players:GetChildren()) do
		
		for i, tool in pairs(player.Backpack:GetChildren()) do
			tool:Destroy()
		end
		
		if player.Character:FindFirstChild("PlayerAlive") then
			player.Character:FindFirstChild("PlayerAlive"):Destroy()
		end
		player:LoadCharacter()
	end		
	map:Destroy()
end