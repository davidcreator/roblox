local plr = game.Players.LocalPlayer

local char = plr.Character or plr.CharacterAdded:Wait()


local uis = game:GetService("UserInputService")


local isCoolingDown = false


uis.InputBegan:Connect(function(key, processed)
	
	if key.KeyCode == Enum.KeyCode.E and not processed then
		
		
		if isCoolingDown then return end
		
		
		local hrp = char:FindFirstChild("HumanoidRootPart")
		
		if not hrp then return end
		
		
		isCoolingDown = true
		
		
		hrp.Velocity = hrp.CFrame.lookVector * 300
		
		
		wait(2)
		
		
		isCoolingDown = false
		
	end	
end)