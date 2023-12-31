local rs = game.ReplicatedStorage:WaitForChild("MiningSimulatorReplicatedStorage")
local re = rs:WaitForChild("RemoteEvent")

local pickaxes = rs:WaitForChild("Pickaxes")
local backpacks = rs:WaitForChild("Backpacks")

local moduleScripts = rs:WaitForChild("CONFIGURATION")
local stonesConfig = require(moduleScripts:WaitForChild("Stones"))
local oresConfig = require(moduleScripts:WaitForChild("Ores"))
local pickaxesConfig = require(moduleScripts:WaitForChild("Pickaxes"))
local backpacksConfig = require(moduleScripts:WaitForChild("Backpacks"))
local otherConfig = require(moduleScripts:WaitForChild("OtherSettings"))

local guiTemplates = rs:WaitForChild("GuiTemplates")
local displayModelPositions = rs:WaitForChild("DisplayModelPositions")

local areas = workspace:WaitForChild("MiningSimulatorAreas")


local client = game.Players.LocalPlayer
local char = script.Parent
local mouse = client:GetMouse()

local backpack = client:WaitForChild("Backpack")

local pickaxeValue = client:WaitForChild("Equipment"):WaitForChild("Pickaxe")
local backpackValue = client:WaitForChild("Equipment"):WaitForChild("Backpack")

local backpackContents = client:WaitForChild("BackpackContents")

local plrGui = client:WaitForChild("PlayerGui")
local oreGui = plrGui:WaitForChild("OreGui")
local backpackGui = plrGui:WaitForChild("BackpackGui")
local shopGui = plrGui:WaitForChild("ShopGui")
local surfaceGui = plrGui:WaitForChild("TpToSurfaceGui")
local failedDataWarning = plrGui:WaitForChild("FailedToLoadDataWarning")
oreGui.Enabled, shopGui.Enabled, failedDataWarning.Enabled, backpackGui.Enabled, surfaceGui.Enabled = false, false, false, true, true


--Backpack Gui
function updateBackpackGui()
	repeat 
		task.wait(0.1)
	until backpackValue.Value ~= nil
	
	local backpackStorage = backpacksConfig[backpackValue.Value].storage
	
	local totalBackpackContents = 0
	for i, oreValue in pairs(backpackContents:GetChildren()) do
		totalBackpackContents += oreValue.Value
	end
	
	local yScale = totalBackpackContents / backpackStorage
	backpackGui.BarBG.Bar:TweenSize(UDim2.new(1, 0, yScale, 0), "InOut", "Linear", 0.3)
	
	backpackGui.BarBG.CurrentBackpackFill.Text = totalBackpackContents .. "/" .. backpackStorage
	backpackGui.BarBG.CurrentBackpackFill.Position = UDim2.new(2.92, 0, 1 - yScale, 0)
end
updateBackpackGui()
for ore, config in pairs(oresConfig) do
	local oreValue = backpackContents:WaitForChild(ore)
	oreValue:GetPropertyChangedSignal("Value"):Connect(updateBackpackGui)
end
for ore, config in pairs(stonesConfig) do
	local oreValue = backpackContents:WaitForChild(ore)
	oreValue:GetPropertyChangedSignal("Value"):Connect(updateBackpackGui)
end
backpackValue:GetPropertyChangedSignal("Value"):Connect(updateBackpackGui)


--Hovering over ores
local currentSelectionBox = nil

game:GetService("RunService").Heartbeat:Connect(function()
	mouse.TargetFilter = areas:WaitForChild("OreZone")
	local target = mouse.Target
	
	local pickaxe = char:FindFirstChildOfClass("Tool")
	
	if target and target.Parent == workspace:WaitForChild("SPAWNED ORES FOLDER") and (char.HumanoidRootPart.Position - target.Position).Magnitude <= otherConfig.MaxOreRange and pickaxe and pickaxe.Name == pickaxeValue.Value then
		
		if not currentSelectionBox or currentSelectionBox.Parent == nil then
			currentSelectionBox = Instance.new("SelectionBox")
		end
		currentSelectionBox.Adornee = target
		currentSelectionBox.Parent = target
				
		local oreName = target.Name
		local oreHealth = target.HEALTH.Value
		local oreMaxHealth = oresConfig[oreName] and oresConfig[oreName].health or stonesConfig[oreName].health
			
		oreGui.BarBG.OreName.Text = oreName
		oreGui.BarBG.CurrentHealth.Text = oreHealth .. "/" .. oreMaxHealth
				
		local xScale = oreHealth / oreMaxHealth
		if oreHealth < oreMaxHealth then
			oreGui.BarBG.Bar:TweenSize(UDim2.new(xScale, 0, 1, 0), "InOut", "Linear", 0.3)
		else
			oreGui.BarBG.Bar.Size = UDim2.new(xScale, 0, 1, 0)
		end
				
		oreGui.Enabled = true

	elseif currentSelectionBox then
		currentSelectionBox:Destroy()
		oreGui.Enabled = false
	end
end)


