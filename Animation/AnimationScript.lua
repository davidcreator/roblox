local CanAttack = true

local Sound = script.Parent:WaitForChild("SwordSwing")

script.Parent.Activated:Connect(function()

	local AttackAnim = script.Parent.Parent.Humanoid:LoadAnimation(script.Attack)
	
	
	if CanAttack == true then
	
		AttackAnim:Play()
	
		CanAttack = false
		
		Sound:Play()
	
		wait(1)
		
		AttackAnim:Stop()
		
		CanAttack = true
		
		script.Parent.CanDamage.Value = true	
	end
end)