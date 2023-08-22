--Saving data
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("CharactersDataStore")

function saveData(plr)
	local cash = plr.leaderstats.Cash.Value
	local equippedChar = plr.EquippedCharacter.Value

	local ownedCharacters = {}

	for i, character in pairs(plr.OwnedCharacters:GetChildren()) do
		table.insert(ownedCharacters, character.Name)
	end

	ds:SetAsync(plr.UserId, {cash, ownedCharacters, equippedChar})
end

game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for i, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)

--Changing characters
function changeCharacter(player, character)

	local oldCharacter = player.Character
	local newCharacter = character:Clone()
	wait()
	newCharacter.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
	newCharacter.HumanoidRootPart.Anchored = false
	newCharacter.Name = player.Character.Name
	
	for i, child in pairs(game.ReplicatedStorage.PlayerCharacters[player.Name]:GetChildren()) do
		if child:IsA("LocalScript") or child:IsA("Script") then
			child:Clone().Parent = newCharacter
		end
	end
	
	player.Character = newCharacter

	newCharacter.Parent = workspace
	oldCharacter:Destroy()
end

--Loading data
local charactersFolder = game.ReplicatedStorage:WaitForChild("Characters")

game.Players.PlayerAdded:Connect(function(plr)

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = ls

	local ownedCharacters = Instance.new("Folder")
	ownedCharacters.Name = "OwnedCharacters"
	ownedCharacters.Parent = plr
	
	local equippedCharacter = Instance.new("StringValue")
	equippedCharacter.Name = "EquippedCharacter"
	equippedCharacter.Parent = plr

	local savedCash = 1000 --Starting cash for new players
	local savedCharacters = {}
	
	--Spawn player as their equipped character
	local debounce = false
	plr.CharacterAdded:Connect(function(char)
		
		if not game.ReplicatedStorage:WaitForChild("PlayerCharacters"):FindFirstChild(plr.Name) then
			wait()
			char.Archivable = true
			char:Clone().Parent = game.ReplicatedStorage.PlayerCharacters
		end
		
		if equippedCharacter.Value ~= "" and not debounce then
			debounce = true
			changeCharacter(plr, charactersFolder[equippedCharacter.Value])
			wait(1)
			debounce = false
		end
	end)
	
	local data = ds:GetAsync(plr.UserId)
		
	if data then
		savedCash = data[1]
		savedCharacters = data[2]
		equippedCharacter.Value = data[3]
	end

	cash.Value = savedCash

	for i, savedCharacter in pairs(savedCharacters) do
		local character = charactersFolder:WaitForChild(savedCharacter):Clone()
		character.Parent = ownedCharacters
	end
end)

--Respond to client requests
local re = game.ReplicatedStorage:WaitForChild("CharacterRE")

local playerChars = game.ReplicatedStorage:WaitForChild("PlayerCharacters")
local crates = game.ReplicatedStorage:WaitForChild("Crates")

re.OnServerEvent:Connect(function(plr, instruction, selected)
	
	if instruction == "Equip Skin" then
		
		local character = charactersFolder:FindFirstChild(selected)
		
		if character then
			plr.EquippedCharacter.Value = selected
			changeCharacter(plr, character)
		end
		
	elseif instruction == "Unequip Skin" then
		plr.EquippedCharacter.Value = ""
		changeCharacter(plr, playerChars[plr.Name])
		
	elseif instruction == "Open Crate" then
		
		local crate = crates:FindFirstChild(selected)
		if crate then
			
			local price = crate.Price.Value
			if plr.leaderstats.Cash.Value >= price then
				plr.leaderstats.Cash.Value -= price
				
				local unboxableChars = crate.UnboxableCharacters:GetChildren()
				local unboxedChar = unboxableChars[math.random(1, #unboxableChars)]
				
				unboxedChar:Clone().Parent = plr.OwnedCharacters
				
				re:FireClient(plr, "Open Crate", crate, unboxedChar)
			end
		end
	end
end)