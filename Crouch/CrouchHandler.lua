local uis = game:GetService("UserInputService")


local humanoid = script.Parent:WaitForChild("Humanoid")


local animationIdle = humanoid:LoadAnimation(script:WaitForChild("CrouchIdle"))
local animationMoving = humanoid:LoadAnimation(script:WaitForChild("CrouchMoving"))


local crouching = false


uis.InputBegan:Connect(function(inp, processed)
	
	
	if processed  then return end
	
	
	if inp.KeyCode == Enum.KeyCode.LeftControl then
		
		crouching = not crouching
	end
end)


game:GetService("RunService").Heartbeat:Connect(function()
	
	script.Parent.HumanoidRootPart.CanCollide = false
	
	
	if crouching then
		
		
		humanoid.WalkSpeed = 10
		
		animationIdle:Play()
		
		
		if humanoid.MoveDirection.Magnitude > 0 then
			
			if not animationMoving.IsPlaying then animationMoving:Play() end
			
			
		else
			
			animationMoving:Stop()
		end
		
		
	else
		
		animationIdle:Stop()
		animationMoving:Stop()
		
		humanoid.WalkSpeed = 16
	end
end)