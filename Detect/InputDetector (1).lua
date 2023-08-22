local uis = game:GetService("UserInputService")

local mouse = game.Players.LocalPlayer:GetMouse()


local re = game.ReplicatedStorage:WaitForChild("IceMagicActivated")



uis.InputBegan:Connect(function(inp, processed)

	if processed then return end


	if inp.KeyCode == Enum.KeyCode.G then

		re:FireServer(mouse.Hit)
	end
end)