local infectedSpawn = script.Parent.Spawns:WaitForChild("InfectedSpawn")


local roundTime = 30

local statusValue = game.ReplicatedStorage:WaitForChild("GameStatus")


game.Players.PlayerAdded:Connect(function(plrJoined)
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plrJoined
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = ls
end)


local gameActive = false
local survivors = {}


function handleInfected(plr)
	
	local c = plr.Character
	
	c.HumanoidRootPart.CFrame = infectedSpawn.CFrame + Vector3.new(0, 10, 0)

	c["Body Colors"].HeadColor3, c["Body Colors"].LeftArmColor3, c["Body Colors"].RightArmColor3, c["Body Colors"].TorsoColor3, c["Body Colors"].RightLegColor3, c["Body Colors"].LeftLegColor3 = Color3.fromRGB(21, 255, 75),Color3.fromRGB(21, 255, 75),Color3.fromRGB(21, 255, 75),Color3.fromRGB(21, 255, 75),Color3.fromRGB(21, 255, 75),Color3.fromRGB(21, 255, 75)


	c.Humanoid.Touched:Connect(function(part)

		local hitPlr = game.Players:GetPlayerFromCharacter(part.Parent)

		if hitPlr and table.find(survivors, hitPlr) and gameActive then

			table.remove(survivors, table.find(survivors, hitPlr))

			hitPlr:LoadCharacter()
			hitPlr.Character.HumanoidRootPart.CFrame = infectedSpawn.CFrame + Vector3.new(0, 10, 0)
			
			
			handleInfected(hitPlr)
		end
	end)
	
	
	c.Humanoid.Died:Connect(function()

		plr:LoadCharacter()
		handleInfected(plr)
	end)
end



while true do
	
	statusValue.Value = ""
	
	repeat wait() until #game.Players:GetPlayers() > 1
	local plrs = game.Players:GetPlayers()
	
	
	local spawns = script.Parent:WaitForChild("Spawns"):GetChildren()
	table.remove(spawns, table.find(spawns, infectedSpawn))
	
	
	local infected = plrs[math.random(1, #plrs)]
	
	for i, plr in pairs(plrs) do
		
		plr:LoadCharacter()
		local c = plr.Character
		
		if plr == infected then			
			
			handleInfected(plr)
			
		else
			
			local chosenSpawn = spawns[math.random(1, #spawns)]
			table.remove(spawns, table.find(spawns, chosenSpawn))
			
			c.HumanoidRootPart.CFrame = chosenSpawn.CFrame + Vector3.new(0, 10, 0)
			
			table.insert(survivors, plr)
			
			c.Humanoid.Died:Connect(function()
				
				plr:LoadCharacter()
				handleInfected(plr)
			end)
		end
	end
	
	
	gameActive = true
	for i = roundTime, 0, -1 do
		
		wait(1)
		
		if #survivors < 1 or not infected then break end
		
		
		statusValue.Value = i .. "s | " .. #survivors .. " survivors"
	end
	
	
	local winMsg = ""
	
	if #survivors < 1 then
		
		infected.leaderstats.Cash.Value += 100
		winMsg = "Infected wins!"
		
	else
		
		for i, survivor in pairs(survivors) do
			
			survivor.leaderstats.Cash.Value += 20
		end
		winMsg = "Survivors win!"
	end
	
	statusValue.Value = winMsg
	gameActive = false
	survivors = {}
	wait(5)
end