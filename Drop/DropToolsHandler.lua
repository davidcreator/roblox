game.Players.PlayerAdded:Connect(function(plr)
	
	local weaponsFolder = Instance.new("Folder")
	weaponsFolder.Name = "WeaponsFolder"
	weaponsFolder.Parent = plr
	
	
	plr.CharacterAdded:Connect(function(char)
	
		local backpack = plr.Backpack
		
		
		local function updateFolder()
			
			weaponsFolder:ClearAllChildren()
			
			for i, childOfBP in pairs(backpack:GetChildren()) do
				
				if childOfBP:IsA("Tool") then
					childOfBP:Clone().Parent = weaponsFolder
				end
			end	
			
			for i, childOfC in pairs(char:GetChildren()) do
				
				if childOfC:IsA("Tool") then
					childOfC:Clone().Parent = weaponsFolder
				end
			end
		end
		
		
		backpack.ChildAdded:Connect(updateFolder)
		backpack.ChildRemoved:Connect(updateFolder)
		
		char.ChildAdded:Connect(updateFolder)
		char.ChildRemoved:Connect(updateFolder)
		
		
		char.Humanoid.Died:Connect(function()
			
			for i, weapon in pairs(weaponsFolder:GetChildren()) do
				
				local weaponHandling = coroutine.create(function()
					
					local weaponHandle = weapon.Handle
				
					weaponHandle.CFrame = char.HumanoidRootPart.CFrame
					
					weaponHandle.Name = "TemporaryName"
					weapon.Parent = workspace
					
					wait(game.Players.RespawnTime + 1)
					weaponHandle.Name = "Handle"
					
					weaponHandle.Parent = nil
					weaponHandle.Parent = weapon
				end)
				
				coroutine.resume(weaponHandling)
			end
		end)
	end)
end)