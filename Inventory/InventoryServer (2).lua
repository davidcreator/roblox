local hotbarSlots = 9


local rs = game:GetService("ReplicatedStorage"):WaitForChild("InventoryReplicatedStorage")
local remotes = rs:WaitForChild("RemoteEvents")


game.Players.PlayerAdded:Connect(function(plr:Player)

	local inventory = Instance.new("Folder")
	inventory.Name = "Inventory"
	inventory.Parent = plr
	
	local hotbar = Instance.new("Folder")
	hotbar.Name = "Hotbar"
	hotbar.Parent = plr
	
	for slotNum = 1, hotbarSlots do
		local newSlot = Instance.new("ObjectValue")
		newSlot.Name = slotNum
		
		newSlot.Parent = hotbar
	end
	
	local equipped = Instance.new("ObjectValue")
	equipped.Name = "Equipped"
	equipped.Parent = plr
	
	
	plr.CharacterAdded:Connect(function(char)
		
		local backpack = plr.Backpack
		
		for slotNum, tool in pairs(backpack:GetChildren()) do
			if slotNum <= hotbarSlots then
				hotbar[slotNum].Value = tool
			else
				break
			end
		end
		
		backpack.ChildAdded:Connect(function(child)
			
			for _, slot in pairs(hotbar:GetChildren()) do
				if slot.Value == child then return end
			end
			
			if child:IsA("Tool") then
				
				if #backpack:GetChildren() <= hotbarSlots then
					hotbar[#backpack:GetChildren()].Value = child
					
				else
					local newItemValue = Instance.new("ObjectValue")
					newItemValue.Value = child
					newItemValue.Name = child.Name
					newItemValue.Parent = inventory
				end
			end
		end)
		
		char.ChildAdded:Connect(function(child)
			
			if child:IsA("Tool") and equipped.Value ~= child then
				
				for _, slot in pairs(hotbar:GetChildren()) do
					if slot.Value == child then return end
				end
				
				local firstFreeSlot = nil
				for slotNum, slot in pairs(hotbar:GetChildren()) do

					if not slot.Value then
						firstFreeSlot = slot
						break

					elseif slotNum == hotbarSlots then

						for slotNumber, slotValue in pairs(hotbar:GetChildren()) do

							if slotNumber > 1 then
								hotbar[slotNumber - 1].Value = slotValue.Value
							else
								local newItemValue = Instance.new("ObjectValue")
								newItemValue.Value = slotValue.Value
								newItemValue.Name = slotValue.Value.Name
								newItemValue.Parent = inventory
							end
						end

						firstFreeSlot = hotbar[hotbarSlots]
					end
				end
				
				firstFreeSlot.Value = child
				
				equipped.Value = child
				
				child.Unequipped:Wait()

				if not plr.Character:FindFirstChildOfClass("Tool") then
					equipped.Value = nil
				end

				if child.Parent ~= plr.Backpack then

					for slotNum, slot in pairs(hotbar:GetChildren()) do
						if slot.Value == child then

							local occupiedSlots = 0
							for slotNumber, slotValue in pairs(hotbar:GetChildren()) do
								if slotValue.Value then
									occupiedSlots += 1
								end
							end

							slot.Value = nil

							if slotNum < occupiedSlots then

								for slotNumber, slotValue in pairs(hotbar:GetChildren()) do
									if slotNumber > slotNum and slotValue.Value then
										hotbar[slotNumber - 1].Value = slotValue.Value
										slotValue.Value = nil
									end
								end
							end

							break
						end
					end
				end
			end
		end)
	end)
end)


remotes.Equip.OnServerEvent:Connect(function(plr:Player, toolToEquip:Tool)
	
	if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 then return end
	
	local hotbar = plr.Hotbar
	local equippedVal = plr.Equipped
	
	if toolToEquip and toolToEquip:IsA("Tool") then
		
		if toolToEquip.Parent == plr.Backpack then

			if equippedVal.Value then
				equippedVal.Value.Parent = plr.Backpack
			end
			
			equippedVal.Value = toolToEquip
			toolToEquip.Parent = plr.Character
			
		elseif toolToEquip.Parent == plr.Character then
			
			equippedVal.Value.Parent = plr.Backpack
			equippedVal.Value = nil
		end
		
		toolToEquip.Unequipped:Wait()
		
		if not plr.Character:FindFirstChildOfClass("Tool") then
			equippedVal.Value = nil
		end
		
		if toolToEquip.Parent ~= plr.Backpack then
			
			for slotNum, slot in pairs(hotbar:GetChildren()) do
				if slot.Value == toolToEquip then

					local occupiedSlots = 0
					for slotNumber, slotValue in pairs(hotbar:GetChildren()) do
						if slotValue.Value then
							occupiedSlots += 1
						end
					end

					slot.Value = nil

					if slotNum < occupiedSlots then

						for slotNumber, slotValue in pairs(hotbar:GetChildren()) do
							if slotNumber > slotNum and slotValue.Value then
								hotbar[slotNumber - 1].Value = slotValue.Value
								slotValue.Value = nil
							end
						end
					end

					break
				end
			end
		end
		
	elseif not toolToEquip then
		
		if equippedVal.Value then
			equippedVal.Value.Parent = plr.Backpack
			equippedVal.Value = nil
		end
	end
end)

remotes.Drop.OnServerEvent:Connect(function(plr:Player, toolToDrop:Tool)

	if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 then return end

	local backpack = plr.Backpack
	local inventory = plr.Inventory
	
	if toolToDrop and toolToDrop:IsA("Tool") and toolToDrop.Parent == backpack then
		
		for _, toolVal in pairs(inventory:GetChildren()) do
			if toolVal.Value == toolToDrop then
				toolVal:Destroy()
				break
			end
		end
		
		toolToDrop.Parent = workspace
		toolToDrop.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame + plr.Character.HumanoidRootPart.CFrame.LookVector * 6
	end
end)


remotes.ToHotbar.OnServerEvent:Connect(function(plr:Player, toolToHotbar:Tool)
	
	if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 then return end
	
	local backpack = plr.Backpack
	local hotbar = plr.Hotbar
	local inventory = plr.Inventory
	
	if toolToHotbar and toolToHotbar:IsA("Tool") and toolToHotbar.Parent == backpack then
		
		local firstFreeSlot = nil
		for slotNum, slot in pairs(hotbar:GetChildren()) do
			
			if not slot.Value then
				firstFreeSlot = slot
				break
				
			elseif slotNum == hotbarSlots then
				
				for slotNumber, slotValue in pairs(hotbar:GetChildren()) do
					
					if slotNumber > 1 then
						hotbar[slotNumber - 1].Value = slotValue.Value
					else
						local newItemValue = Instance.new("ObjectValue")
						newItemValue.Value = slotValue.Value
						newItemValue.Name = slotValue.Value.Name
						newItemValue.Parent = inventory
					end
				end

				firstFreeSlot = hotbar[hotbarSlots]
			end
		end
		
		for _, toolVal in pairs(inventory:GetChildren()) do
			if toolVal.Value == toolToHotbar then
				
				firstFreeSlot.Value = toolVal.Value
				toolVal:Destroy()
			end
		end
	end
end)

remotes.ToInventory.OnServerEvent:Connect(function(plr:Player, toolToInventory:Tool)
	
	if not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Health == 0 then return end
	
	local backpack = plr.Backpack
	local hotbar = plr.Hotbar
	local inventory = plr.Inventory
	
	if toolToInventory and toolToInventory:IsA("Tool") and (toolToInventory.Parent == backpack or toolToInventory.Parent == plr.Character) then
		
		if toolToInventory.Parent == plr.Character then
			toolToInventory.Parent = backpack
		end
		
		for slotNum, slot in pairs(hotbar:GetChildren()) do
			if slot.Value == toolToInventory then
	
				local occupiedSlots = 0
				for slotNumber, slotValue in pairs(hotbar:GetChildren()) do
					if slotValue.Value then
						occupiedSlots += 1
					end
				end
				
				slot.Value = nil
				
				if slotNum < occupiedSlots then
					
					for slotNumber, slotValue in pairs(hotbar:GetChildren()) do
						if slotNumber > slotNum and slotValue.Value then
							hotbar[slotNumber - 1].Value = slotValue.Value
							slotValue.Value = nil
						end
					end
				end
				
				local newItemValue = Instance.new("ObjectValue")
				newItemValue.Value = toolToInventory
				newItemValue.Name = toolToInventory.Name
				newItemValue.Parent = inventory
				
				break
			end
		end
	end
end)