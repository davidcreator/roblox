local items = game.ReplicatedStorage:WaitForChild("CharacterItems")
local re = game.ReplicatedStorage:WaitForChild("CharacterCreatorRE")

local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("DATAsss")

--Function to save data
function saveData(player)
	
	local currentItems = {}
	
	for i, item in pairs(player.CurrentItems:GetChildren()) do
		table.insert(currentItems, item.Name)
	end
	
	ds:SetAsync(player.UserId, currentItems)
end

function loadAvatar(player)
	local currentItems = player.CurrentItems
	local character = player.Character or player.CharacterAdded:Wait()
	
	for i, child in pairs(character:GetChildren()) do
		if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("Accessory") then
			child:Destroy()
		end
	end
	
	for i, item in pairs(currentItems:GetChildren()) do
		if items:FindFirstChild(item.Name, true) then
			
			if item:IsA("Shirt") then
				item:Clone().Parent = character
			elseif item:IsA("Pants") then
				item:Clone().Parent = character
			elseif item:IsA("Accessory") then
				character.Humanoid:AddAccessory(item:Clone())
			end
		end
	end
end


--Load player with last saved items
game.Players.PlayerAdded:Connect(function(player)
	
	local currentItems = Instance.new("Folder", player)
	currentItems.Name = "CurrentItems"
	
	player.CharacterAdded:Connect(function(character)
		loadAvatar(player)
	end)
	
	local data = ds:GetAsync(player.UserId) or {}
	
	for i, itemName in pairs(data) do
		if items:FindFirstChild(itemName, true) then
			local itemType = items:FindFirstChild(itemName, true):FindFirstChildOfClass("Shirt") or items:FindFirstChild(itemName, true):FindFirstChildOfClass("Pants") or items:FindFirstChild(itemName, true)
			itemType:Clone().Parent = currentItems
		end
	end
	loadAvatar(player)
end)

--Save items currently equipped by user
game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for i, player in pairs(game.Players:GetPlayers()) do
		saveData(player)
	end
end)


--Equip new items
re.OnServerEvent:Connect(function(player, itemsList)
	
	if itemsList and player.Character then
		
		for i, child in pairs(player.Character:GetChildren()) do
			if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("Accessory") then
				child:Destroy()
			end
		end
		
		player.CurrentItems:ClearAllChildren()
		
		for i, item in pairs(itemsList) do
			if items:FindFirstChild(item, true) then
				
				local newItem = items:FindFirstChild(item, true):Clone()
				
				if newItem:IsA("Shirt") then
					if player.Character:FindFirstChildOfClass("Shirt") then
						if player.CurrentItems:FindFirstChild(player.Character:FindFirstChildOfClass("Shirt").Name) then
							player.CurrentItems[player.Character:FindFirstChildOfClass("Shirt").Name]:Destroy()
						end
						player.Character:FindFirstChildOfClass("Shirt"):Destroy()
					end
					
					newItem.Parent = player.Character
					
				elseif newItem:IsA("Pants") then
					if player.Character:FindFirstChildOfClass("Pants") then
						if player.CurrentItems:FindFirstChild(player.Character:FindFirstChildOfClass("Pants").Name) then
							player.CurrentItems[player.Character:FindFirstChildOfClass("Pants").Name]:Destroy()
						end
						player.Character:FindFirstChildOfClass("Pants"):Destroy()
					end
					
					newItem.Parent = player.Character
					
				elseif newItem:IsA("Accessory") then
					player.Character.Humanoid:AddAccessory(newItem)
				end
				
				newItem:Clone().Parent = player.CurrentItems
			end
		end
	end
end)