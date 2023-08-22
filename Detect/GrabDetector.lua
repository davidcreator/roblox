local re = game.ReplicatedStorage:WaitForChild("OnGrabRE")


local mouse = game.Players.LocalPlayer:GetMouse()

local cam = workspace.CurrentCamera


local hrp = script.Parent:WaitForChild("HumanoidRootPart")


local target = nil

local rHeld = false


mouse.Button1Down:Connect(function()
	
	
	local mouseTarget = mouse.Target
	
	
	if mouseTarget and mouseTarget:FindFirstChild("CanGrab") then
		
		
		re:FireServer(mouseTarget)
		
		
		target = mouseTarget
	end
end)


mouse.Button1Up:Connect(function()
	
	
	re:FireServer(target, true)
end)


game:GetService("UserInputService").InputBegan:Connect(function(inp, processed)

	if not processed and inp.KeyCode == Enum.KeyCode.R and target then
		
		rHeld = true
	end
end)

game:GetService("UserInputService").InputEnded:Connect(function(inp)
	
	if inp.KeyCode == Enum.KeyCode.R then
		
		rHeld = false
	end
end)


game:GetService("RunService").Heartbeat:Connect(function()
	
	
	if target and target.CanGrab.Value == script.Parent.Name then
		
		
		local pos = hrp.Position + (mouse.Hit.Position - hrp.Position).Unit * 15
		
		target.BodyPosition.Position = pos
		
		target.BodyGyro.CFrame = target.CFrame
		
		
		if rHeld then
			
			target.BodyGyro.CFrame = target.BodyGyro.CFrame * CFrame.Angles(0, 0.1, 0)
		end
	end
end)