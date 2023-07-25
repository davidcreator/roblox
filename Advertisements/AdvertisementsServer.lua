--DISPLAY ADVERTISEMENTS ON BILLBOARDS
local marketplaceService = game:GetService("MarketplaceService")
local devproductId = 1291100930 --The ID of the developer product that will be used to create ads (you can find this in the link of the place)

local datastoreService = game:GetService("DataStoreService")
local datastore = datastoreService:GetDataStore("ADS DataStore")

local remoteEvent = game.ReplicatedStorage:WaitForChild("AdvertisementsRE")

local timePerAd = 10 --How many seconds the ad shows up on the billboard for before being replaced by another ad (10 seconds)
local timeAdExists = 86400 --How many seconds the ad is allowed to appear on the billboards after being created before it is removed from the list of ads (1 day)

local billboardContainer = workspace:WaitForChild("BillboardContainer")


function handleBillboard(billboard)
	
	local clickDetector = Instance.new("ClickDetector")
	clickDetector.Parent = billboard.ItemButton
	
	clickDetector.MouseClick:Connect(function(player)
		remoteEvent:FireClient(player, billboard.ItemButton)
	end)
	
	
	while wait() do
		
		local adsData = datastore:GetAsync("Ads")
		
		if adsData then
			
			for x, adData in pairs(adsData) do
				
				local itemID = adData[1]
				local timeUploaded = adData[2]
				
				if not billboard.ItemButton:FindFirstChild("ID") then
					local idValue = Instance.new("IntValue")
					idValue.Name = "ID"
					idValue.Parent = billboard.ItemButton
				end
				billboard.ItemButton.ID.Value = itemID
				
				if os.time() - timeUploaded > timeAdExists then
					
					table.remove(adsData, x)
					datastore:SetAsync("Ads", adsData)
				end
				
				local productInfo = marketplaceService:GetProductInfo(itemID)
				
				local name = productInfo.Name
				billboard.Screen.AdGui.TextContainer.ItemName.Text = name
				
				billboard.Screen.AdGui.ItemThumbnail.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. itemID .. "&width=420&height=420&format=png"
				
				local typeId = productInfo.AssetTypeId
					
				if typeId == 9 then
					billboard.ItemButton.ButtonGui.ButtonLabel.Text = "PLAY"	
				else
					billboard.ItemButton.ButtonGui.ButtonLabel.Text = "BUY"
				end
				
				billboard.ItemButton.Transparency = 0	
				billboard.ItemButton.ButtonGui.Enabled = true				
				
				wait(timePerAd)
			end
			
			
		else
			--Placeholder billboard
			billboard.Screen.AdGui.ItemThumbnail.Image = "http://www.roblox.com/asset/?id=9586437451"
			billboard.Screen.AdGui.TextContainer.ItemName.Text = "YOUR AD HERE"
			billboard.ItemButton.Transparency = 1	
			billboard.ItemButton.ButtonGui.Enabled = false	
			
			if billboard.ItemButton:FindFirstChild("ID") then
				billboard.ItemButton.ID:Destroy()
			end
		end
	end
end


for i, billboard in pairs(billboardContainer:GetChildren()) do
	spawn(function()
		handleBillboard(billboard)
	end)
end
billboardContainer.ChildAdded:Connect(handleBillboard)


--LOG ADVERTISEMENTS CREATED BY USERS
local playerAdverts = {}

local validTypeIDs = {1, 2, 3, 8, 9, 10, 11, 12, 13, 34, 38, 41, 42, 43, 44, 45, 46, 47, 57, 58}


remoteEvent.OnServerEvent:Connect(function(player, id)
	
	if id then
		local productInfo = marketplaceService:GetProductInfo(id)
		
		if productInfo and table.find(validTypeIDs, productInfo.AssetTypeId) and (productInfo.IsForSale == true or productInfo.AssetTypeId == 9 or productInfo.IsPublicDomain == true) then
			
			playerAdverts[player.UserId] = id
			
			marketplaceService:PromptProductPurchase(player, devproductId)
		end
	end
end)


--CREATE ADVERTISEMENTS WHEN DEVELOPER PRODUCT IS BOUGHT
marketplaceService.ProcessReceipt = function(receiptInfo)
	
	local id = receiptInfo.ProductId
	
	if id == devproductId and playerAdverts[receiptInfo.PlayerId] then
		
		local advertID = playerAdverts[receiptInfo.PlayerId]
		
		local ads = datastore:GetAsync("Ads") or {}
		table.insert(ads, {advertID, os.time()})
		
		datastore:SetAsync("Ads", ads)
		
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
	else
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end