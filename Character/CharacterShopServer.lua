local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("CharacterShopData")


function saveData(player)

	local charactersList = {}

	for i, character in pairs(player.OwnedCharacters:GetChildren()) do
		table.insert(charactersList, character.Name)
	end

	ds:SetAsync(player.UserId .. "Cash", player.leaderstats.Cash.Value)
	ds:SetAsync(player.UserId .. "Characters", charactersList)
	ds:SetAsync(player.UserId .. "LastCharacter", player.EquippedCharacter.Value)
	
	game.ReplicatedStorage.OriginalCharacters[player.Name]:Destroy()
end

function changeCharacter(player, character)
	
	local oldCharacter = player.Character
	local newCharacter = character:Clone()

	newCharacter.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
	newCharacter.HumanoidRootPart.Anchored = false
	newCharacter.Name = player.Character.Name
	player.Character = newCharacter
	
	for i, child in pairs(game.ReplicatedStorage.OriginalCharacters[player.Name]:GetChildren()) do
		if child:IsA("LocalScript") or child:IsA("Script") then
			child:Clone().Parent = newCharacter
		end
	end
	
	newCharacter.Parent = workspace
	oldCharacter:Destroy()
end


game.Players.PlayerAdded:Connect(function(player)

	local charFolder = Instance.new("Folder")
	charFolder.Name = "OwnedCharacters"
	charFolder.Parent = player

	local equippedChar = Instance.new("StringValue")
	equippedChar.Name = "EquippedCharacter"
	equippedChar.Parent = player

	local lastCharSaved = ds:GetAsync(player.UserId .. "LastCharacter")
	equippedChar.Value = lastCharSaved or ""

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = player

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = ls

	local savedCash = ds:GetAsync(player.UserId .. "Cash") or 10000
	cash.Value = savedCash

	local savedCharacters = ds:GetAsync(player.UserId .. "Characters") or {}

	for i, character in pairs(savedCharacters) do
		if game.ReplicatedStorage:WaitForChild("CharactersFolder"):FindFirstChild(character) then
			game.ReplicatedStorage.CharactersFolder[character]:Clone().Parent = charFolder
		end
	end
	
	if not player.Character then player.CharacterAdded:Wait() end
	player.Character.Archivable = true
	local originalCharacter = player.Character:Clone()
	originalCharacter.Parent = game.ReplicatedStorage.OriginalCharacters
	
	if lastCharSaved and game.ReplicatedStorage.CharactersFolder:FindFirstChild(lastCharSaved) then
		changeCharacter(player, game.ReplicatedStorage.CharactersFolder[lastCharSaved])
	end
	
	local debounce = false
	player.CharacterAdded:Connect(function(char)
		if game.ReplicatedStorage.CharactersFolder:FindFirstChild(equippedChar.Value) and not debounce then
			debounce = true
			changeCharacter(player, game.ReplicatedStorage.CharactersFolder[equippedChar.Value])
			wait(1)
			debounce = false
		end
	end)
end)


game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for i, player in pairs(game.Players:GetPlayers()) do
		saveData(player)
	end
end)


game.ReplicatedStorage:WaitForChild("CharacterShopRE").OnServerEvent:Connect(function(player, character, instruction)

	if game.ReplicatedStorage.CharactersFolder:FindFirstChild(character) then
		local charRequested = game.ReplicatedStorage.CharactersFolder[character]

		if instruction == "buy" then

			if not player.OwnedCharacters:FindFirstChild(character) and player.leaderstats.Cash.Value >= charRequested.Price.Value then

				player.leaderstats.Cash.Value -= charRequested.Price.Value
				charRequested:Clone().Parent = player.OwnedCharacters
			end

		elseif instruction == "use" then

			if player.OwnedCharacters:FindFirstChild(character) then

				if player.EquippedCharacter.Value == character then	
					player.EquippedCharacter.Value = ""
					changeCharacter(player, game.ReplicatedStorage.OriginalCharacters[player.Name])

				else
					player.EquippedCharacter.Value = character
					changeCharacter(player, charRequested)
				end
			end
		end
	end
end)