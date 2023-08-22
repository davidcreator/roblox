local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

local tool = script.Parent

script.Parent.Equipped:Connect(function()

	game.ReplicatedStorage.ConnectM6D:FireServer(tool.BodyAttach)
	
	char.HumanoidRootPart.ToolGrip.Part0 = char.HumanoidRootPart
	char.HumanoidRootPart.ToolGrip.Part1 = tool.BodyAttach
end)

tool.Unequipped:Connect(function()

	game.ReplicatedStorage.DisconnectM6D:FireServer()
end)


tool.Activated:Connect(function()
	
	char.Humanoid:LoadAnimation(script.AnimExample):Play()
end)