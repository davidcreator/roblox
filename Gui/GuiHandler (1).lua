local btn = script.Parent:WaitForChild("ShopBtn")
local shopFrame = script.Parent:WaitForChild("ShopBG")
local itemScroller = shopFrame.ItemScroller
local itemPreview = shopFrame.ItemPreview


shopFrame.Visible = false
itemPreview.Visible = false


btn.MouseButton1Click:Connect(function()
	
	shopFrame.Visible = not shopFrame.Visible
end)


local itemsFolder = game.ReplicatedStorage:WaitForChild("Items")

for i, item in pairs(itemsFolder:GetChildren()) do
	
	
	local name = item.Name
	local price = item.ShopGuiInfo.Price.Value
	local desc = item.ShopGuiInfo.Description.Value
	
	local itemSelection = script.ItemSelection:Clone()
	
	local cam = Instance.new("Camera")
	cam.Parent = itemSelection.ItemView
	itemSelection.ItemView.CurrentCamera = cam
	
	
	local displayPart = item.Handle:Clone()
	displayPart.Anchored = true
	displayPart.CFrame = CFrame.new()
	displayPart.Parent = itemSelection.ItemView
	
	cam.CFrame = CFrame.new(displayPart.Position + displayPart.CFrame.LookVector * 4, displayPart.Position)
	
	itemSelection.Parent = itemScroller
	
	
	itemSelection.MouseButton1Click:Connect(function()
		
		itemPreview.ItemName.Text = name
		itemPreview.BuyButton.Text = "Buy for " .. price
		itemPreview.ItemDescription.Text = desc
		
		if itemPreview.ItemImage:FindFirstChild("Handle") then itemPreview.ItemImage.Handle:Destroy() end
		if itemPreview.ItemImage:FindFirstChild("Camera") then itemPreview.ItemImage.Camera:Destroy() end
		
		local cam2 = cam:Clone()
		cam2.Parent = itemPreview.ItemImage
		itemPreview.ItemImage.CurrentCamera = cam2
		
		displayPart:Clone().Parent = itemPreview.ItemImage
		
		itemPreview.Visible = true
	end)
end


itemPreview.BuyButton.MouseButton1Click:Connect(function()

	game.ReplicatedStorage.OnItemBought:FireServer(itemsFolder[itemPreview.ItemName.Text])
end)