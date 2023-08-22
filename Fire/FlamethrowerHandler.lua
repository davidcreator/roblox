local particles = script.Parent:WaitForChild("Muzzle"):WaitForChild("ParticleEmitter")

particles.Enabled = false

script.Parent:WaitForChild("Hitbox").Touched:Connect(function() end)


script.Parent.Activated:Connect(function()
	
	particles.Enabled = true
	
	particles.Parent.Sound:Play()
	
	
	while particles.Enabled == true do
		
		wait(1)
		
		local parts = script.Parent.Hitbox:GetTouchingParts()
		
		local humanoidsDamaged = {}
		
		for i, part in pairs(parts) do
		
			if part.Parent:FindFirstChild("Humanoid") and not humanoidsDamaged[part.Parent.Humanoid] then
				
				humanoidsDamaged[part.Parent.Humanoid] = true
				
				part.Parent.Humanoid:TakeDamage(20)
			end
		end
	end
end)

script.Parent.Deactivated:Connect(function()
	
	particles.Enabled = false
	
	particles.Parent.Sound:Stop()
end)