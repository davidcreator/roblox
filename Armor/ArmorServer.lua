--Types of armor
local armorTypes = {
	"Head";
	"Torso";
	"Hands";
	"Legs";
	"Feet";
}

--Modules
local equipFunc = require(script:WaitForChild("EquipArmor"))
local removeFunc = require(script:WaitForChild("RemoveArmor"))
local deleteFunc = require(script:WaitForChild("DeleteArmor"))

--RemoteEvents
local remotes = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents")
local equipRE = remotes:WaitForChild("EquipArmor")
local removeRE = remotes:WaitForChild("RemoveArmor")
local deleteRE = remotes:WaitForChild("DeleteArmor")

--Other variables
local armorpieces = game:GetService("ReplicatedStorage"):WaitForChild("ArmorPieces")


--Data handling
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("PLAYER ARMOR DATA")


function saveData(plr:Player)

	if not plr:FindFirstChild("DATA FAILED TO LOAD") then

		local inventory = {}
		for _, armor in pairs(plr.ArmorInventory:GetChildren()) do
			table.insert(inventory, armor.Name)
		end
		local equipped = {}
		for _, armor in pairs(plr.ArmorEquipped:GetChildren()) do
			if armor.Value ~= nil then
				equipped[armor.Name] = armor.Value.Name
			else
				equipped[armor.Name] = nil
			end
		end
		local compiledData = {
			Inventory = inventory;
			Equipped = equipped;
		}

		local success, err = nil, nil
		while not success do
			success, err = pcall(function()
				ds:SetAsync(plr.UserId, compiledData)
			end)
			if err then
				warn(err)
			end
			task.wait(0.02)
		end
	end
end


game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for _, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)

game.Players.PlayerAdded:Connect(function(plr)
	
	local dataFailedWarning = Instance.new("StringValue")
	dataFailedWarning.Name = "DATA FAILED TO LOAD"
	dataFailedWarning.Parent = plr

	local success, armorData = nil, nil
	while not success do
		success, armorData = pcall(function()
			return ds:GetAsync(plr.UserId)
		end)
		task.wait(0.02)
	end
	dataFailedWarning:Destroy()
	
	if not armorData then
		armorData = {
			Inventory = {"Basic Shoes", "Basic Pants", "Basic Top", "Basic Gloves", "Basic Hat"}; --Armor you will start with
			Equipped = {};
		}
	end

	local inv = Instance.new("Folder")
	inv.Name = "ArmorInventory"
	inv.Parent = plr
	
	for _, armorName in pairs(armorData.Inventory) do
		
		for __, armorpiece in pairs(armorpieces:GetDescendants()) do
			if armorpiece.Name == armorName and armorpiece.Parent.Parent == armorpieces then 
				armorpiece:Clone().Parent = inv
				break
			end
		end
	end
	
	local equipped = Instance.new("Folder")
	equipped.Name = "ArmorEquipped"
	equipped.Parent = plr
	
	for _, armorType  in pairs(armorTypes) do
		local armorValue = Instance.new("ObjectValue")
		armorValue.Name = armorType
		armorValue.Parent = equipped
	end
	
	for armortype, armorname in pairs(armorData.Equipped) do
		if armorname then
			equipFunc(plr, armortype, armorname)
		end
	end
	
	plr.CharacterAdded:Connect(function()
		for _, armorValue in pairs(equipped:GetChildren()) do
			if armorValue.Value ~= nil then
				equipFunc(plr, armorValue.Name, armorValue.Value.Name, true)
			end
		end
	end)
end)


--Listening to RemoteEvents
equipRE.OnServerEvent:Connect(equipFunc)
removeRE.OnServerEvent:Connect(removeFunc)
deleteRE.OnServerEvent:Connect(deleteFunc)