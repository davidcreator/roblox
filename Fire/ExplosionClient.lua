local remoteEvent = game.ReplicatedStorage:WaitForChild("ExplosionRE")

local humanoid = script.Parent:WaitForChild("Humanoid")


remoteEvent.OnClientEvent:Connect(function(distance)
	
	local blur = Instance.new("BlurEffect")
	blur.Size = 200 / distance
	blur.Parent = game.Lighting
	
	for i = 1, 10 do
		
		local x = math.random(-100, 100) / (distance * 5 * i)
		local y = math.random(-100, 100) / (distance * 5 * i)
		local z = math.random(-100, 100) / (distance * 5 * i)

		humanoid.CameraOffset = Vector3.new(x, y, z)
		workspace.CurrentCamera.CFrame *= CFrame.Angles(x / (distance * 5 * i), y / (distance * 5 * i), z / (distance * 5 * i))

		wait()
	end
	
	humanoid.CameraOffset = Vector3.new(0, 0, 0)
	
	local size = blur.Size
	
	for i = 50, 0, -1 do
		
		blur.Size = size * (i / 100)
		wait()
	end
	
	blur:Destroy()
end)