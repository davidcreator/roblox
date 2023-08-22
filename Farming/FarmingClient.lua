--VARIABLES
local cropsFrame = script.Parent:WaitForChild("CropsFrame")
local optionsFrame = script.Parent:WaitForChild("OptionsFrame")

cropsFrame.Visible, optionsFrame.Visible = false, false

local cropTemplate = script:WaitForChild("Crop")

local currentBlock = nil
local currentCrop = nil

local re = game.ReplicatedStorage:WaitForChild("FarmingRemoteEvent")

local cropsFolder = game.ReplicatedStorage:WaitForChild("Crops")


--CLOSE BUTTONS
optionsFrame.CloseButton.MouseButton1Click:Connect(function()
	optionsFrame.Visible = false
	currentBlock = nil
	currentCrop = nil
end)
cropsFrame.CloseButton.MouseButton1Click:Connect(function()
	cropsFrame.Visible = false
	currentBlock = nil
	currentCrop = nil
end)


--ENABLE OPTIONS UI WHEN GRASS IS CLICKED ON
re.OnClientEvent:Connect(function(block)
	if not cropsFrame.Visible then
		currentBlock = block
		
		optionsFrame.FarmlandButton.BackgroundColor3 = Color3.fromRGB(100, 70, 50)
		optionsFrame.FarmlandButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		optionsFrame.FarmlandButton.Active = true
		optionsFrame.FarmlandButton.AutoButtonColor = true
		optionsFrame.PlantButton.BackgroundColor3 = Color3.fromRGB(100, 70, 50)
		optionsFrame.PlantButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		optionsFrame.PlantButton.Active = true
		optionsFrame.PlantButton.AutoButtonColor = true
		optionsFrame.HarvestButton.BackgroundColor3 = Color3.fromRGB(100, 70, 50)
		optionsFrame.HarvestButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		optionsFrame.HarvestButton.Active = true
		optionsFrame.HarvestButton.AutoButtonColor = true
		optionsFrame.SellButton.BackgroundColor3 = Color3.fromRGB(100, 70, 50)
		optionsFrame.SellButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		optionsFrame.SellButton.Active = true
		optionsFrame.SellButton.AutoButtonColor = true
		optionsFrame.BuyButton.BackgroundColor3 = Color3.fromRGB(100, 70, 50)
		optionsFrame.BuyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		optionsFrame.BuyButton.Active = true
		optionsFrame.BuyButton.AutoButtonColor = true
		
		if block.Name == "Grass" then
			optionsFrame.PlantButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.PlantButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.PlantButton.Active = false
			optionsFrame.PlantButton.AutoButtonColor = false
			optionsFrame.HarvestButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.HarvestButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.HarvestButton.Active = false
			optionsFrame.HarvestButton.AutoButtonColor = false
			optionsFrame.SellButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.SellButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.SellButton.Active = false
			optionsFrame.SellButton.AutoButtonColor = false
			optionsFrame.BuyButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.BuyButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.BuyButton.Active = false
			optionsFrame.BuyButton.AutoButtonColor = false
			optionsFrame.Visible = true
		elseif block.Name == "Farmland" then
			optionsFrame.FarmlandButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.FarmlandButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.FarmlandButton.Active = false
			optionsFrame.FarmlandButton.AutoButtonColor = false
			optionsFrame.HarvestButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.HarvestButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.HarvestButton.Active = false
			optionsFrame.HarvestButton.AutoButtonColor = false
			optionsFrame.SellButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.SellButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.SellButton.Active = false
			optionsFrame.SellButton.AutoButtonColor = false
			optionsFrame.BuyButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.BuyButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.BuyButton.Active = false
			optionsFrame.BuyButton.AutoButtonColor = false
			optionsFrame.Visible = true
		elseif block:FindFirstChild("FULLY GROWN") then
			optionsFrame.PlantButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.PlantButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.PlantButton.Active = false
			optionsFrame.PlantButton.AutoButtonColor = false
			optionsFrame.FarmlandButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.FarmlandButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.FarmlandButton.Active = false
			optionsFrame.FarmlandButton.AutoButtonColor = false
			optionsFrame.SellButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.SellButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.SellButton.Active = false
			optionsFrame.SellButton.AutoButtonColor = false
			optionsFrame.BuyButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.BuyButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.BuyButton.Active = false
			optionsFrame.BuyButton.AutoButtonColor = false
			optionsFrame.Visible = true
		elseif block == workspace.SeedsShop.ShopZone then
			optionsFrame.PlantButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.PlantButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.PlantButton.Active = false
			optionsFrame.PlantButton.AutoButtonColor = false
			optionsFrame.FarmlandButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.FarmlandButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.FarmlandButton.Active = false
			optionsFrame.FarmlandButton.AutoButtonColor = false
			optionsFrame.HarvestButton.BackgroundColor3 = Color3.fromRGB(79, 70, 63)
			optionsFrame.HarvestButton.TextColor3 = Color3.fromRGB(138, 138, 138)
			optionsFrame.HarvestButton.Active = false
			optionsFrame.HarvestButton.AutoButtonColor = false
			optionsFrame.Visible = true
		end
	end
end)


