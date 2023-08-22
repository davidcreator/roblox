local door = script.Parent


door.Touched:Connect(function(touch)	
	
		
	local char = touch.Parent
	
	local plr = game.Players:GetPlayerFromCharacter(char)
	
	
	if not plr then return end
	
	
	if char:FindFirstChild("Key") then
		
		
		door.Transparency = 1
		door.CanCollide = false
		
		wait(5)
		
		door.Transparency = 0
		door.CanCollide = true
		
	end
	
end)