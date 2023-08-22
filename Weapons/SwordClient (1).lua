--Variables
local re = game.ReplicatedStorage:WaitForChild("SwordReplicatedStorage"):WaitForChild("SwordRE")

local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
repeat 
	task.wait() 
	char = game.Players.LocalPlayer.Character
until char.Parent == workspace

local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

local uis = game:GetService("UserInputService")
local mouse = game.Players.LocalPlayer:GetMouse()

local camera = workspace.CurrentCamera
local defaultFOV = camera.FieldOfView
local sprintingFOV = defaultFOV + 5

local x = 0
local y = 0

local sword = script.Parent

local idle = humanoid:LoadAnimation(script:WaitForChild("Idle"))
local walk = humanoid:LoadAnimation(script:WaitForChild("Walk"))
local sprint = humanoid:LoadAnimation(script:WaitForChild("Sprint"))
local block = humanoid:LoadAnimation(script:WaitForChild("Block"))
local swingAnimations = {
	humanoid:LoadAnimation(script:WaitForChild("Swing1")),
	humanoid:LoadAnimation(script:WaitForChild("Swing2")),
	humanoid:LoadAnimation(script:WaitForChild("Swing3")),
	humanoid:LoadAnimation(script:WaitForChild("Swing4")),
}


--Equip
sword.Equipped:Connect(function()
	hrp.CFrame = CFrame.new(hrp.Position, camera.CFrame.LookVector * 100 * Vector3.new(1, 0, 1))
	x = hrp.Orientation.Y

	char.RightHand:WaitForChild("SwordMotor6D").Part0 = char.RightHand
	char.RightHand.SwordMotor6D.Part1 = sword.BodyAttach

	re:FireServer("ConnectM6D", sword)

	idle:Play()	

	camera.CameraType = Enum.CameraType.Scriptable
	humanoid.AutoRotate = false
end)

--Unequip
sword.Unequipped:Connect(function()
	re:FireServer("DisconnectM6D")
	
	idle:Stop()
	walk:Stop()
	sprint:Stop()
	block:Stop()
	for i, swingAnim in pairs(swingAnimations) do
		swingAnim:Stop()
	end
end)

--Player left clicks with sword
sword.Activated:Connect(function()
	if sword.Parent == char and humanoid.Health > 0 then
		re:FireServer("attack", sword)
	end
end)

--Player right clicks to block
mouse.Button2Down:Connect(function()
	if sword.Parent == char and humanoid.Health > 0 then
		re:FireServer("block", sword)
	end
end)
--Player releases right click to stop blocking
mouse.Button2Up:Connect(function()
	if sword.Parent == char and humanoid.Health > 0 then
		re:FireServer("stop block", sword)
	end
end)

--Play swing animations
re.OnClientEvent:Connect(function(instruction, combo)
	
	if instruction == "swing animation" then
		swingAnimations[combo]:Play()
		
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(math.huge, 0, math.huge)

		local lookVector = camera.CFrame.LookVector * Vector3.new(1, 0, 1)
		local distance = 50
		local rayParams = RaycastParams.new()
		rayParams.FilterDescendantsInstances = {char}
		local ray = workspace:Raycast(hrp.Position, hrp.Position + lookVector * 5, rayParams)
		if ray then
			distance *= ray.Distance / 10
		end
		
		bv.Velocity = lookVector * distance
		bv.Parent = hrp
		game:GetService("Debris"):AddItem(bv, 0.1)
		
		task.wait(combo == 4 and 0.3 or 0.1)
		local scale = 0.5
		if combo == 4 then
			scale = 20
		end
		spawn(function()
			for i = 1, 10 do
				task.wait(0.01)
				local x = math.noise(i/6, i/6, math.random(1, 1000))
				local y = math.noise(i/6, i/6, math.random(1, 1000))
				local z = math.noise(i/6, i/6, math.random(1, 1000))
				
				humanoid.CameraOffset = Vector3.new(x, y, z)
				camera.CFrame = camera.CFrame:Lerp(camera.CFrame * CFrame.Angles(x*scale, y*scale, z*scale), 0.2)
			end
		end)
		
	elseif instruction == "camera shake" then
		
		local scale = 20
		spawn(function()
			for i = 1, 10 do
				task.wait(0.01)
				local x = math.noise(i/6, i/6, math.random(1, 1000))
				local y = math.noise(i/6, i/6, math.random(1, 1000))
				local z = math.noise(i/6, i/6, math.random(1, 1000))

				humanoid.CameraOffset = Vector3.new(x, y, z)
				camera.CFrame = camera.CFrame:Lerp(camera.CFrame * CFrame.Angles(x*scale, y*scale, z*scale), 0.2)
			end
		end)
	end
end)

--Sprinting
uis.InputBegan:Connect(function(input, p)
	if not p and input.KeyCode == Enum.KeyCode.LeftControl then
		re:FireServer("sprint", sword)
	end
end)

--Detect mouse movements for third person camera
local sens = 0.4

uis.InputChanged:Connect(function(input, p)
	if not p and input.UserInputType == Enum.UserInputType.MouseMovement and sword.Parent == char then

		x -= input.Delta.X * sens
		y = math.clamp(y - input.Delta.Y * sens, -30, 30)

		hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(-input.Delta.X * sens), 0)
	end
end)

--Move camera and apply walking animation if moving
game:GetService("RunService").RenderStepped:Connect(function()

	if sword.Parent == char and humanoid.Health > 0 then
		
		uis.MouseBehavior = Enum.MouseBehavior.LockCenter

		local cf = CFrame.new(hrp.Position) * CFrame.Angles(0, math.rad(x), 0) * CFrame.Angles(math.rad(y), 0, 0)
		local offset = Vector3.new(3, 5, 10)
		local pos = cf:ToWorldSpace(CFrame.new(offset)).Position
		local lookAt = cf:ToWorldSpace(CFrame.new(offset.X, offset.Y - 30, -100)).Position
		local finalCF = CFrame.new(pos, lookAt)

		camera.CFrame = camera.CFrame:Lerp(finalCF, 0.8)

		if humanoid.MoveDirection.Magnitude > 0 and not walk.IsPlaying then
			walk:Play()
		elseif humanoid.MoveDirection.Magnitude <= 0 then
			walk:Stop()
		end
		
		if char:FindFirstChild("BLOCKING") and not block.IsPlaying then
			block:Play()
		elseif not char:FindFirstChild("BLOCKING") then
			block:Stop()
		end
		
	else
		if humanoid.AutoRotate == false then
			humanoid.AutoRotate = true
			camera.CameraType = Enum.CameraType.Custom
			if camera.FieldOfView >= 1 then
				uis.MouseBehavior = Enum.MouseBehavior.Default
			end
		end
	end
	
	local sprinting = char:FindFirstChild("SPRINTING") and true or false
	
	if sprinting and humanoid.MoveDirection.Magnitude > 0 then
		humanoid.WalkSpeed = sprinting and 25
		camera.FieldOfView = camera.FieldOfView + (sprintingFOV - camera.FieldOfView) * 0.1
		if sword.Parent == char and not sprint.IsPlaying then
			sprint:Play()
		end
		
	else
		humanoid.WalkSpeed = 16
		camera.FieldOfView = camera.FieldOfView + (defaultFOV - camera.FieldOfView) * 0.1
		sprint:Stop()
	end
end)