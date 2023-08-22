local lightningFolder = Instance.new("Folder")
lightningFolder.Name = "LIGHTNING FOLDER"
lightningFolder.Parent = workspace

local folder = game.ReplicatedStorage:WaitForChild("ChainLightningFolder")
local remoteEvent = folder:WaitForChild("ChainLightningRE")
local range = folder:WaitForChild("Range")
local maxTargets = folder:WaitForChild("MaxTargets")
local dmg = folder:WaitForChild("TotalDamage")
local cooldown = folder:WaitForChild("Cooldown")
local particles = folder:WaitForChild("Particles")
local fireSound = folder:WaitForChild("FireSound")
local electrocuteSound = folder:WaitForChild("ElectrocuteSound")
electrocuteSound.Looped = true
local activateAbilityAnimation = folder:WaitForChild("ActivateAbilityAnimation")
local electrocuteAnimation = folder:WaitForChild("ElectrocuteAnimation")

local cooldownList = {}


function electrocute(char)

	if char then

		local plr = game.Players:GetPlayerFromCharacter(char)
		if plr then
			remoteEvent:FireClient(plr, "electrocute")
		end

		local particlesList = {}
		for i, particle in pairs(particles:GetChildren()) do
			local newParticle = particle:Clone()
			table.insert(particlesList, newParticle)
			newParticle.Parent = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char.HumanoidRootPart
		end

		for i, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.Transparency = 0.3
			end
		end

		local loadedAnim = char.Humanoid:LoadAnimation(electrocuteAnimation)
		loadedAnim:Play()
		
		local sound = electrocuteSound:Clone()
		sound.Parent = char.HumanoidRootPart
		sound:Play()

		char.HumanoidRootPart.Anchored = true

		wait(2)

		for i, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
				part.Transparency = 0
			end
		end

		for i, particle in pairs(particlesList) do
			particle:Destroy()
		end
		
		sound:Destroy()
		loadedAnim:Stop()
		char.HumanoidRootPart.Anchored = false
	end
end


