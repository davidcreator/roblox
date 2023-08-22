local flashbang = script.Parent


local mouse = game.Players.LocalPlayer:GetMouse()

local re = flashbang:WaitForChild("ThrowRE")


flashbang.Activated:Connect(function()
	
	
	re:FireServer(mouse.Hit)
end)