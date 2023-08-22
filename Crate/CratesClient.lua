--Variables
local rs = game:GetService("ReplicatedStorage")
local remotes = rs:WaitForChild("RemoteEvents")
local rarityProperties = rs:WaitForChild("RarityProperties")
local items = rs:WaitForChild("Items")
local crates = rs:WaitForChild("Crates")

local shopGui = script.Parent:WaitForChild("CrateShopGui");shopGui.Enabled = true
local openShopBtn = shopGui:WaitForChild("OpenButton");openShopBtn.Visible = true
local shopFrame = shopGui:WaitForChild("CrateShopFrame");shopFrame.Visible = false
local closeShopBtn = shopFrame:WaitForChild("CloseButton")
local cratesList = shopFrame:WaitForChild("CratesList")
local selectedCrate = shopFrame:WaitForChild("SelectedCrate");selectedCrate.Visible = false

local openedGui = script.Parent:WaitForChild("OpenedCrateGui");openedGui.Enabled = false
local openedFrame = openedGui:WaitForChild("CrateFrame");openedFrame.Visible = false
local closeOpenedBtn = openedFrame:WaitForChild("ContinueButton")
local openedItemsFrame = openedFrame:WaitForChild("ItemsFrame")

local crateButtonTemplate = script:WaitForChild("CrateShopButton")
local selectedCrateItemTemplate = script:WaitForChild("SelectedCrateItemFrame")
local openingCrateItemTemplate = script:WaitForChild("OpeningCrateItemFrame")

local rnd = Random.new()


--Open and close buttons
openShopBtn.MouseButton1Click:Connect(function()
	if openedFrame.Visible == false then
		shopFrame.Visible = not shopFrame.Visible
	end
end)

closeShopBtn.MouseButton1Click:Connect(function()
	shopFrame.Visible = false
end)

