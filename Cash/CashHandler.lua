local chars = game.ReplicatedStorage:WaitForChild("Characters")

local classNames = {"Accessory", "Shirt", "Pants", "ShirtGraphic", "BodyColors"}


game.Players.PlayerAdded:Connect(function(plr)
	
	local ls = Instance.new("Folder", plr)
	ls.Name = "leaderstats"
	
	local cash = Instance.new("IntValue", ls)
	cash.Name = "Cash"
	cash.Value = 10000
	
	local chars = Instance.new("Folder", plr)
	chars.Name = "OwnedCharacters"
end)


game.ReplicatedStorage.CharacterRE.OnServerEvent:Connect(function(plr, isBuying, character)
	
	if not chars:FindFirstChild(character) then return end
	
	if isBuying and not plr.OwnedCharacters:FindFirstChild(character) then
		
		local price = chars:FindFirstChild(character).Price.Value
		local plrCash = plr.leaderstats.Cash
		
		if price <= plrCash.Value then
			
			plrCash.Value -= price
			
			chars[character]:Clone().Parent = plr.OwnedCharacters
		end
		
		
	elseif not isBuying and plr.OwnedCharacters:FindFirstChild(character) and plr.Character and plr.Character:FindFirstChild("Humanoid") then
		
		for i, descendant in pairs(plr.Character:GetDescendants()) do
			
			if table.find(classNames, descendant.ClassName) or descendant:IsA("Decal") and descendant.Parent.Name == "Head" then

				descendant:Destroy()
			end
		end
		
		
		for i, descendant in pairs(plr.OwnedCharacters[character]:GetDescendants()) do
			
			if table.find(classNames, descendant.ClassName) then
				
				descendant:Clone().Parent = plr.Character
				
			elseif descendant:IsA("Decal") and descendant.Parent.Name == "Head" then
				descendant:Clone().Parent = plr.Character.Head
			end
		end
	end
end)