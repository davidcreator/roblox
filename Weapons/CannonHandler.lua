local shootPoint = script.Parent:WaitForChild("ShootPoint")
local trigger = script.Parent:WaitForChild("Trigger")


local ball = game.ServerStorage:WaitForChild("CannonBall")


local cooldown = 3
local isCooldown = false



trigger:WaitForChild("ClickDetector").MouseClick:Connect(function()
	
	
	if isCooldown then return end
	isCooldown = true
	
	
	local ballClone = ball:Clone()
	
	ballClone.CFrame = shootPoint.CFrame
	
	local bv = Instance.new("BodyVelocity")
	bv.Velocity = shootPoint.CFrame.LookVector * 500
	bv.Parent = ballClone
	
	ballClone.Parent = workspace
	
	
	shootPoint:WaitForChild("GunSound"):Play()
	
	
	local hitCharacters = {}
	
	ballClone.Touched:Connect(function(touched)
		
		if touched.Parent ~= script.Parent and touched.Parent.Parent ~= script.Parent then
			
			
			local humanoid = touched.Parent:FindFirstChild("Humanoid") or touched.Parent.Parent:FindFirstChild("Humanoid")
			
			if humanoid and not hitCharacters[humanoid.Parent] then
				
				hitCharacters[humanoid.Parent] = true
				
				
				humanoid:TakeDamage(80)
			end
			
			ballClone:Destroy()
		end
	end)
	
	
	wait(0.1)
	bv:Destroy()
	
	
	wait(cooldown - 0.1)
	isCooldown = false
	hitCharacters = {}
end)