--Clicking on ores
mouse.Button1Up:Connect(function()
	mouse.TargetFilter = areas:WaitForChild("OreZone")
	
	local pickaxe = char:FindFirstChild(pickaxeValue.Value)
	if pickaxe then
		
		local target = mouse.Target
		if target and target.Parent == workspace:WaitForChild("SPAWNED ORES FOLDER") then
			
			re:FireServer("MINE ORE", {target})
		end
	end
end)


--SHOPS
local currentShop = nil


function displayItem(itemName)
	local item = pickaxes:FindFirstChild(itemName) or backpacks:FindFirstChild(itemName)
	
	if currentShop and item then
		
		shopGui.ItemName.Text = itemName
		
		local vpf = shopGui.ItemViewer
		vpf:ClearAllChildren()
		
		local vpfCam = Instance.new("Camera")
		vpf.CurrentCamera = vpfCam
		vpfCam.Parent = vpf
		
		local displayModel = Instance.new("Model")
		displayModel.Parent = vpf
		
		for i, descendant in pairs(item:GetDescendants()) do
			if descendant:IsA("BasePart") then
				local clonedPart = descendant:Clone()
				clonedPart.Parent = displayModel
			end
		end
		displayModel.PrimaryPart = 
			displayModel:FindFirstChild(displayModelPositions.Pickaxe.PrimaryPart.Name)
			or displayModel:FindFirstChild(displayModelPositions.Backpack.PrimaryPart.Name)
			or displayModel:FindFirstChild("Handle")
			or displayModel:FindFirstChild("RootAttachment")
			or displayModel:FindFirstChildOfClass("BasePart")
		
		displayModel:SetPrimaryPartCFrame(
				displayModelPositions.Pickaxe:FindFirstChild(displayModel.PrimaryPart.Name) and displayModelPositions.Pickaxe.PrimaryPart.CFrame
				or displayModelPositions.Backpack:FindFirstChild(displayModel.PrimaryPart.Name) and displayModelPositions.Backpack.PrimaryPart.CFrame
				or CFrame.new(0, 0, -10)
		)
		vpfCam.CFrame = displayModelPositions.Pickaxe:FindFirstChild(displayModel.PrimaryPart.Name) and displayModelPositions.Pickaxe["CAMERA REFERENCE"].CFrame
			or displayModelPositions.Backpack:FindFirstChild(displayModel.PrimaryPart.Name) and displayModelPositions.Backpack["CAMERA REFERENCE"].CFrame
			or CFrame.new(0, 0, 0)
		
		if itemName == pickaxeValue.Value or itemName == backpackValue.Value then
			shopGui.BuyButton.Text = "Using"
			shopGui.BuyButton.BackgroundColor3 = Color3.fromRGB(58, 134, 54)
		else
			shopGui.BuyButton.Text = "Buy for $" .. (pickaxesConfig[itemName] and pickaxesConfig[itemName].cost or backpacksConfig[itemName].cost)
			shopGui.BuyButton.BackgroundColor3 = Color3.fromRGB(64, 208, 86)
		end
			
		for i, child in pairs(shopGui.StatsFrame.StatsContainer:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		
		if currentShop == "PICKAXE" then
			local damageStat = guiTemplates:WaitForChild("StatisticFrame"):Clone()
			damageStat.StatisticName.Text = "Damage:"
			damageStat.StatisticValue.Text = pickaxesConfig[itemName].damage
			damageStat.Parent = shopGui.StatsFrame.StatsContainer
			
			local multiplierStat = guiTemplates:WaitForChild("StatisticFrame"):Clone()
			multiplierStat.StatisticName.Text = "Multiplier:"
			multiplierStat.StatisticValue.Text = "x" .. pickaxesConfig[itemName].multiplier
			multiplierStat.Parent = shopGui.StatsFrame.StatsContainer
			
			local cooldownStat = guiTemplates:WaitForChild("StatisticFrame"):Clone()
			cooldownStat.StatisticName.Text = "Cooldown:"
			cooldownStat.StatisticValue.Text = pickaxesConfig[itemName].cooldown .. "s"
			cooldownStat.Parent = shopGui.StatsFrame.StatsContainer
			
		elseif currentShop == "BACKPACK" then
			local storageStat = guiTemplates:WaitForChild("StatisticFrame"):Clone()
			storageStat.StatisticName.Text = "Storage:"
			storageStat.StatisticValue.Text = backpacksConfig[itemName].storage .. " ores"
			storageStat.Parent = shopGui.StatsFrame.StatsContainer
		end
	end
end


shopGui.ExitButton.MouseButton1Click:Connect(function()
	shopGui.Enabled = false
end)

shopGui.BuyButton.MouseButton1Click:Connect(function()
	
	if currentShop then
		local selectedItem = shopGui.ItemName.Text
		if selectedItem ~= pickaxeValue.Value and selectedItem ~= backpackValue.Value then
			
			if client.leaderstats.Cash.Value >= (pickaxesConfig[selectedItem] and pickaxesConfig[selectedItem].cost or backpacksConfig[selectedItem].cost) then
				re:FireServer("BUY " .. currentShop, {selectedItem})
			end
		end
	end
end)

shopGui.LeftButton.MouseButton1Click:Connect(function()
	
	local currentItem = shopGui.ItemName.Text
	
	if currentShop == "PICKAXE" then
		
		local pickaxesByPrice = {}
		for pickaxe, config in pairs(pickaxesConfig) do
			
			if config.cost > 0 then
				table.insert(pickaxesByPrice, pickaxe)
			end
		end
		
		table.sort(pickaxesByPrice, function(a, b)
			return pickaxesConfig[a].cost < pickaxesConfig[b].cost
		end)
		
		local currentIndex = table.find(pickaxesByPrice, currentItem)
		if currentIndex and currentIndex > 1 then
			local newIndex = currentIndex - 1
			
			displayItem(pickaxesByPrice[newIndex])
		end
		
	elseif currentShop == "BACKPACK" then

		local backpacksByPrice = {}
		for backpack, config in pairs(backpacksConfig) do

			if config.cost > 0 then
				table.insert(backpacksByPrice, backpack)
			end
		end

		table.sort(backpacksByPrice, function(a, b)
			return backpacksConfig[a].cost < backpacksConfig[b].cost
		end)

		local currentIndex = table.find(backpacksByPrice, currentItem)
		if currentIndex and currentIndex > 1 then
			local newIndex = currentIndex - 1

			displayItem(backpacksByPrice[newIndex])
		end
	end
end)

shopGui.RightButton.MouseButton1Click:Connect(function()

	local currentItem = shopGui.ItemName.Text

	if currentShop == "PICKAXE" then

		local pickaxesByPrice = {}
		for pickaxe, config in pairs(pickaxesConfig) do

			if config.cost > 0 then
				table.insert(pickaxesByPrice, pickaxe)
			end
		end

		table.sort(pickaxesByPrice, function(a, b)
			return pickaxesConfig[a].cost < pickaxesConfig[b].cost
		end)

		local currentIndex = table.find(pickaxesByPrice, currentItem)
		if currentIndex and currentIndex < #pickaxesByPrice then
			local newIndex = currentIndex + 1

			displayItem(pickaxesByPrice[newIndex])
		end

	elseif currentShop == "BACKPACK" then

		local backpacksByPrice = {}
		for backpack, config in pairs(backpacksConfig) do

			if config.cost > 0 then
				table.insert(backpacksByPrice, backpack)
			end
		end

		table.sort(backpacksByPrice, function(a, b)
			return backpacksConfig[a].cost < backpacksConfig[b].cost
		end)

		local currentIndex = table.find(backpacksByPrice, currentItem)
		if currentIndex and currentIndex < #backpacksByPrice then
			local newIndex = currentIndex + 1

			displayItem(backpacksByPrice[newIndex])
		end
	end
end)


--Pickaxe shop
areas.PickaxeShopZone.Touched:Connect(function(hit)
	if hit.Parent == char and shopGui.Enabled == false then
		
		currentShop = "PICKAXE"
		
		if pickaxesConfig[pickaxeValue.Value].cost > 0 then
			displayItem(pickaxeValue.Value)
		else
			local pickaxesByPrice = {}
			for pickaxe, config in pairs(pickaxesConfig) do

				if config.cost > 0 then
					table.insert(pickaxesByPrice, pickaxe)
				end
			end
			table.sort(pickaxesByPrice, function(a, b)
				return pickaxesConfig[a].cost < pickaxesConfig[b].cost
			end)
			
			displayItem(pickaxesByPrice[1])
		end
		
		shopGui.Enabled = true
		
		while (char.HumanoidRootPart.Position - areas.PickaxeShopZone.Position).Magnitude <= areas.PickaxeShopZone.Size.Z/2 do
			task.wait(0.3)
		end
		shopGui.Enabled = false
	end
end)

--Backpack shop
areas.BackpackShopZone.Touched:Connect(function(hit)
	if hit.Parent == char and shopGui.Enabled == false then

		currentShop = "BACKPACK"
		
		if backpacksConfig[backpackValue.Value].cost > 0 then
			displayItem(backpackValue.Value)
		else
			local backpacksByPrice = {}
			for backpack, config in pairs(backpacksConfig) do

				if config.cost > 0 then
					table.insert(backpacksByPrice, backpack)
				end
			end
			table.sort(backpacksByPrice, function(a, b)
				return backpacksConfig[a].cost < backpacksConfig[b].cost
			end)

			displayItem(backpacksByPrice[1])
		end
		
		shopGui.Enabled = true
		
		while (char.HumanoidRootPart.Position - areas.BackpackShopZone.Position).Magnitude <= areas.BackpackShopZone.Size.Z/2 do
			task.wait(0.3)
		end
		shopGui.Enabled = false
	end
end)


--TP to surface gui
surfaceGui.SurfaceButton.MouseButton1Click:Connect(function()
	char.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 10, 0)
end)


--Server requests to this client
re.OnClientEvent:Connect(function(instruction)
	
	if instruction == "FAILED TO LOAD DATA" then
		plrGui.FailedToLoadDataWarning.Enabled = true
	end
end)