local CanAttack = true

script.Parent.Activated:Connect(function()
	
	if CanAttack == true then
		
		CanAttack = false
		
		local Swing = script.Parent.Parent.Humanoid:LoadAnimation(script.Swing)
		
		Swing:Play()
		
		script.Parent.Front.Touched:Connect(function(touch)
			local player = touch.Parent
			if game:GetService("Players"):GetPlayerFromCharacter(player) then
				game.Players:GetPlayerFromCharacter(player):Kick("You have been struck by the hammer!")
			end
		end)
		wait(1)
	CanAttack = true
	end
end)