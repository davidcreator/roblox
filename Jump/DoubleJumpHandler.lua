local character = script.Parent
local humanoid = character:WaitForChild("Humanoid")

local uis = game:GetService("UserInputService")

local canDoubleJump = false
local hasLanded = true


humanoid.StateChanged:Connect(function(previous, new)
	
	if new == Enum.HumanoidStateType.Jumping and hasLanded then
		
		if not canDoubleJump then canDoubleJump = true; hasLanded = false end
		
		
	elseif new == Enum.HumanoidStateType.Landed then
		
		canDoubleJump = false
		hasLanded = true
	end
end)

uis.InputBegan:Connect(function(input, processed)
	
	if processed then return end
	
	if input.KeyCode == Enum.KeyCode.Space then
		
		if canDoubleJump then
			
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			canDoubleJump = false
		end	
	end
end)