--FARMLAND AND HARVEST OPTION
optionsFrame.FarmlandButton.MouseButton1Click:Connect(function()
	if optionsFrame.FarmlandButton.Active and currentBlock and currentBlock.Name == "Grass" then
		re:FireServer("FARMLAND", currentBlock)
		optionsFrame.Visible = false
	end
end)

optionsFrame.HarvestButton.MouseButton1Click:Connect(function()
	if optionsFrame.HarvestButton.Active and currentBlock and currentBlock:FindFirstChild("FULLY GROWN") then
		re:FireServer("HARVEST", currentBlock)
		optionsFrame.Visible = false
	end
end)

--PLANT OPTION
optionsFrame.PlantButton.MouseButton1Click:Connect(function()
	if optionsFrame.PlantButton.Active and currentBlock and currentBlock.Name == "Farmland" then
		optionsFrame.Visible = false
		
		cropsFrame.AmountBox.Visible = false
		cropsFrame.UseButton.Text = "PLANT"
		
		cropsFrame.CropInfo.Text = ""
		
		for i, child in pairs(cropsFrame.ScrollingFrame:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		
		local cropButtons = {}
		
		for i, crop in pairs(game.Players.LocalPlayer.SeedInventory:GetChildren()) do

			if crop.Value > 0 then
				local newCrop = script:WaitForChild("Crop"):Clone()
				newCrop.CropName.Text = crop.Name
				
				newCrop.CropAmount.Text = crop.Value

				local camera = Instance.new("Camera")
				camera.Parent = newCrop.CropImage
				newCrop.CropImage.CurrentCamera = camera
				
				local cropFolder = game.ReplicatedStorage.Crops[crop.Name]

				local cropModel = cropFolder.Stages[#cropFolder.Stages:GetChildren()]:Clone()
				cropModel.Parent = newCrop.CropImage
				
				local cframe, size = cropModel:GetBoundingBox()
				camera.CFrame = CFrame.new(cframe.Position + size, cframe.Position)
				
				newCrop.MouseButton1Click:Connect(function()
					currentCrop = crop.Name
					cropsFrame.CropInfo.Text = "SELLS: $" .. string.format("%.2f", cropFolder.SellValue.Value) .. "    GROWS: " .. cropFolder.Time.Value .. "s    YIELD: " .. cropFolder.YieldMin.Value .. "-" .. cropFolder.YieldMax.Value
				end)
				
				table.insert(cropButtons, newCrop)
			end
		end
		
		table.sort(cropButtons, function(a, b)
			return game.ReplicatedStorage.Crops[a.CropName.Text].PriceToBuy.Value < game.ReplicatedStorage.Crops[b.CropName.Text].PriceToBuy.Value
		end)
		
		for i, button in pairs(cropButtons) do
			button.Parent = cropsFrame.ScrollingFrame
		end
		
		cropsFrame.Visible = true
	end
end)

--SELL OPTION
optionsFrame.SellButton.MouseButton1Click:Connect(function()
	if optionsFrame.SellButton.Active then
		optionsFrame.Visible = false
		
		cropsFrame.AmountBox.Visible = true
		cropsFrame.UseButton.Text = "SELL"
		
		cropsFrame.CropInfo.Text = ""
		
		for i, child in pairs(cropsFrame.ScrollingFrame:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		
		local cropButtons = {}
		
		for i, crop in pairs(game.Players.LocalPlayer.CropInventory:GetChildren()) do
			
			if crop.Value > 0 then
				local newCrop = script:WaitForChild("Crop"):Clone()
				newCrop.CropName.Text = crop.Name
				
				newCrop.CropAmount.Text = crop.Value
				
				local camera = Instance.new("Camera")
				camera.Parent = newCrop.CropImage
				newCrop.CropImage.CurrentCamera = camera
				
				local cropModel = game.ReplicatedStorage.Crops[crop.Name].Stages[#game.ReplicatedStorage.Crops[crop.Name].Stages:GetChildren()]:Clone()
				cropModel.Parent = newCrop.CropImage
				
				local cframe, size = cropModel:GetBoundingBox()
				camera.CFrame = CFrame.new(cframe.Position + size, cframe.Position)
				
				newCrop.MouseButton1Click:Connect(function()
					currentCrop = crop.Name
					cropsFrame.CropInfo.Text = "SELLS: $" .. string.format("%.2f", game.ReplicatedStorage.Crops[crop.Name].SellValue.Value)
				end)
				
				table.insert(cropButtons, newCrop)
			end
		end
		
		table.sort(cropButtons, function(a, b)
			return game.ReplicatedStorage.Crops[a.CropName.Text].PriceToBuy.Value < game.ReplicatedStorage.Crops[b.CropName.Text].PriceToBuy.Value
		end)

		for i, button in pairs(cropButtons) do
			button.Parent = cropsFrame.ScrollingFrame
		end
		
		cropsFrame.Visible = true
	end
end)

--BUY OPTION
optionsFrame.BuyButton.MouseButton1Click:Connect(function()
	if optionsFrame.BuyButton.Active then
		optionsFrame.Visible = false

		cropsFrame.AmountBox.Visible = true
		cropsFrame.UseButton.Text = "BUY"
		
		cropsFrame.CropInfo.Text = ""

		for i, child in pairs(cropsFrame.ScrollingFrame:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		
		local cropButtons = {}
		
		for i, crop in pairs(game.ReplicatedStorage.Crops:GetChildren()) do

			local newCrop = script:WaitForChild("Crop"):Clone()
			newCrop.CropName.Text = crop.Name
			
			newCrop.CropAmount.Text = ""

			local camera = Instance.new("Camera")
			camera.Parent = newCrop.CropImage
			newCrop.CropImage.CurrentCamera = camera

			local cropModel = crop.Stages[#crop.Stages:GetChildren()]:Clone()
			cropModel.Parent = newCrop.CropImage
			
			local cframe, size = cropModel:GetBoundingBox()
			camera.CFrame = CFrame.new(cframe.Position + size, cframe.Position)

			newCrop.MouseButton1Click:Connect(function()
				currentCrop = crop.Name
				cropsFrame.CropInfo.Text = "PRICE: $" .. string.format("%.2f", crop.PriceToBuy.Value) .. "    SELLS: $" .. string.format("%.2f", crop.SellValue.Value) .. "    GROWS: " .. crop.Time.Value .. "s    YIELD: " .. crop.YieldMin.Value .. "-" .. crop.YieldMax.Value
			end)
			
			table.insert(cropButtons, newCrop)
		end

		table.sort(cropButtons, function(a, b)
			return game.ReplicatedStorage.Crops[a.CropName.Text].PriceToBuy.Value < game.ReplicatedStorage.Crops[b.CropName.Text].PriceToBuy.Value
		end)

		for i, button in pairs(cropButtons) do
			button.Parent = cropsFrame.ScrollingFrame
		end
		
		cropsFrame.Visible = true
	end
end)

--USE BUTTON
cropsFrame.UseButton.MouseButton1Click:Connect(function()
	if currentCrop then
		
		cropsFrame.Visible = false
		
		if cropsFrame.UseButton.Text == "BUY" then
			local amount = cropsFrame.AmountBox.Text
			
			if string.len(amount) > 0 and tonumber(amount) then
				re:FireServer("BUY", currentCrop, amount)
			end
			
		elseif cropsFrame.UseButton.Text == "SELL" then
			local amount = cropsFrame.AmountBox.Text
			
			if string.len(amount) > 0 and tonumber(amount) then
				re:FireServer("SELL", currentCrop, amount)
			end
			
		elseif cropsFrame.UseButton.Text == "PLANT" then
			re:FireServer("PLANT", currentCrop, currentBlock)
		end
		
		currentCrop = nil
	end
end)