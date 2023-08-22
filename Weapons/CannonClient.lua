local uis = game:GetService("UserInputService")

local humanoid = script.Parent:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera
local mouse = game.Players.LocalPlayer:GetMouse()

local currentCannon = nil

local cameraOffset = CFrame.new()


humanoid.Seated:Connect(function(active, currentSeat)
	
	if active then
		local cannon = currentSeat.Parent.Parent
		
		if cannon.Name == "Cannon" then	
			currentCannon = cannon
		end
	else
		currentCannon = nil
	end
end)

mouse.Button1Down:Connect(function()
	
	if currentCannon then
		game.ReplicatedStorage.CannonRE:FireServer(currentCannon, "SHOOT", mouse.Hit)
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()	
	
	if currentCannon then
		camera.CFrame = currentCannon.Top.Gun.CameraPositionPart.CFrame * cameraOffset
		
		local delta = uis:GetMouseDelta()
		
		game.ReplicatedStorage.CannonRE:FireServer(currentCannon, "MOVE", delta)
		
		camera.CameraType = Enum.CameraType.Scriptable
		uis.MouseBehavior = Enum.MouseBehavior.LockCenter
		
	else
		camera.CameraType = Enum.CameraType.Custom
		uis.MouseBehavior = Enum.MouseBehavior.Default
	end
end)

game.ReplicatedStorage.CannonRE.OnClientEvent:Connect(function(ball)
	
	spawn(function()
		camera.FieldOfView = 80
		
		for i = 10, 0, -1 do
			camera.FieldOfView = 70 + i
			wait()
		end
	end)
	
	ball:Destroy()
	
	local newBall = game.ReplicatedStorage.Cannonball:Clone()
	newBall.CFrame = currentCannon.Top.Gun.CannonballPositionPart.CFrame

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bv.Parent = newBall

	local distance = (mouse.Hit.LookVector * 500 - currentCannon.Top.Gun.CannonballPositionPart.Position).Magnitude
	bv.Velocity = mouse.Hit.LookVector * 500

	game:GetService("Debris"):AddItem(newBall, 30)
	newBall.Parent = workspace
	
	wait(0.1)
	bv:Destroy()
end)