closeOpenedBtn.MouseButton1Click:Connect(function()
	openedFrame.Visible = false
	openedGui.Enabled = false
	
	for _, child in pairs(openedItemsFrame.ItemsContainer:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
end)


--Setting up crates shop
local crateButtons = {}

for _, crate in pairs(crates:GetChildren()) do
	
	local crateProperties = require(crate)
	
	local newBtn = crateButtonTemplate:Clone()
	newBtn.Name = crate.Name
	newBtn.CrateName.Text = crate.Name
	newBtn.CrateImage.Image = crateProperties["Image"]
	
	newBtn.MouseButton1Click:Connect(function()
		
		if selectedCrate.CrateName.Text ~= crate.Name then
			
			selectedCrate.CrateName.Text = crate.Name
			selectedCrate.CrateImage.Image = crateProperties["Image"]
			selectedCrate.UnboxButton.Text = "$" .. crateProperties["Price"]
			
			local rarities = {}
			for rarityName, chance in pairs(crateProperties["Chances"]) do
				table.insert(rarities, {rarityName, chance})
			end
			table.sort(rarities, function(a, b)
				return rarityProperties[a[1]].Order.Value <rarityProperties[b[1]].Order.Value
			end)
			
			local raritiesText = ""
			for _, rarity in pairs(rarities) do
				local color = rarityProperties[rarity[1]].Color.Value
				color = {R = math.round(color.R*255); G = math.round(color.G*255); B = math.round(color.B*255)}
				raritiesText = raritiesText .. '<font color="rgb(' .. color.R .. ',' .. color.G .. ',' .. color.B .. ')">' .. rarity[1] .. ': <b>' .. rarity[2] .. '%</b></font><br />'
			end
			selectedCrate.RaritiesText.RichText = true
			selectedCrate.RaritiesText.Text = raritiesText
			
			for _, child in pairs(selectedCrate.ItemsList:GetChildren()) do
				if child:IsA("Frame") then
					child:Destroy()
				end
			end
			
			local unboxableItems = crateProperties["Items"]
			table.sort(unboxableItems, function(a, b)
				return 
					(rarityProperties[items:FindFirstChild(a, true).Parent.Name].Order.Value < rarityProperties[items:FindFirstChild(b, true).Parent.Name].Order.Value)
					or (rarityProperties[items:FindFirstChild(a, true).Parent.Name].Order.Value == rarityProperties[items:FindFirstChild(b, true).Parent.Name].Order.Value)
					and (a < b)
			end)
			
			for _, unboxableItemName in pairs(unboxableItems) do
				local newItemFrame = selectedCrateItemTemplate:Clone()
				newItemFrame.ItemName.Text = unboxableItemName
				newItemFrame.ItemName.TextColor3 = rarityProperties[items:FindFirstChild(unboxableItemName, true).Parent.Name].Color.Value
				
				local itemModel = Instance.new("Model")
				
				for _, child in pairs(items:FindFirstChild(unboxableItemName, true):GetChildren()) do
					if not (child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") or child:IsA("Sound")) then
						child:Clone().Parent = itemModel
					end
				end
				
				itemModel:PivotTo(CFrame.new() * CFrame.Angles(math.rad(-39), 0, 0))
				
				itemModel.Parent = newItemFrame.ItemImage
				
				local currentCamera = Instance.new("Camera")
				currentCamera.CFrame = CFrame.new(Vector3.new(-itemModel:GetExtentsSize().Y*0.7, 0, 0), itemModel:GetPivot().Position + Vector3.new(0, -0.1, 0))
				currentCamera.Parent = newItemFrame.ItemImage
				newItemFrame.ItemImage.CurrentCamera = currentCamera
				
				newItemFrame.Parent = selectedCrate.ItemsList
			end
			
			selectedCrate.Visible = true
		end
	end)
	
	table.insert(crateButtons, {newBtn, crateProperties["Price"]})
end

table.sort(crateButtons, function(a, b)
	return (a[2] < b[2]) or (a[2] == b[2] and a[1].Name < b[1].Name)
end)

for _, crateButton in pairs(crateButtons) do
	crateButton[1].Parent = cratesList
end


--Purchasing crates
selectedCrate.UnboxButton.MouseButton1Click:Connect(function()
	if selectedCrate.Visible == true and game.Players.LocalPlayer.leaderstats.Cash.Value >= tonumber(string.sub(selectedCrate.UnboxButton.Text, 2, -1)) then
		remotes:WaitForChild("BuyCrate"):FireServer(selectedCrate.CrateName.Text)
	end
end)


--Unboxing crates
function lerp(a, b, t)
	return a + (b-a) * t
end

function tweenGraph(x, pow)
	x = math.clamp(x, 0, 1)
	return 1 - (1-x)^pow
end


remotes:WaitForChild("CrateOpened").OnClientEvent:Connect(function(crateName, itemChosen, unboxTime)
	
	local crateProperties = require(crates[crateName])
	
	local numItems = rnd:NextInteger(20, 100)
	local chosenPosition = rnd:NextInteger(15, numItems-5)
	
	for i = 1, numItems do
		
		local rarityChosen = itemChosen.Parent.Name
		local randomItemChosen = itemChosen
		
		if i ~= chosenPosition then
			local rndChance = rnd:NextNumber() * 100
			local n = 0
			
			for rarity, chance in pairs(crateProperties["Chances"]) do	
				n += chance
				if rndChance <= n then
					rarityChosen = rarity
					break
				end
			end

			local unboxableItems = crateProperties["Items"]
			for i = #unboxableItems, 2, -1 do
				local j = rnd:NextInteger(1, i)
				unboxableItems[i], unboxableItems[j] = unboxableItems[j], unboxableItems[i]
			end
			
			for _, itemName in pairs(unboxableItems) do
				if items:FindFirstChild(itemName, true).Parent.Name == rarityChosen then
					randomItemChosen = items:FindFirstChild(itemName, true)
					break
				end
			end
		end
		
		local newItemFrame = openingCrateItemTemplate:Clone()
		newItemFrame.ItemName.Text = randomItemChosen.Name
		newItemFrame.ItemName.TextColor3 = rarityProperties[rarityChosen].Color.Value
		
		local itemModel = Instance.new("Model")

		for _, child in pairs(randomItemChosen:GetChildren()) do
			if not (child:IsA("Script") or child:IsA("LocalScript") or child:IsA("ModuleScript") or child:IsA("Sound")) then
				child:Clone().Parent = itemModel
			end
		end

		itemModel:PivotTo(CFrame.new() * CFrame.Angles(math.rad(-39), 0, 0))

		itemModel.Parent = newItemFrame.ItemImage

		local currentCamera = Instance.new("Camera")
		currentCamera.CFrame = CFrame.new(Vector3.new(-itemModel:GetExtentsSize().Y*0.7, 0, 0), itemModel:GetPivot().Position + Vector3.new(0, -0.1, 0))
		currentCamera.Parent = newItemFrame.ItemImage
		newItemFrame.ItemImage.CurrentCamera = currentCamera
		
		newItemFrame.Parent = openedItemsFrame.ItemsContainer
	end
	
	openedItemsFrame.ItemsContainer.Position = UDim2.new(0, 0, 0.5, 0)
	
	local cellSize = openingCrateItemTemplate.Size.X.Scale
	local padding = openedItemsFrame.ItemsContainer.UIListLayout.Padding.Scale
	local pos1 = 0.5 - cellSize/2
	local nextOffset = -cellSize - padding
	
	local posFinal = pos1 + (chosenPosition-1) * nextOffset
	local rndOffset = rnd:NextNumber(-cellSize/2, cellSize/2)
	posFinal += rndOffset
	
	local timeOpened = tick()
	
	openedFrame.CrateName.Text = crateName
	shopFrame.Visible = false
	closeOpenedBtn.Visible = false
	openedFrame.Visible = true
	openedGui.Enabled = true
	
	local pow = rnd:NextNumber(2, 10)
	local lastSlot = 0
	
	while true do
		local timeSinceOpened = tick() - timeOpened
		local x = timeSinceOpened / unboxTime
		
		local t = tweenGraph(x, pow)
		local newXPos = lerp(0, posFinal, t)
		
		local currentSlot = math.abs(math.floor((newXPos+rndOffset)/cellSize))+1
		if currentSlot ~= lastSlot then
			script.TickSound:Play()
			lastSlot = currentSlot
		end
		
		openedItemsFrame.ItemsContainer.Position = UDim2.new(newXPos, 0, 0.5, 0)
		
		if x >= 1 then
			break
		end
		
		game:GetService("RunService").Heartbeat:Wait()
	end
	
	closeOpenedBtn.Visible = true
end)