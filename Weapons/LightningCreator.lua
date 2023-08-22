local re = game.ReplicatedStorage:WaitForChild("CreateLighting")


local cooldown = {}


local partsFolder = Instance.new("Folder", workspace)


re.OnServerEvent:Connect(function(plr, mouseCF, camCF)
	
	
	if cooldown[plr] then return end
	
	cooldown[plr] = true
	
	
	local ray = Ray.new(camCF.Position, mouseCF.LookVector * 100)
	
	local part, goal = workspace:FindPartOnRayWithIgnoreList(ray, {plr.Character, partsFolder})
	
	
	if part and part.Parent:FindFirstChild("Humanoid") then
		
		part.Parent.Humanoid:TakeDamage(30)
	end
	
	if not goal then goal = mouseCF.LookVector * 100 end
	
	local length = (plr.Character.HumanoidRootPart.Position - goal).Magnitude
	
	
	local numPoints = math.random(3, 25)
	
	local increment = length / numPoints
	
	
	local beamPart = Instance.new("Part")
	beamPart.Anchored, beamPart.CanCollide, beamPart.Transparency, beamPart.Parent = true, false, 1, partsFolder
	
	
	local beams = {}
	
	
	for i = 1, numPoints do
		
		local atch = Instance.new("Attachment")
		atch.Parent = beamPart
		
		atch.Name = "LightningAttachment" .. i
		
		atch.Orientation = Vector3.new(0, 0, 0)
		
		local newInc = increment / 2
		local x, y, z = math.random(-newInc * 100, newInc * 100)/100, math.random(-newInc * 100, newInc * 100)/100, math.random(-newInc * 100, newInc * 100)/100
		local offset = Vector3.new(x, y, z)
		
		atch.WorldPosition = (plr.Character.HumanoidRootPart.Position) + ((i - 1) * increment * goal.Unit) + (offset)
		
		if i == 1 then
			atch.WorldPosition = plr.Character.HumanoidRootPart.Position
			
		elseif i == numPoints then
			atch.WorldPosition = goal
		end
		
		
		if i ~= 1 then
			
			
			local beam = Instance.new("Beam")
			beam.FaceCamera = true
			beam.Width0, beam.Width1 = 0.3, 0.3
			beam.Color = ColorSequence.new(Color3.fromRGB(0, 174, 255))
			beam.Texture = "rbxassetid://4595131819"
			beam.Transparency = NumberSequence.new(0)
			beam.LightEmission = 1
			
			beam.Attachment0 = beamPart["LightningAttachment" .. (i - 1)]
			beam.Attachment1 = atch
			
			beam.Parent = beamPart
			
			
			table.insert(beams, beam)
			
			
			game:GetService("Debris"):AddItem(beam, 0.3)
		end
		
		game:GetService("Debris"):AddItem(atch, 0.3)
	end
	
	
	game:GetService("Debris"):AddItem(beamPart, 0.3)
	
	
	wait(0.1)
	beams = {}
	cooldown[plr] = false
end)