local char = script.Parent

local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")


game:GetService("RunService").RenderStepped:Connect(function()
	
	
	local secsTime = tick()
	
	
	if humanoid.MoveDirection.Magnitude > 0 then
		
		local moveSpeed = hrp.Velocity.Magnitude
		
		
		local bobbleX = math.cos(secsTime * moveSpeed) / 5
		local bobbleY = math.abs(math.sin(secsTime * moveSpeed)) / 5
		
		local bobble = Vector3.new(bobbleX, bobbleY, 0)
		
		
		humanoid.CameraOffset = humanoid.CameraOffset:Lerp(bobble, 0.1)
		
		
	else

		humanoid.CameraOffset = humanoid.CameraOffset * 0.9
	end
end)