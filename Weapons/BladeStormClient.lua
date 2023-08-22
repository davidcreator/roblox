local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

local char = script.Parent
local mouse = game.Players.LocalPlayer:GetMouse()
local cam = workspace.CurrentCamera

local zone = game.ReplicatedStorage:WaitForChild("Zone"):Clone()
if workspace:FindFirstChild(char.Name .. "ZONE") then
	workspace[char.Name .. "ZONE"]:Destroy()
end
if game.Players.LocalPlayer:FindFirstChild(char.Name .. "ZONE") then
	game.Players.LocalPlayer[char.Name .. "ZONE"]:Destroy()
end
zone.Name = char.Name .. "ZONE"
zone.Parent = game.Players.LocalPlayer

local cooldown = false
local debounce = false
local casting = false
local freeze = false
local shake = false

local fallOffset = Instance.new("NumberValue")


function activateCircle()
	game.ReplicatedStorage.ActivateSound:Play()
	debounce = true
	zone.Circle.Transparency = 1
	zone.Circle.Color3 = Color3.fromRGB(100, 300, 3500)
	zone.Size = Vector3.new(0.001, game.ReplicatedStorage.Zone.Size.Z/2, game.ReplicatedStorage.Zone.Size.Z/2)
	fallOffset.Value = 3
	local ti = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
	local fade = ts:Create(zone.Circle, ti, {Transparency = 0})
	local scale = ts:Create(zone, ti, {Size = Vector3.new(0.001, game.ReplicatedStorage.Zone.Size.Z, game.ReplicatedStorage.Zone.Size.Z)})
	local fall = ts:Create(fallOffset, ti, {Value = 0})
	fade:Play()
	scale:Play()
	fall:Play()

	zone.Parent = workspace
	debounce = false
end

function deactivateCircle()
	debounce = true
	local ti = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	local fade = ts:Create(zone.Circle, ti, {Transparency = 1})
	local scale = ts:Create(zone, ti, {Size = Vector3.new(0.001, game.ReplicatedStorage.Zone.Size.Z*1.5, game.ReplicatedStorage.Zone.Size.Z*1.5)})
	local colourShift = ts:Create(zone.Circle, ti, {Color3 = Color3.fromRGB(3500, 100, 130)})
	fade:Play()
	scale:Play()
	colourShift:Play()
	colourShift.Completed:Wait()

	zone.Parent = game.Players.LocalPlayer
	debounce = false
end


game:GetService("RunService").Stepped:Connect(function()
	
	if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
		if casting and zone.Parent == game.Players.LocalPlayer then
			activateCircle()	
		elseif not casting and zone.Parent ~= game.Players.LocalPlayer and zone.Circle.Transparency == 0 then
			deactivateCircle()
		end
			
		zone.Orientation += Vector3.new(0, 1, 0)
		
		if not freeze then
			local goal = mouse.Hit.Position
			local cf = CFrame.new(cam.CFrame.Position, goal)
			local hrp = char.HumanoidRootPart
			local distance = (hrp.Position - goal).Magnitude
				
			if distance > 80 then
				goal = cf.LookVector * 80
			end
				
			local rayParams = RaycastParams.new()
			rayParams.FilterDescendantsInstances = {zone, char}
			
			local ray = workspace:Raycast(goal + Vector3.new(0, 0.1, 0), goal - Vector3.new(0, 1000, 0))
				
			if ray then
				goal += Vector3.new(0, -goal.Y + ray.Position.Y, 0)
				while (hrp.Position - goal).Magnitude > 80 do
					goal += CFrame.new(goal, hrp.Position).LookVector
				end
				
				zone.Position = goal + Vector3.new(0, fallOffset.Value, 0)
			end
		end
		
		if shake then
			
			local x = Random.new():NextNumber(-0.05, 0.05)
			local y = Random.new():NextNumber(-0.05, 0.05)
			local z = Random.new():NextNumber(-0.05, 0.05)

			char.Humanoid.CameraOffset = Vector3.new(x, y, z)
			cam.CFrame *= CFrame.Angles(x/5, y/5, z/5)

			wait()
		end
	elseif zone.Parent ~= game.Players.LocalPlayer then
		deactivateCircle()
	end
end)


uis.InputBegan:Connect(function(inp, p) 
	if not p and not debounce and inp.KeyCode == Enum.KeyCode.B and not cooldown and not freeze then
		casting = not cooldown and not casting or false
		if not casting then
			game.ReplicatedStorage.DeactivateSound:Play()
		end
	end
end)

mouse.Button1Up:Connect(function()
	if not debounce and casting and not freeze and not cooldown then

		game.ReplicatedStorage:WaitForChild("BladeStormRE"):FireServer(zone.Position)
		freeze = true
		
		local ti = TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)
		local colourShift = ts:Create(zone.Circle, ti, {Color3 = Color3.fromRGB(3500, 100, 130)})
		colourShift:Play()
		
		wait(1)
		shake = true
	end
end)

game.ReplicatedStorage.BladeStormRE.OnClientEvent:Connect(function(p1, p2, p3, p4)
	if p1 == "CooldownOn" then
		cooldown = true
	elseif p1 == "CooldownOff" then
		cooldown = false
		
	elseif p1 and typeof(p1) == "Vector3" and p2 and p3 and p4 then
		local sword = game.ReplicatedStorage:WaitForChild("Sword"):Clone()

		local start = p1
		local lookAt = CFrame.new(p2, start).LookVector * 1000
		sword:SetPrimaryPartCFrame(CFrame.new(start, lookAt))
		sword.Parent = workspace.SwordsFolder
		
		local v3Value = Instance.new("Vector3Value")
		v3Value.Value = sword.PrimaryPart.Position
		local ti = TweenInfo.new(p3)
		local fallTween = ts:Create(v3Value, ti, {Value = p2})
		fallTween:Play()
		
		v3Value:GetPropertyChangedSignal("Value"):Connect(function()
			sword:SetPrimaryPartCFrame(CFrame.new(v3Value.Value, lookAt))
		end)
		
		game:GetService("Debris"):AddItem(sword, p3 + 0.3)
		spawn(function()
			wait(p3)

			local particles = game.ReplicatedStorage:WaitForChild("Particles"):Clone()
			particles.Position = p2
			for i, p in pairs(particles:GetChildren()) do
				p.Enabled = false
			end
			particles.Parent = workspace.SwordsFolder
			particles.Sparks.Enabled = true
			particles.Explosion.Enabled = true
			wait(0.1)
			particles.Explosion.Enabled = false
			particles.Sparks.Enabled = false
			particles.Circles.Enabled = true
			particles.Dust.Enabled = true
			wait(0.08)
			particles.Circles.Enabled = false
			particles.Smoke.Enabled = true
			wait(0.1)
			particles.Dust.Enabled = false
			particles.Smoke.Enabled = false
			wait(1)
			particles:Destroy()
		end)
		
		local sound = game.ReplicatedStorage:WaitForChild("SwordSound"):Clone()
		sound.Parent = p4
		sound:Play()
		sound.Ended:Connect(function()
			sound:Destroy()
		end)
	
	elseif p1 and typeof(p1) == "Instance" and p1.Name == "Zone" then
		p1.Circle.Transparency = 1
		
	else
		shake = false

		deactivateCircle()

		casting = false
		freeze = false
	end
end)