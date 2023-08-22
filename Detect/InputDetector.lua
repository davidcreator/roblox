local uis = game:GetService("UserInputService")

local mouse = game.Players.LocalPlayer:GetMouse()

local cam = workspace.CurrentCamera


local re = game.ReplicatedStorage:WaitForChild("CreateLighting")


local holding = false



uis.InputBegan:Connect(function(inp, processed)
	
	if processed then return end
	
	
	if inp.KeyCode == Enum.KeyCode.F then
		
		holding = true
	end
end)


uis.InputEnded:Connect(function(inp)
	
	
	if inp.KeyCode == Enum.KeyCode.F then
		
		holding = false
	end
end)


game:GetService("RunService").Heartbeat:Connect(function()
	
	
	if holding then
		
		re:FireServer(mouse.Hit, cam.CFrame)
	end
end)