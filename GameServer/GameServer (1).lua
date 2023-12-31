local dss = game:GetService("DataStoreService")
local cashDS = dss:GetDataStore("CASH DATA")

local rs = game.ReplicatedStorage:WaitForChild("MurderMysteryReplicatedStorage")
local config = require(rs:WaitForChild("CONFIGURATION"))
local re = rs:WaitForChild("RemoteEvent")
local maps = rs:WaitForChild("Maps")
local weapons = rs:WaitForChild("Weapons")

local status = Instance.new("StringValue")
status.Name = "STATUS"
status.Parent = rs

local alivePlayers = {}
local sheriffs = {}
local murderers = {}

local sheriffWeaponCooldown = {}
local murdererWeaponCooldown = {}


function saveData(plr)
	
	if not plr:FindFirstChild("FAILED TO LOAD DATA") then
		
		local cash = plr.leaderstats.Cash.Value
		
		local success, err
		while not success do
			warn(err)
			
			success, err = pcall(function()
				cashDS:SetAsync(plr.UserId .. "Cash", cash)
			end)
			task.wait(1)
		end
	end
end

game.Players.PlayerRemoving:Connect(function(plr)
	task.spawn(saveData, plr)
	
	if table.find(alivePlayers, plr) then
		table.remove(alivePlayers, table.find(alivePlayers, plr))
	elseif table.find(murderers, plr) then
		table.remove(murderers, table.find(murderers, plr))
	elseif table.find(sheriffs, plr) then
		table.remove(sheriffs, table.find(sheriffs, plr))
	end
end)

game:BindToClose(function()
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)


game.Players.PlayerAdded:Connect(function(plr)
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = ls
	
	local success, cashData = pcall(function() 
		return cashDS:GetAsync(plr.UserId .. "Cash")
	end)
	
	if success then
		cash.Value = cashData or 0
		print("Data successfully loaded for " .. plr.Name)
		
	else
		warn("Data not loaded for " .. plr.Name)
		
		local failedToLoad = Instance.new("StringValue")
		failedToLoad.Name = "FAILED TO LOAD DATA"
		failedToLoad.Parent = plr
		
		re:FireClient(plr, "FAILED TO LOAD DATA")
	end
end)


