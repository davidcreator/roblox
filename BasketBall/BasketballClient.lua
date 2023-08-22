local tool = script.Parent
local re = tool:WaitForChild("BasketballRE")


local mouse = game.Players.LocalPlayer:GetMouse()


tool.Activated:Connect(function()
	
	re:FireServer(mouse.Hit)
end)