--Save Data Variables
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("BattleRoyaleGame")

function saveData(plr)
	
	ds:SetAsync(plr.UserId .. "Wins", plr.leaderstats.Wins.Value)
end

--Other variables
local weapons = game.ServerStorage:WaitForChild("Weapons")
local workspaceWeapons = workspace:WaitForChild("Weapons")
local plane = game.ServerStorage:WaitForChild("Plane")
local planeStart = workspace:WaitForChild("PlaneStart")
local planeEnd = workspace:WaitForChild("PlaneEnd")
local weaponSpawn = workspace:WaitForChild("WeaponSpawnRange")
local remoteEvent = game.ReplicatedStorage:WaitForChild("BattleRoyaleRE")
local playersAlive = {}
local undroppedPlayers = {}


--When Player Joins
game.Players.PlayerAdded:Connect(function(plr)
	
	plr.CharacterAdded:Connect(function(char)
		
		char.HumanoidRootPart.Anchored = true
		
		char.Humanoid.Died:Connect(function() --Remove player from alive list when they die
			table.remove(playersAlive, table.find(playersAlive, plr))
		end)
	end)
	
	--Player stats
	local ls = Instance.new("Folder", plr)
	ls.Name = "leaderstats"
	
	local wins = Instance.new("IntValue")
	wins.Name = "Wins"
	wins.Parent = ls
	
	local winsData = ds:GetAsync(plr.UserId .. "Wins")
	
	wins.Value = winsData or 0
end)


--Save Data
game.Players.PlayerRemoving:Connect(saveData)
	
game:BindToClose(function()
	for i, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)


--Drop Player From Plane
function dropPlayer(plr)
	
	if table.find(undroppedPlayers, plr) and workspace:FindFirstChild("Plane") then
		
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {workspace.Plane}
		local rayResult = workspace:Raycast(workspace.Plane.PrimaryPart.Position, workspace.Plane.PrimaryPart.Position - Vector3.new(0, 100000, 0), rayParams)
		if rayResult and rayResult.Instance == weaponSpawn then
			
			table.remove(undroppedPlayers, table.find(undroppedPlayers, plr))
			
			remoteEvent:FireClient(plr, true)
			
			plr.Character.HumanoidRootPart.CFrame = workspace:WaitForChild("Plane").PrimaryPart.CFrame - Vector3.new(0, 30, 0)
			plr.Character.HumanoidRootPart.Anchored = false
		end
		
		if #undroppedPlayers < 1 then
			workspace:WaitForChild("Plane"):Destroy()
		end
	end
end

remoteEvent.OnServerEvent:Connect(dropPlayer)


--Game Loop
while true do
	--Reset Game
	workspaceWeapons:ClearAllChildren()
	table.clear(playersAlive)
	
	repeat wait() until #game.Players:GetPlayers() >= 2 --Wait for 2 players or more
	
	wait(1) --Intermission
	
	--Add Alive Players to List
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		local char = plr.Character
		
		if char and char:FindFirstChild("Humanoid") then
			table.insert(playersAlive, plr)
			
			remoteEvent:FireClient(plr, false)
		end
	end
	
	--Spawn Weapons Across Map
	local numWeapons = #playersAlive * math.random(10, 20)
	local weaponsList = weapons:GetChildren()
	
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {workspaceWeapons}
	
	for i = 1, numWeapons do
		
		spawn(function()
			local randomWeapon = weaponsList[math.random(1, #weaponsList)]:Clone()
			
			local x = math.random(weaponSpawn.Position.X - weaponSpawn.Size.X/2, weaponSpawn.Position.X + weaponSpawn.Size.X/2)
			local y = weaponSpawn.Position.Y + weaponSpawn.Size.Y/2
			local z = math.random(weaponSpawn.Position.Z - weaponSpawn.Size.Z/2, weaponSpawn.Position.Z + weaponSpawn.Size.Z/2)
				
			local randomPosition = Vector3.new(x, y, z)
			
			randomWeapon.Handle.CFrame = CFrame.new(randomPosition)
			randomWeapon.Parent = workspaceWeapons
			wait(2)
			randomWeapon.Handle.CFrame = CFrame.new(randomPosition)
		end)
	end
	
	wait(5) --Wait for weapons to spawn properly
	
	--Fly Plane Over Map
	local newPlane = plane:Clone()
	
	local planeStartCF = CFrame.new(planeStart.Position, planeEnd.Position)
	local planeEndCF = CFrame.new(planeEnd.Position, planeStartCF.LookVector * 100000000)
	
	newPlane:SetPrimaryPartCFrame(planeStartCF)
	newPlane.Parent = workspace
	
	--Copy alive list to dropped list
	for i, plr in pairs(playersAlive) do
		undroppedPlayers[i] = plr
	end
	
	spawn(function()
		for i = 1, 1000 do
			
			if workspace:FindFirstChild("Plane") and workspace.Plane.PrimaryPart then
				wait()
				newPlane:SetPrimaryPartCFrame(planeStartCF:Lerp(planeEndCF, i/1000))
				
				if i > 700 then
					for i, plr in pairs(undroppedPlayers) do
						dropPlayer(plr)
					end
				end
			end
		end
		newPlane:Destroy()
	end)
	
	--Round Start
	while #playersAlive > 1 do
		wait(1)
	end
	if workspace:FindFirstChild("Plane") then workspace.Plane:Destroy() end --Remove existing planes
	
	--Reward Winner
	if #playersAlive == 1 then
		playersAlive[1].leaderstats.Wins.Value += 1
		wait(1)
		playersAlive[1].Character.Humanoid.Health = 0
	end
end