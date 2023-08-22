local cooldown = 5
local cooldowns = {}


game.ReplicatedStorage.LightAttackRE.OnServerEvent:Connect(function(plr, hit)
	
	if cooldowns[plr] or not hit then return end
	cooldowns[plr] = true
	
	plr.Character.HumanoidRootPart.Anchored = true
	
	local part = game.ServerStorage.LightAttackPart:Clone()
	part.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position + hit.LookVector * 2, hit.Position)

	local ring = part.LightAttackGui.Ring
	local circle = part.LightAttackGui.Circle

	circle.Size, part.LightAttackGuiBack.Ring.Size = UDim2.new(0,0,0,0), UDim2.new(0,0,0,0)
	ring.Size, part.LightAttackGuiBack.Circle.Size = UDim2.new(0,0,0,0), UDim2.new(0,0,0,0)


	local lightParticles = part.LightParticles
	for i, p in pairs(lightParticles:GetChildren()) do
		p.Enabled = false
	end
	lightParticles.Core.Size = NumberSequence.new(0)


	local light = part.PointLight
	light.Brightness = 0


	part.Parent = plr.Character.HumanoidRootPart


	spawn(function()
		while wait() do
			ring.Rotation, part.LightAttackGuiBack.Ring.Rotation = ring.Rotation + 1, ring.Rotation + 1
			circle.Rotation, part.LightAttackGuiBack.Circle.Rotation = circle.Rotation - 1, circle.Rotation - 1
		end
	end)

	wait(0.5)

	circle:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quint")
	part.LightAttackGuiBack.Ring:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quint")
	ring:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Back")
	part.LightAttackGuiBack.Circle:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Back")

	wait(0.3)



	lightParticles.Core.Enabled = true

	local ts = game:GetService("TweenService")


	for i, p in pairs(lightParticles:GetChildren()) do
		p.Enabled = true
	end
	
	part.ChargeSound:Play()

	local i = 0
	while i < 1.5 do
		i += 0.01
		lightParticles.Core.Size = NumberSequence.new(i)
		wait()
	end
		
	wait(0.3)
		
	ts:Create(part, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Size = Vector3.new(0, 0, 0)}):Play()
		
	while i > 0 do
		i -= 0.5
		lightParticles.Core.Size = NumberSequence.new(i)
		wait()
	end
		
		
	local beam = game.ServerStorage.Beam:Clone()
		
	local distance = 30

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {part}

	local raycastResult = workspace:Raycast(part.Position, part.CFrame.LookVector * distance)

	if raycastResult then distance = raycastResult.Distance end
		
		
	local sizes = {
		Vector3.new(beam.Beam.Size.X, beam.Beam.Size.Y, distance),
		Vector3.new(beam.WhiteSpiral.Size.X, beam.WhiteSpiral.Size.Y, distance),
		Vector3.new(beam.YellowSpiral.Size.X, beam.YellowSpiral.Size.Y, distance)	
	}
		

	spawn(function()
		while beam.Parent ~= nil do
			beam.WhiteSpiral.Rotation += Vector3.new(0, 0, 5)
			beam.YellowSpiral.Rotation -= Vector3.new(0, 0, 5)
			beam.Head.Rotation += Vector3.new(0, 0, 5)
			wait()
		end
	end)
		
	beam:SetPrimaryPartCFrame(part.CFrame + (part.CFrame.LookVector * (distance/2)))
		
		
	beam.Beam.Size = Vector3.new(0, 0, distance)
	beam.WhiteSpiral.Size = Vector3.new(0, 0, distance)
	beam.YellowSpiral.Size = Vector3.new(0, 0, distance)
	beam.Head.CFrame = beam.Beam.CFrame
		
	ts:Create(beam.Beam, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Size = sizes[1]}):Play()
	ts:Create(beam.WhiteSpiral, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Size = sizes[2]}):Play()
	ts:Create(beam.YellowSpiral, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Size = sizes[3]}):Play()
	ts:Create(beam.Head, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {CFrame = beam.Beam.CFrame + (beam.Beam.CFrame.LookVector * (distance/2))}):Play()
		
	beam.Parent = workspace
		
	ts:Create(light, TweenInfo.new(0.1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Brightness = 10}):Play()
	
	part.BeamSound:Play()
		
	for i = 1, 100 do
		
		wait(0.05)
		
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
		local chars = {}
		for i, plrLoop in pairs(game.Players:GetPlayers()) do
			if plr ~= plrLoop.Character then table.insert(chars, plrLoop.Character) end
		end
		raycastParams.FilterDescendantsInstances = chars
		
		local raycastResult = workspace:Raycast(part.Position, part.CFrame.LookVector * (distance + 1))
		
		if raycastResult and raycastResult.Instance.Parent:FindFirstChild("Humanoid") then
			
			raycastResult.Instance.Parent.Humanoid:TakeDamage(1.5)
			
			if game.Players:GetPlayerFromCharacter(raycastResult.Instance.Parent) then
				game.ReplicatedStorage.LightAttackRE:FireClient(game.Players:GetPlayerFromCharacter(raycastResult.Instance.Parent))
			end
		end
		
		game.ReplicatedStorage.LightAttackRE:FireClient(plr)
	end

	ts:Create(beam.Beam, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Size = Vector3.new()}):Play()
	ts:Create(beam.WhiteSpiral, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Size = Vector3.new()}):Play()
	ts:Create(beam.YellowSpiral, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Size = Vector3.new()}):Play()
	ts:Create(beam.Head, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Transparency = 1}):Play()

	ts:Create(light, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {Brightness = 0}):Play()
	
	plr.Character.HumanoidRootPart.Anchored = false
		
	wait(0.3)
	beam:Destroy()
		
	for i, p in pairs(lightParticles:GetChildren()) do
		p.Enabled = false
	end
	
	wait(cooldown)
	cooldowns[plr] = nil
end)