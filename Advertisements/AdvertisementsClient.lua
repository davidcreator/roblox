--HIDE GUI ON START
local adFrame = script.Parent:WaitForChild("AdFrame")
adFrame.Visible = false

--VARIABLES
local createBtn = script.Parent:WaitForChild("CreateAdButton")
local closeBtn = adFrame:WaitForChild("CloseButton")
local nameLbl = adFrame:WaitForChild("ItemName")
local thumbnailImg = adFrame:WaitForChild("ItemThumbnail")
local confirmBtn = adFrame:WaitForChild("ConfirmButton")
local idBox = adFrame:WaitForChild("ItemIDBox")


--OPEN AND CLOSE GUI WHEN BUTTONS ARE PRESSED
createBtn.MouseButton1Click:Connect(function()
	adFrame.Visible = true
	
	nameLbl.Text = "Item name"
	thumbnailImg.Image = "http://www.roblox.com/asset/?id=9586437451"
	idBox.Text = ""
end)

closeBtn.MouseButton1Click:Connect(function()
	adFrame.Visible = false
end)


--CREATE AD PREVIEW WHEN ID IS ENTERED
local marketplaceService = game:GetService("MarketplaceService")

idBox.FocusLost:Connect(function(enterPressed)
	
	local enteredId = idBox.Text
	
	if string.len(enteredId) > 0 and enterPressed then
		local productInfo = marketplaceService:GetProductInfo(enteredId)
		
		if productInfo then
			
			local name = productInfo.Name
			nameLbl.Text = name

			thumbnailImg.Image = "https://www.roblox.com/asset-thumbnail/image?assetId=" .. enteredId .. "&width=420&height=420&format=png"
		end
	end
end)


--SEND MESSAGE TO SERVER TO CREATE AD WHEN CONFIRM BUTTON IS PRESSED
local remoteEvent = game.ReplicatedStorage:WaitForChild("AdvertisementsRE")

confirmBtn.MouseButton1Click:Connect(function()
	
	remoteEvent:FireServer(tonumber(idBox.Text))
	
	adFrame.Visible = false
end)


--PROMPT PLAYER TO BUY PRODUCT OR JOIN PLACE WHEN THEY CLICK ON THE ITEM BUTTON
local teleportService = game:GetService("TeleportService")

remoteEvent.OnClientEvent:Connect(function(button)
	
	if button:FindFirstChild("ID") then
		
		local id = button.ID.Value
		
		local productInfo = marketplaceService:GetProductInfo(id)
		
		local typeId = productInfo.AssetTypeId
		
		if typeId == 9 then
			teleportService:Teleport(id, game.Players.LocalPlayer)
			
		else
			marketplaceService:PromptPurchase(game.Players.LocalPlayer, id)
		end
	end
end)