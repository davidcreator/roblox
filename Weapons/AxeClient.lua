local mouse = game.Players.LocalPlayer:GetMouse()

local cooldown = false

script.Parent.Activated:Connect(function()

	if not cooldown then
		cooldown = true

		script.Parent.Parent.Humanoid:LoadAnimation(script.SwingAnimation):Play()
		
		game.ReplicatedStorage:WaitForChild("AxeRE"):FireServer(mouse.Target, mouse.Hit)

		wait(1)
		cooldown = false
	end
end)