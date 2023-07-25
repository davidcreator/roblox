local box = workspace:WaitForChild("TargetBox")
local startButton = box:WaitForChild("AimTrainerGui"):WaitForChild("StartButton")

local camera = workspace.CurrentCamera

local currentClicked = 0
local currentHit = 0
local currentScore = 0

local started = false

local length = 60
local speed = 1

local mouse = game.Players.LocalPlayer:GetMouse()


mouse.Button1Down:Connect(function()
	
	if started then
		
		script.ClickSound:Play()
		
		currentClicked += 1
		
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
		raycastParams.FilterDescendantsInstances = {workspace.Targets}
		
		local rayResult = workspace:Raycast(camera.CFrame.Position, camera.CFrame.LookVector * 1000, raycastParams)
		
		if rayResult and rayResult.Instance then
			
			script.HitSound:Play()

			rayResult.Instance:Destroy()
			currentHit += 1
			
			currentScore += 100
			
			box.AimTrainerGui.Points.Text = currentScore
		end
		
		local accuracy = math.floor(currentHit / currentClicked * 100 + 0.5) or 0
		box.AimTrainerGui.Accuracy.Text = accuracy .. "%"
	end
end)


startButton.MouseButton1Click:Connect(function()

	if started then return end
	
	started = true
	
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
	
	local startTime = os.time()
	local currentTime = startTime
	
	currentClicked = 0
	currentHit = 0
	currentScore = 0
	
	camera.CameraSubject = box.CameraPart
	game.Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
	
	local targetsContainer = Instance.new("Model", workspace)
	targetsContainer.Name = "Targets"

	
	while currentTime - startTime <= length do

		local target = script.Target:Clone()
		local size = math.random(2, 7)
		target.Size = Vector3.new(size, size, size)
		target.Position = Vector3.new(
			math.random(box.Position.X - box.Size.X/2, box.Position.X + box.Size.X/2),
			math.random(box.Position.Y - box.Size.Y/2, box.Position.Y + box.Size.Y/2),
			math.random(box.Position.Z - box.Size.Z/2, box.Position.Z + box.Size.Z/2)
		)

		target.Parent = targetsContainer

		wait(speed)

		if target then 
			target:Destroy() 
			currentScore = math.clamp(currentScore - 10, 0, math.huge)
			box.AimTrainerGui.Points.Text = currentScore
		end
		
		currentTime = os.time()
		
		
		local timeSeconds = math.clamp(length - (currentTime - startTime), 0, math.huge)
		local mins = math.floor(timeSeconds / 60)
		local secs = tostring(timeSeconds % 60)
		if string.len(secs) < 2 then secs = "0" .. secs end
		
		box.AimTrainerGui.Time.Text = mins .. ":" .. secs
	end
	
	targetsContainer:Destroy()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
	camera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
	game.Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
	started = false
end)