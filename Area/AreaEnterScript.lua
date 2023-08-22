local part = script.Parent

local debounce = false


part.Touched:Connect(function(touch)
	
	if not touch.Parent:FindFirstChild("Humanoid") then return end
	
	if debounce == true then return end
	
	
	debounce = true
	
	
	local char = touch.Parent
	
	local plr = game.Players:GetPlayerFromCharacter(char)
		
		
	plr.PlayerGui.AreaEnterGui.AreaTitle:TweenPosition(UDim2.new(0.374, 0, 0.015, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)
	
	
	wait(1)
	
	
	plr.PlayerGui.AreaEnterGui.AreaTitle:TweenPosition(UDim2.new(0.374, 0, -1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.5)
		
	debounce = false
	
	
end)