re.OnServerEvent:Connect(function(plr, instruction, tool, camCF, mouseCF)
	
	local char = plr.Character
	if char and char.Humanoid.Health > 0 then

		if instruction == "SHERIFF SHOOT" then

			if table.find(sheriffs, plr) and not sheriffWeaponCooldown[plr] and tool.Parent == char then
				sheriffWeaponCooldown[plr] = true

				tool.Handle.ShootSound:Play()

				local rayParams = RaycastParams.new()
				rayParams.FilterType = Enum.RaycastFilterType.Blacklist
				rayParams.FilterDescendantsInstances = {char}
				
				local cframe = CFrame.new(camCF.Position, mouseCF.Position)
				local ray = workspace:Raycast(camCF.Position, cframe.LookVector * config.RaycastDepth, rayParams)

				if ray then
					local secondRay = workspace:Raycast(char.HumanoidRootPart.Position, ray.Position, rayParams)
					
					if secondRay.Instance ~= ray.Instance and secondRay.Instance.Parent ~= ray.Instance.Parent and secondRay.Instance.Parent.Parent ~= ray.Instance.Parent.Parent then
						ray = secondRay
					end
				end

				local beamContainer = Instance.new("Part")
				beamContainer.Name = "BEAM CONTAINER"
				beamContainer.CanCollide = false
				beamContainer.Transparency = 1
				beamContainer.Anchored = true
				beamContainer.Parent = workspace

				local tracer = Instance.new("Beam")
				tracer.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 160, 40)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 40))}
				tracer.FaceCamera = true
				tracer.LightEmission = 5
				
				local atch0, atch1 = Instance.new("Attachment"), Instance.new("Attachment")
				atch0.Name, atch0.Name = "A0", "A1"
				atch0.Parent, atch1.Parent = beamContainer, beamContainer
				atch0.WorldPosition, atch1.WorldPosition = tool.Handle.Position, ray and ray.Position or mouseCF.LookVector * config.RaycastDepth
				tracer.Attachment0, tracer.Attachment1 = atch0, atch1
				tracer.Width0, tracer.Width1 = 0.1, 0.1
				
				tracer.Parent = beamContainer
				game:GetService("Debris"):AddItem(beamContainer, 0.06)
				
				local hitHumanoid = nil
				if ray then
					hitHumanoid = ray.Instance.Parent:FindFirstChild("Humanoid") or ray.Instance.Parent.Parent:FindFirstChild("Humanoid")
				end
				
				if hitHumanoid and hitHumanoid.Parent ~= char then

					local targetPlr = game.Players:GetPlayerFromCharacter(hitHumanoid.Parent)
					if targetPlr then

						hitHumanoid.Health = 0

						if (table.find(alivePlayers, targetPlr) or table.find(sheriffs, targetPlr)) and not table.find(murderers, targetPlr) then
							char.Humanoid.Health = 0
						end
					end
				end

				task.wait(config.SheriffWeaponCooldown)
				sheriffWeaponCooldown[plr] = false
			end


		elseif instruction == "MURDERER STAB" then

			if table.find(murderers, plr) and not murdererWeaponCooldown[plr] and tool.Parent == char then
				murdererWeaponCooldown[plr] = true
				
				tool.Handle.SwingSound:Play()

				local rayParams = RaycastParams.new()
				rayParams.FilterType = Enum.RaycastFilterType.Blacklist
				rayParams.FilterDescendantsInstances = {char}

				local ray = workspace:Raycast(char.HumanoidRootPart.Position, char.HumanoidRootPart.CFrame.LookVector * config.MurdererWeaponStabRange)

				if ray and ray.Instance.Parent:FindFirstChild("Humanoid") then

					local targetPlr = game.Players:GetPlayerFromCharacter(ray.Instance.Parent)
					if table.find(alivePlayers, targetPlr) or table.find(sheriffs, targetPlr) then

						ray.Instance.Parent.Humanoid.Health = 0

						tool.Handle.KillSound:Play()
					end
				end

				task.wait(config.MurdererWeaponCooldown)
				murdererWeaponCooldown[plr] = false
			end


		elseif instruction == "MURDERER THROW" then

			if table.find(murderers, plr) and not murdererWeaponCooldown[plr] and tool.Parent == char then
				murdererWeaponCooldown[plr] = true

				local knifeClone = tool.Handle:Clone()
				
				local cframe = CFrame.new(camCF.Position, mouseCF.Position)

				re:FireAllClients("DUMMY KNIFE", tool, cframe.LookVector * config.MurdererWeaponThrowVelocity)
				
				knifeClone.Velocity = cframe.LookVector * config.MurdererWeaponThrowVelocity
				
				tool.Handle.Transparency = 1
				knifeClone.Transparency = 1
				
				tool.Handle.ThrowSound:Play()
				
				knifeClone.Parent = workspace

				knifeClone.CFrame = CFrame.new(tool.Handle.Position, cframe.LookVector * config.MurdererWeaponThrowVelocity)
				
				
				knifeClone.Touched:Connect(function(hit)
					if hit.Parent ~= tool.Parent and hit.Parent.Parent ~= tool.Parent then	

						local humanoid = hit.Parent:FindFirstChild("Humanoid")

						if humanoid then
							humanoid.Health = 0
							
							knifeClone.KillSound:Play()
							
							knifeClone.Transparency = 1
							knifeClone.KillSound.Ended:Wait()
						end
						
						knifeClone:Destroy()
					end
				end)

				task.wait(config.MurdererWeaponCooldown)
				murdererWeaponCooldown[plr] = false

				tool.Handle.Transparency = 0
			end
		end
	end
end)


