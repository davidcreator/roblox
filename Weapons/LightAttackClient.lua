local uis = game:GetService("UserInputService")

local mouse = game.Players.LocalPlayer:GetMouse()

local camera = workspace.CurrentCamera


uis.InputBegan:Connect(function(inp, p)
	if p then return end
	
	if inp.KeyCode == Enum.KeyCode.Q then
		
		game.ReplicatedStorage.LightAttackRE:FireServer(mouse.Hit)
	end
end)


game.ReplicatedStorage.LightAttackRE.OnClientEvent:Connect(function()
	
	local x = math.random(-100, 100) / 1000
	local y = math.random(-100, 100) / 1000
	local z = math.random(-100, 100) / 1000

	script.Parent.Humanoid.CameraOffset = Vector3.new(x, y, z)
	camera.CFrame *= CFrame.Angles(x / 100, y / 100, z / 100)
	
	wait(1)
	
	script.Parent.Humanoid.CameraOffset = Vector3.new()
end)