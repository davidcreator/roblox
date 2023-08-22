script.Parent.Blade.Touched:Connect(function(touch)

	if script.Parent.CanDamage.Value == true then

		local humanoid = touch.Parent:FindFirstChild("Humanoid")

		if not touch.Parent:FindFirstChild("Humanoid") then 

			humanoid = touch.Parent.Parent:FindFirstChild("Humanoid")

		end

		if humanoid.Name ~= "Humanoid" then return end
		
		script.Parent.CanDamage.Value = false

		humanoid:TakeDamage(20)
		
		if humanoid.Health < 1 then
			
			local plr = game.Players:GetPlayerFromCharacter(script.Parent.Parent)
			plr.leaderstats.Kills.Value = plr.leaderstats.Kills.Value + 1
			
		end
		
		wait(1)
		
		script.Parent.CanDamage.Value = true
	end
end)