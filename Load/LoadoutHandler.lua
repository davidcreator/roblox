local weaponsFolder = game.ReplicatedStorage:WaitForChild("Weapons")
local weaponTypes = {weaponsFolder.Primary, weaponsFolder.Secondary, weaponsFolder.Melee}


local loadout = script.Parent:WaitForChild("Loadout")
loadout.Visible = false


local primary = nil
local secondary = nil
local melee = nil


local function updateLoadout()
	
	loadout.WeaponsEquipped.Text = ""
	
	if primary then
		loadout.WeaponsEquipped.Text = "Primary: " .. primary.Name
		game.ReplicatedStorage.EquipWeaponRE:FireServer(primary)
	end
	
	if secondary then
		loadout.WeaponsEquipped.Text = loadout.WeaponsEquipped.Text .. "\nSecondary: " .. secondary.Name
		game.ReplicatedStorage.EquipWeaponRE:FireServer(secondary)
	end
	
	if melee then
		loadout.WeaponsEquipped.Text = loadout.WeaponsEquipped.Text .. "\nMelee: " .. melee.Name
		game.ReplicatedStorage.EquipWeaponRE:FireServer(melee)
	end
end
updateLoadout()


for i, weaponType in pairs(weaponTypes) do
	
	local newButton = script.WeaponTypeButton:Clone()
	newButton.Text = weaponType.Name
	
	newButton.Parent = loadout.WeaponTypes
	
	
	newButton.MouseButton1Click:Connect(function()
		
		for i, child in pairs(loadout.WeaponsList:GetChildren()) do
			
			if child:IsA("TextButton") then child:Destroy() end
		end
		
		
		for i, weaponChild in pairs(weaponType:GetChildren()) do
			
			local newWeaponButton = script.WeaponButton:Clone()
			newWeaponButton.Text = weaponChild.Name
			
			newWeaponButton.Parent = loadout.WeaponsList
			
			
			newWeaponButton.MouseButton1Click:Connect(function()
				
				if weaponType.Name == "Primary" then
					primary = weaponChild
					
				elseif weaponType.Name == "Secondary" then
					secondary = weaponChild
					
				elseif weaponType.Name == "Melee" then
					melee = weaponChild
				end
				
				updateLoadout()
			end)
		end
	end)
end



script.Parent:WaitForChild("ToggleLoadoutGui").MouseButton1Click:Connect(function()
	
	loadout.Visible = not loadout.Visible
end)