while true do
	
	while #game.Players:GetPlayers() < config.MinPlayersToStart do
		status.Value = "Need " .. config.MinPlayersToStart .. " players to start"
		
		task.wait(0.5) 	
	end 
	
	for i = config.IntermissionTime, 0, -1 do
		status.Value = "Starting in " .. i .. "s"
		task.wait(1)
	end
	
	
	local chosenMap = maps:GetChildren()[Random.new():NextInteger(1, #maps:GetChildren())]:Clone()
	chosenMap.Parent = workspace
	
	status.Value = "Map chosen: " .. chosenMap.Name
	
	task.wait(config.TimeBetweenMapAndSpawn)
	
	
	if #game.Players:GetPlayers() >= config.MinPlayersToStart then
		alivePlayers = {}
		
		for i, plr in pairs(game.Players:GetPlayers()) do
			
			local char = plr.Character
			
			if char and char.Humanoid.Health > 0 then
				table.insert(alivePlayers, plr)
			end
		end
		
		
		murderers = {}
		
		for i = 1, config.Murderers do
			
			local chosenMurderer = nil
			while not chosenMurderer or table.find(murderers, chosenMurderer) do
				chosenMurderer = alivePlayers[Random.new():NextInteger(1, #alivePlayers)]
			end
			table.insert(murderers, chosenMurderer)
			table.remove(alivePlayers, table.find(alivePlayers, chosenMurderer))
		end
		
		sheriffs = {}
		
		for i = 1, config.Sheriffs do

			local chosenSheriff = nil
			while not chosenSheriff or table.find(sheriffs, chosenSheriff) do
				chosenSheriff = alivePlayers[Random.new():NextInteger(1, #alivePlayers)]
			end
			table.insert(sheriffs, chosenSheriff)
			table.remove(alivePlayers, table.find(alivePlayers, chosenSheriff))
		end
		
		
		for i, plr in pairs(game.Players:GetPlayers()) do
			
			local role = table.find(alivePlayers, plr) and "INNOCENT" or table.find(murderers, plr) and "MURDERER" or table.find(sheriffs, plr) and "SHERIFF"
			
			if role then
				re:FireClient(plr, "ROLE CHOSEN", role)
				
				local char = plr.Character
				
				char.Humanoid.Died:Connect(function()
					
					role = table.find(alivePlayers, plr) and "INNOCENT" or table.find(murderers, plr) and "MURDERER" or table.find(sheriffs, plr) and "SHERIFF"
					
					if role == "INNOCENT" then
						table.remove(alivePlayers, table.find(alivePlayers, plr))
					elseif role == "MURDERER" then
						table.remove(murderers, table.find(alivePlayers, plr))
					elseif role == "SHERIFF" then
						table.remove(sheriffs, table.find(alivePlayers, plr))
						
						local sheriffWeapon = plr.Backpack:FindFirstChild("Sheriff") or char:FindFirstChild("Sheriff")
						sheriffWeapon.Enabled = false
						sheriffWeapon.Handle.CFrame = char.HumanoidRootPart.CFrame
						sheriffWeapon.Handle.Anchored = true
						sheriffWeapon.Parent = workspace
					end
				end)
				
				
				local randomSpawn = chosenMap.Spawns:GetChildren()[Random.new():NextInteger(1, #chosenMap.Spawns:GetChildren())]
				
				local hrp = char.HumanoidRootPart
				hrp.CFrame = randomSpawn.CFrame
				
				randomSpawn:Destroy()
			end
		end
		
		task.wait(config.TimeBeforeReceivingWeapons)
		
		for i, murderer in pairs(murderers) do
			weapons.Murderer:Clone().Parent = murderer.Backpack
		end
		for i, sheriff in pairs(sheriffs) do
			local sheriffWeapon = weapons.Sheriff:Clone()
			sheriffWeapon.Parent = sheriff.Backpack
			
			sheriffWeapon.Handle.Touched:Connect(function(hit)
				if sheriffWeapon.Parent == workspace then

					if hit.Parent:FindFirstChild("Humanoid") and game.Players:GetPlayerFromCharacter(hit.Parent) and hit.Parent.Humanoid.Health > 0 then
						local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
						
						if table.find(alivePlayers, plr) then
							
							sheriffWeapon.Enabled = true
							sheriffWeapon.Handle.Anchored = false
							sheriffWeapon.Parent = game.Players:GetPlayerFromCharacter(hit.Parent).Backpack
							
							table.insert(sheriffs, plr)
							table.remove(table.find(alivePlayers, plr))
						end
					end
				end
			end)
		end
		
		
		local winner = "INNOCENTS"
		
		local gameStart = tick()
		
		while tick() - gameStart < config.RoundTime do
			task.wait(0.2)
			
			local roundEnds = math.round(config.RoundTime - (tick() - gameStart))
			
			local mins = math.floor(roundEnds / 60)
			local secs = roundEnds - (mins*60)
			mins = tostring(mins)
			secs = tostring(secs)
			
			if string.len(mins) < 2 then
				mins = "0" .. mins
			end
			if string.len(secs) < 2 then
				secs = "0" .. secs
			end
			
			status.Value = mins .. ":" .. secs
			
			if #alivePlayers == 0 and #sheriffs == 0 then
				winner = "MURDERERS"
				break
			elseif #murderers == 0 then
				winner = "SHERIFFS"
				break
			end
		end
		
		if winner == "MURDERERS" then
			status.Value = "The murderer killed everyone!"
			
			for i, murderer in pairs(murderers) do
				murderer.leaderstats.Cash.Value += config.MurderersWinReward
			end
			
		elseif winner == "SHERIFFS" then
			status.Value = "The sheriff killed the murderer!"
			
			for i, sheriff in pairs(sheriffs) do
				sheriff.leaderstats.Cash.Value += config.SheriffKillReward
			end
			for i, alivePlr in pairs(alivePlayers) do
				alivePlr.leaderstats.Cash.Value += config.InnocentsSurviveReward
			end
			
		else
			status.Value = "The innocents win by surviving long enough!"
			
			for i, sheriff in pairs(sheriffs) do
				sheriff.leaderstats.Cash.Value += config.InnocentsSurviveReward
			end
			for i, alivePlr in pairs(alivePlayers) do
				alivePlr.leaderstats.Cash.Value += config.InnocentsSurviveReward
			end
		end
		
		for i, plr in pairs(murderers) do
			plr:LoadCharacter()
		end
		for i, plr in pairs(sheriffs) do
			plr:LoadCharacter()
		end
		for i, plr in pairs(alivePlayers) do
			plr:LoadCharacter()
		end
		
		chosenMap:Destroy()
		
		alivePlayers = {}
		sheriffs = {}
		murderers = {}
		
		task.wait(config.TimeAfterRoundEnds)
	end
end