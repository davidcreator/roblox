local char = script.Parent
local humanoid = char:WaitForChild("Humanoid")


local mouse = game.Players.LocalPlayer:GetMouse()


mouse.Button1Down:Connect(function()
	
	local pos = mouse.Hit.Position
	
	humanoid:MoveTo(pos)
end)