function createLightning(startInstance, endInstance, endPos, alreadyTargeted)

	local endPart = Instance.new("Part")
	game:GetService("Debris"):AddItem(endPart, 2)
	endPart.Position = endPos + Vector3.new(0, 1.5, 0)
	endPart.Anchored = true
	endPart.CanCollide = false
	endPart.Transparency = 1
	endPart.Parent = lightningFolder
	
	local loopStarted = tick()
	spawn(function()
		
		local damagePerTick = dmg.Value * 0.05 / 2
		local dealtDmg = 0
		
		while tick() - loopStarted < 2 do
			wait(0.05)
			
			if endInstance.Parent:FindFirstChild("Humanoid") then
				dealtDmg += damagePerTick
				endInstance.Parent.Humanoid:TakeDamage(damagePerTick)
			end
			
			local boltsAmount = math.random(3, 7)
			
			for i = 1, boltsAmount do
				local attachmentsAmount = math.random(3, 7)
				local distance = (startInstance.Position - endPos).Magnitude
				local segmentLength = distance / (attachmentsAmount - 1)
				
				local attachmentsList = {}
				
				for i = 1, attachmentsAmount do
					
					if i == 1 then
						local attachment0 = Instance.new("Attachment")
						game:GetService("Debris"):AddItem(attachment0, 0.05)
						table.insert(attachmentsList, attachment0)
						attachment0.Parent = startInstance
						
					elseif i == attachmentsAmount then
						local attachment1 = Instance.new("Attachment")
						game:GetService("Debris"):AddItem(attachment1, 0.05)
						table.insert(attachmentsList, attachment1)
						
						local rx = Random.new():NextNumber(-3, 3)
						local ry = Random.new():NextNumber(-3, 3)
						local rz = Random.new():NextNumber(-3, 3)
						local randomOffset = Vector3.new(rx, ry, rz)
						attachment1.Position = randomOffset

						attachment1.Parent = endPart
						
						local beam = Instance.new("Beam")
						game:GetService("Debris"):AddItem(beam, 2)
						beam.FaceCamera = true
						beam.Width0 = 0.4
						beam.Width1 = 0.4
						beam.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 10)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 10))}
						beam.LightEmission = 8
						beam.Attachment0 = attachmentsList[i - 1]
						beam.Attachment1 = attachment1
						beam.Parent = lightningFolder
						
					else
						local attachment1 = Instance.new("Attachment")
						game:GetService("Debris"):AddItem(attachment1, 0.05)
						table.insert(attachmentsList, attachment1)
						
						local direction = (endPos - startInstance.Position).Unit
						local pos = startInstance.Position + ((i - 1) * segmentLength * direction)
						
						local rx = Random.new():NextNumber(-3, 3)
						local ry = Random.new():NextNumber(-3, 3)
						local rz = Random.new():NextNumber(-3, 3)
						local randomOffset = Vector3.new(rx, ry, rz)
						pos += randomOffset

						local a1Part = Instance.new("Part")
						game:GetService("Debris"):AddItem(a1Part, 0.05)
						a1Part.Position = pos
						a1Part.Anchored = true
						a1Part.CanCollide = false
						a1Part.Transparency = 1
						a1Part.Parent = lightningFolder

						attachment1.Parent = a1Part
						
						local beam = Instance.new("Beam")
						game:GetService("Debris"):AddItem(beam, 2)
						beam.FaceCamera = true
						beam.Width0 = 0.2
						beam.Width1 = 0.2
						beam.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 10)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 10))}
						beam.LightEmission = 8
						beam.Attachment0 = attachmentsList[i - 1]
						beam.Attachment1 = attachment1
						beam.Parent = lightningFolder
					end
				end
			end
		end
		
		if endInstance.Parent:FindFirstChild("Humanoid") and dealtDmg < dmg.Value then
			endInstance.Parent.Humanoid:TakeDamage(dmg.Value - dealtDmg)
		end
	end)
	
	if endInstance.Parent:FindFirstChild("Humanoid") or #alreadyTargeted > 2 then
		
		local closestCharacter = nil
		
		for i, descendant in pairs(workspace:GetDescendants()) do
			if descendant.Name == "HumanoidRootPart" and descendant.Parent:FindFirstChild("Humanoid") and descendant.Parent.Humanoid.Health > 0 then
				
				if not table.find(alreadyTargeted, descendant.Parent) and (#alreadyTargeted - 1) < maxTargets.Value then
					
					local distance = (descendant.Position - endPos).Magnitude
					
					if distance <= range.Value then
						
						local raycastParams = RaycastParams.new()
						local ignoreList = {}
						for key, value in ipairs(alreadyTargeted) do
							table.insert(ignoreList, value)
						end
						table.insert(ignoreList, lightningFolder)
						raycastParams.FilterDescendantsInstances = ignoreList
						
						local cf = CFrame.new(endPos, descendant.Position)
						local ray = workspace:Raycast(endPos, cf.LookVector * 1000, raycastParams)
						
						if ray and ray.Instance.Parent == descendant.Parent then
							if not closestCharacter then
								closestCharacter = descendant.Parent
								
							else
								local closestDistance = (closestCharacter.HumanoidRootPart.Position - endPos).Magnitude
								
								if distance < closestDistance then
									closestCharacter = descendant.Parent
								end
							end
						end
					end
				end
			end
		end
		
		if closestCharacter then
			
			table.insert(alreadyTargeted, closestCharacter)
			createLightning(endPart, closestCharacter.HumanoidRootPart, closestCharacter.HumanoidRootPart.Position, alreadyTargeted)

			spawn(function()
				electrocute(closestCharacter)
			end)
		end
	end
end


remoteEvent.OnServerEvent:Connect(function(plr, goal)
	
	if goal and not cooldownList[plr] then
		local char = plr.Character
		if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
			
			local raycastParams = RaycastParams.new()
			raycastParams.FilterDescendantsInstances = {char, lightningFolder}
			
			local ray = workspace:Raycast(char.HumanoidRootPart.Position, goal, raycastParams)
			
			if ray then
				if ray.Instance.Parent:FindFirstChild("Humanoid") then
					spawn(function()
						electrocute(ray.Instance.Parent)
					end)
				end
				
				local rayPos = ray.Position
				local endInstance = ray.Instance
				local distance = (char.HumanoidRootPart.Position - rayPos).Magnitude

				if distance <= range.Value then
					cooldownList[plr]= true
					
					local loadedAnim = char.Humanoid:LoadAnimation(activateAbilityAnimation)
					loadedAnim:Play()
					
					local alreadyTargeted = {char}
					if ray.Instance.Parent:FindFirstChild("Humanoid") then
						table.insert(alreadyTargeted, ray.Instance.Parent)
					end
					
					createLightning(char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm") or char.HumanoidRootPart, endInstance, rayPos, alreadyTargeted)
					
					local sound = fireSound:Clone()
					sound.Parent = char.HumanoidRootPart
					sound:Play()
					
					wait(2)
					loadedAnim:Stop()
					sound:Destroy()

					wait(cooldown.Value - 2)
					cooldownList[plr] = false
				end
			end
		end
	end
end)