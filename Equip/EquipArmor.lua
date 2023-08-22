local armorpieces = game:GetService("ReplicatedStorage"):WaitForChild("ArmorPieces")


function equipFunc(plr:Player, armortype:string, armor:string, plrSpawned:boolean) --Equipping armor onto a player
	
	local char = plr.Character or plr.CharacterAdded:Wait()
	
	if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
		local inv = plr:WaitForChild("ArmorInventory")
		
		if armorpieces[armortype]:FindFirstChild(armor) then
			
			local equipped = plr:WaitForChild("ArmorEquipped")
			local currentArmor = equipped[armortype].Value
			
			if currentArmor and not plrSpawned then
				local healthGain = currentArmor.Stats.Health.Value
				local speedGain = currentArmor.Stats.Speed.Value
				char.Humanoid.MaxHealth -= healthGain
				char.Humanoid.WalkSpeed -= speedGain
				
				for _, armorpiece in pairs(armorpieces:GetDescendants()) do
					if armorpiece.Name == currentArmor.Name and armorpiece.Parent.Parent == armorpieces then
						armorpiece:Clone().Parent = inv
						break
					end
				end
				
				currentArmor:Destroy()
			end
			
			local newarmor = armorpieces[armortype][armor]:Clone()
			
			for _, pieces in pairs(newarmor:GetChildren()) do
				if pieces:IsA("Model") then
					
					pieces:PivotTo(char[pieces.Name].CFrame)
					
					local wc = Instance.new("WeldConstraint")
					wc.Part0 = char[pieces.Name]
					wc.Part1 = pieces.PrimaryPart
					wc.Parent = pieces.PrimaryPart
				end
			end
			newarmor.Parent = char
			
			equipped[armortype].Value = newarmor
			if inv:FindFirstChild(armor) then
				inv[armor]:Destroy()
			end
			
			local newHealthGain = newarmor.Stats.Health.Value
			local newSpeedGain = newarmor.Stats.Speed.Value
			char.Humanoid.MaxHealth += newHealthGain
			char.Humanoid.WalkSpeed += newSpeedGain
			
			if char.Humanoid.Health > char.Humanoid.MaxHealth then
				char.Humanoid.Health = char.Humanoid.MaxHealth
			end
		end
	end
end

return equipFunc
