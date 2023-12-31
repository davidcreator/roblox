local rs = game:GetService("ReplicatedStorage"):WaitForChild("CraftingReplicatedStorage")
local items = rs:WaitForChild("CraftableItems")
local allResources = rs:WaitForChild("Resources")
local remote = rs:WaitForChild("RemoteEvent")
local recipes = require(rs:WaitForChild("Recipes"))

local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("Crafting")


function saveData(plr)
	
	if not plr:FindFirstChild("DATA FAILED TO LOAD") then

		local tools = {}
		for _, tool in pairs(plr.StarterGear:GetChildren()) do
			if items:FindFirstChild(tool.Name) then
				table.insert(tools, tool.Name)
			end
		end
		
		local resources = {}
		for _, resource in pairs(plr.RESOURCES:GetChildren()) do
			resources[resource.Name] = resource.Value
		end

		local compiledData = {
			Resources = resources;
			Tools = tools;
		}

		local success, err = nil, nil
		while not success do
			success, err = pcall(function()
				ds:SetAsync(plr.UserId, compiledData)
			end)
			if err then
				warn(err)
			end
			task.wait(0.1)
		end
	end
end

function loadData(plr)
	
	local dataFailedWarning = Instance.new("StringValue")
	dataFailedWarning.Name = "DATA FAILED TO LOAD"
	dataFailedWarning.Parent = plr

	local success, plrData = nil, nil
	while not success do
		success, plrData = pcall(function()
			return ds:GetAsync(plr.UserId)
		end)
	end
	dataFailedWarning:Destroy()

	if not plrData then
		plrData = {Resources = {}; Tools = {}}
	end
	
	
	for _, toolName in pairs(plrData.Tools) do
		items[toolName]:Clone().Parent = plr.StarterGear
		if plr.Character then
			items[toolName]:Clone().Parent = plr.Backpack
		end
	end
	
	local resourcesFolder = Instance.new("Folder")
	resourcesFolder.Name = "RESOURCES"
	
	for _, resource in pairs(allResources:GetChildren()) do
		local resourceValue = Instance.new("IntValue")
		resourceValue.Name = resource.Name
		resourceValue.Value = plrData.Resources[resource.Name] or 0
		resourceValue.Parent = resourcesFolder
	end
	
	resourcesFolder.Parent = plr
end

game:GetService("Players").PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for _, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)

game.Players.PlayerAdded:Connect(function(plr)
	
	plr.CharacterAdded:Connect(function(char)
		
		local humanoid = char:WaitForChild("Humanoid")
		humanoid.Touched:Connect(function(hit)
			
			if allResources:FindFirstChild(hit.Name) then
				plr:WaitForChild("RESOURCES"):WaitForChild(hit.Name).Value += 1
				hit:Destroy()
			end
		end)
	end)
	
	loadData(plr)
end)


remote.OnServerEvent:Connect(function(plr:Player, itemToCraft:string)
	itemToCraft = items:FindFirstChild(itemToCraft)
	if itemToCraft then
		
		local recipeForItem = recipes[itemToCraft]
		if recipeForItem then
			
			for resource, amount in pairs(recipeForItem) do
				
				local plrAmount = plr.RESOURCES[resource].Value
				if plrAmount < amount then
					return
				end
			end
			
			for resource, amount in pairs(recipeForItem) do

				local resourceValue = plr.RESOURCES[resource]
				resourceValue.Value -= amount
			end
			
			itemToCraft:Clone().Parent = plr.StarterGear
			if plr.Character then
				itemToCraft:Clone().Parent = plr.Backpack
			end
			
			remote:FireClient(plr, "CRAFT SUCCESS")
		end
	end
end)