local uis = game:GetService("UserInputService")


local combo = {game.ReplicatedStorage.CombatAnimations:WaitForChild("RPunch"), 
			   game.ReplicatedStorage.CombatAnimations:WaitForChild("LPunch"), 
			   game.ReplicatedStorage.CombatAnimations:WaitForChild("RHook")}

local nextCombo = 1

local attacking = false



uis.InputBegan:Connect(function(inp, processed)
	
	
	if attacking or processed then return end
	
	
	if inp.KeyCode == Enum.KeyCode.F then
		
		
		attacking = true	
		
		
		if nextCombo > #combo then 
			nextCombo = 1
		end

		
		local currentAttack = nextCombo
		
		nextCombo += 1
		
		
		local loadedAnim = script.Parent.Humanoid:LoadAnimation(combo[currentAttack])
		
		loadedAnim:Play()
		
		loadedAnim.Stopped:Wait()
		
		
		if nextCombo > 3 then
			wait(0.2)
		end
		
		
		attacking = false
		
		wait(2)
		
		
		if nextCombo == currentAttack + 1 then
			
			nextCombo = 1
		end
	end
end)