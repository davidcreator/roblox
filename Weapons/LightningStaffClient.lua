local folder = game.ReplicatedStorage:WaitForChild("LightningStaffReplicatedStorage")
local re = folder:WaitForChild("RemoteEvent")

local ts = game:GetService("TweenService")

local area = nil
local cooldown = false

local camera = workspace.CurrentCamera
local mouse = game.Players.LocalPlayer:GetMouse()

local tool = script.Parent


tool.Equipped:Connect(function()
	area = folder:WaitForChild("StrikeArea"):Clone()
end)

tool.Unequipped:Connect(function()
	
	if area.Parent == workspace then
		local dummyArea = area:Clone()
		dummyArea.Parent = workspace

		area:Destroy()

		local ti = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		local fadeOut = ts:Create(dummyArea:WaitForChild("Circle"), ti, {Transparency = 1})
		fadeOut:Play()
		task.wait(0.7)
		dummyArea:Destroy()
	end
end)

tool.Activated:Connect(function()
	if not cooldown then
		re:FireServer(tool, mouse.Hit)
	end
end)


re.OnClientEvent:Connect(function(instruction, p2)
	
	if instruction == "cooldownOn" then
		cooldown = true
		
	elseif instruction == "cooldownOff" then
		cooldown = false
		
	elseif instruction == "cameraShake" then
		local char = game.Players.LocalPlayer.Character
		
		if char then
			local distance = (char.HumanoidRootPart.Position - p2).Magnitude
			
			if distance <= 50 then
				
				local seed = Random.new():NextNumber(1, 1000)
				local trauma = 1
				
				local start = tick()
				local increment = 0
				
				local blur = Instance.new("BlurEffect")
				blur.Size = 0
				blur.Parent = game.Lighting
				
				task.spawn(function()
					
					while trauma > 0 do
						game:GetService("RunService").Heartbeat:Wait()
						
						local now = tick() - start
						increment += 1
						
						local shake = trauma ^ 2 / (distance/10)
						
						local noiseX = (math.noise(increment/3, now) * 2 - 1) * shake
						local noiseY = (math.noise(increment/3+1, now) * 2 - 1) * shake
						local noiseZ = (math.noise(increment/3+2, now) * 2 - 1) * shake
						
						char.Humanoid.CameraOffset = Vector3.new(noiseX, noiseY, noiseZ)
						camera.CFrame *= CFrame.Angles(noiseX/80, noiseY/80, noiseZ/80)
						
						blur.Size = shake * 15
						
						trauma = math.clamp(trauma - 2 * game:GetService("RunService").Heartbeat:Wait(), 0, 1)
					end
					char.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
					blur:Destroy()
				end)
			end
			
			local hitVFX = folder.HitParticles:Clone()
			game:GetService("Debris"):AddItem(hitVFX, 3)
			hitVFX.Position = p2
			hitVFX.Parent = workspace

			local sound = folder.LightningSound:Clone()
			sound.Parent = hitVFX
			sound:Play()
			sound.Ended:Connect(function()
				sound:Destroy()
			end)

			task.wait(0.3)
			for i, descendant in pairs(hitVFX:GetDescendants()) do
				if descendant:IsA("ParticleEmitter") or descendant:IsA("PointLight") then
					descendant.Enabled = false
				end
			end
		end
	end
end)


game:GetService("RunService").Stepped:Connect(function()
	if tool.Parent.Parent == workspace then
		
		local areaPos = mouse.Hit.Position
		local hrpPos = tool.Parent.HumanoidRootPart.Position
		
		local distance = (areaPos - hrpPos).Magnitude
		
		if distance <= 40 and not cooldown then
			area.Position = mouse.Hit.Position
			
			if area.Parent ~= workspace then
				area:WaitForChild("Circle").Transparency = 1
				local ti = TweenInfo.new(0.7, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
				local fadeIn = ts:Create(area.Circle, ti, {Transparency = 0})
				fadeIn:Play()
			end
			area.Parent = workspace
			
		elseif area.Parent == workspace then
			
			local dummyArea = area:Clone()
			dummyArea.Parent = workspace
			
			area.Parent = game.ReplicatedStorage
			
			local ti = TweenInfo.new(0.7, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			local fadeOut = ts:Create(dummyArea:WaitForChild("Circle"), ti, {Transparency = 1})
			fadeOut:Play()
			task.wait(0.7)
			dummyArea:Destroy()
		end
		
		area.Orientation += Vector3.new(0, 1, 0)
	end
end)