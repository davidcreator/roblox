local cooldown = false


script.Parent.Activated:Connect(function()
	
	if cooldown then return end
	
	cooldown = true
	
	
	local ray = Ray.new(script.Parent.Parent.HumanoidRootPart.Position, script.Parent.Parent.HumanoidRootPart.Position + script.Parent.Parent.HumanoidRootPart.CFrame.LookVector * 5)
	
	local part = workspace:FindPartOnRay(ray, script.Parent.Parent)
	
	
	if part then
		
		local humanoid = part.Parent:FindFirstChild("Humanoid") or part.Parent.Parent:FindFirstChild("Humanoid")
		
		if humanoid then
			
			humanoid.Parent.HumanoidRootPart.Velocity = script.Parent.Parent.HumanoidRootPart.CFrame.LookVector * 100 + Vector3.new(0, 50, 0)
		end
	end
	
	
	wait(1)
	
	cooldown = false
end)