local folder = game.ReplicatedStorage:WaitForChild("ChainLightningFolder")
local remoteEvent = folder:WaitForChild("ChainLightningRE")
local hotkey = folder:WaitForChild("Hotkey")
local range = folder:WaitForChild("Range")

local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")

local mouse = game.Players.LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera


uis.InputBegan:Connect(function(inp, p)
	
	if not p and inp.KeyCode.Name == hotkey.Value then
		
		local mousePos = mouse.Hit.Position

		local direction = (mousePos - script.Parent.HumanoidRootPart.Position).Unit
		local goal = direction * range.Value
		
		remoteEvent:FireServer(goal)
	end
end)


local blur = script:WaitForChild("Blur")
local cc = script:WaitForChild("ColorCorrection")

remoteEvent.OnClientEvent:Connect(function(instruction)

	if instruction == "electrocute" then
		local start = tick()
		
		blur.Size = 0
		cc.Brightness = 0
		cc.Contrast = 0.3
		cc.TintColor = Color3.fromRGB(255, 167, 24)

		while tick() - start < 2 do 

			blur.Size += Random.new():NextNumber(-3, 3)
			blur.Size = math.clamp(blur.Size, 0, 12)

			cc.Brightness += Random.new():NextNumber(-0.05, 0.05)
			cc.Contrast += Random.new():NextNumber(-0.1, 0.1)


			blur.Parent = game.Lighting
			cc.Parent = game.Lighting

			local x = Random.new():NextNumber(-0.3, 0.3)
			local y = Random.new():NextNumber(-0.3, 0.3)
			local z = Random.new():NextNumber(-0.3, 0.3)

			script.Parent.Humanoid.CameraOffset = Vector3.new(x, y, z)
			camera.CFrame *= CFrame.Angles(x/5, y/5, z/5)

			wait()
		end

		local ti = TweenInfo.new(0.5)

		local tweenBlur = ts:Create(blur, ti, {Size = 0})
		tweenBlur:Play()

		local tweenCC = ts:Create(cc, ti, {Brightness = 0, Contrast = 0, TintColor = Color3.fromRGB(255, 255, 255)})
		tweenCC:Play()

		wait(0.5)

		blur.Parent = script
		cc.Parent = script
	end
end)