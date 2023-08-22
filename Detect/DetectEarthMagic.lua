local re = game.ReplicatedStorage:WaitForChild("EarthMagicRE")


local mouse = game.Players.LocalPlayer:GetMouse()


local uis = game:GetService("UserInputService")



uis.InputBegan:Connect(function(inp, processed)

	if processed then return end


	if inp.KeyCode == Enum.KeyCode.J then


		re:FireServer(mouse.Hit)
	end
end)