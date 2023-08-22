--Variables
local remoteEvent = game.ReplicatedStorage:WaitForChild("BattleRoyaleRE")
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local dropped = false

--Follow Plane with Camera
game:GetService("RunService").RenderStepped:Connect(function()
	
	local plane = workspace:FindFirstChild("Plane")
	
	if plane and not dropped then
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = CFrame.new(plane.PrimaryPart.Position - plane.PrimaryPart.CFrame.LookVector * 120 + plane.PrimaryPart.CFrame.UpVector * 70, plane.PrimaryPart.Position)
		
	else
		camera.CameraType = Enum.CameraType.Custom
	end
end)

--Unfollow Plane with Camera
remoteEvent.OnClientEvent:Connect(function(hasDropped)
	
	dropped = hasDropped
	if dropped then
		camera.CameraType = Enum.CameraType.Custom
	end
end)


--Drop Player when Space is Pressed
uis.JumpRequest:Connect(function(inp)
	remoteEvent:FireServer()
end)