local armorModel = script.Parent:WaitForChild("Armor")

local pad = script.Parent:WaitForChild("MorphPad")


pad.Touched:Connect(function(hit)
	
	local p = game.Players:GetPlayerFromCharacter(hit.Parent)
	
	if p then
		
		if p.Character:FindFirstChild("Armor") then
			
			p.Character.Armor:Destroy()
		end
		
		
		local newHealth = armorModel.NewHealth.Value
		
		p.Character.Humanoid.MaxHealth = newHealth
		p.Character.Humanoid.Health = newHealth
		
		
		local newArmor = armorModel:Clone()
		
		
		for i, child in pairs(newArmor:GetChildren()) do
			
			
			if child:IsA("Model") then
			
				for x, descendant in pairs(child:GetDescendants()) do
					
					if descendant:IsA("BasePart") then descendant.Anchored = false end
				end
				
				
				local bodyPart = p.Character:FindFirstChild(child.Name)
				
				child:SetPrimaryPartCFrame(bodyPart.CFrame)
				
				
				local weld = Instance.new("WeldConstraint", child.PrimaryPart)
				
				weld.Part0 = bodyPart
				weld.Part1 = child.PrimaryPart
			end
		end
		
		newArmor.Parent = p.Character
	end
end)