local re = workspace.EggIncubator.HatchRE

local egg = workspace.EggIncubator.Egg

local eggShakeFolder = workspace.EggIncubator.EggShakeFrames


re.OnClientEvent:Connect(function(chosenPet, rarityColour)
	
	for i = 1, #eggShakeFolder:GetChildren() do
		
		game.TweenService:Create(egg, TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut), {CFrame = eggShakeFolder:GetChildren()[i].CFrame}):Play()
		wait(0.2)
	end
	
	egg.Transparency = 1
	
	
	egg.HatchedPetInfo.PetName.Text = chosenPet.Name
	egg.HatchedPetInfo.PetRarity.Text = chosenPet.Rarity.Value
	
	egg.HatchedPetInfo.PetRarity.TextColor3 = rarityColour
	
	egg.HatchedPetInfo.Enabled = true
	
	
	local petClone = chosenPet:Clone()
	petClone.CFrame = egg.CFrame
	
	petClone.Parent = workspace
	
	
	re:FireServer()
	
	
	wait(2)
	
	
	egg.HatchedPetInfo.Enabled = false
	egg.Transparency = 0
	petClone:Destroy()
end)