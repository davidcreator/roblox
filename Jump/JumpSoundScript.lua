local plr = game.Players.LocalPlayer


local char = plr.Character or plr.CharacterAdded:Wait()

local humanoid = char:WaitForChild("Humanoid")


local hasJumped = false


local jumpSound = script.JumpSound


humanoid.StateChanged:Connect(function(oldState, newState)
	
	
	if newState == Enum.HumanoidStateType.Jumping then
		
		
		if hasJumped then return end
		
		hasJumped = true
		
		
		jumpSound:Play()
		
		
	elseif newState == Enum.HumanoidStateType.Landed then	
		
		
		hasJumped = false
	end
end)