game.Players.PlayerAdded:Connect(function(plr)
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = 0
	cash.Parent = ls
end)


local gun = script:WaitForChild("Gun")
local mobs = {[10] = script:WaitForChild("HardMob"), [5] = script:WaitForChild("MediumMob"), [1] = script:WaitForChild("EasyMob")}


local mobSpawns = workspace:WaitForChild("MobSpawns")


local statusValue = game.ReplicatedStorage:WaitForChild("StatusValue")


local respawnWave = 10

local startingMobs = 5

local maxWave = math.huge


while true do
	
	
	statusValue.Value = "Intermission"
	
	workspace:WaitForChild("MobsFolder"):ClearAllChildren()
	
	wait(5)
	
	
	local alivePlrs = {}
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		plr:LoadCharacter()
		
		table.insert(alivePlrs, plr)
		
		plr.Character.Humanoid.Died:Connect(function()
			table.remove(alivePlrs, alivePlrs[plr])
		end)
		
		gun:Clone().Parent = plr.Backpack
	end
	
	
	for i = 1, maxWave do
		
		local mobsToSpawn = (startingMobs / 2) * (2 ^ i)
		
		statusValue.Value = "Wave " .. i .. " starting."
		wait(3)
		
		
		local mobTypeSpawn
		for waveNum, mobType in pairs(mobs) do
			
			if i >= waveNum then
				
				mobTypeSpawn = mobType
				break
			end
		end
		
		
		while mobsToSpawn > 0 do
			
			for x, spawner in pairs(mobSpawns:GetChildren()) do
				
				mobsToSpawn = mobsToSpawn - 1
				
				local mobClone = mobTypeSpawn:Clone()
				mobClone.HumanoidRootPart.CFrame = spawner.CFrame + Vector3.new(0, 10, 0)
				
				mobClone.Parent = workspace:WaitForChild("MobsFolder")
			end
		end
		
		repeat
			wait()
			
			statusValue.Value = "Wave " .. i .. " | " .. #workspace:WaitForChild("MobsFolder"):GetChildren() .. "/" .. (startingMobs / 2) * (2 ^ i) .. " Zombies"
			
		until #workspace:WaitForChild("MobsFolder"):GetChildren() < 1 or #alivePlrs < 1
		
		if #alivePlrs < 1 then 
			break
			
		else
			
			for y, plrAlive in pairs(alivePlrs) do
				
				plrAlive.leaderstats.Cash.Value = plrAlive.leaderstats.Cash.Value + (20 * i)
			end
			
			if i % respawnWave == 0 then
				
				for z, plr in pairs(game.Players:GetPlayers()) do
					
					plr:LoadCharacter()
					gun:Clone().Parent = plr.Backpack
				end
			end
		end
	end
end