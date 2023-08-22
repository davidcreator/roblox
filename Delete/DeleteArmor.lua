function removeFunc(plr:Player, armor:string) --Permanently deleting armor from a player's inventory
	
	local char = plr.Character
	
	if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
		
		local inv = plr:WaitForChild("ArmorInventory")
		if inv:FindFirstChild(armor) then
			inv[armor]:Destroy()
			
		else
			local equipped = plr:WaitForChild("ArmorEquipped")
			for _, equippedValue in pairs(equipped:GetChildren()) do
				
				if equippedValue.Value.Name == armor then
					
					local healthGain = equippedValue.Value.Stats.Health.Value
					local speedGain = equippedValue.Value.Stats.Speed.Value
					char.Humanoid.MaxHealth -= healthGain
					char.Humanoid.WalkSpeed -= speedGain
					
					equippedValue.Value:Destroy()
					equippedValue.Value = nil
					
					break
				end
			end
		end
	end
end

return removeFunc
