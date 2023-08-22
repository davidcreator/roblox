local mps = game:GetService("MarketplaceService")

local dss = game:GetService("DataStoreService")
local giftedData = dss:GetDataStore("Gifted Gamepasses Data")

local re = game.ReplicatedStorage:WaitForChild("GiftGamepassReplicatedStorage"):WaitForChild("GiftRE")
local gamepasses = require(game.ReplicatedStorage.GiftGamepassReplicatedStorage:WaitForChild("GiftableGamepasses"))


local playersGifted = {}


re.OnServerEvent:Connect(function(plr, pass, userId)
	
	if not game.Players:GetNameFromUserIdAsync(userId) then return end
	
	for i, gamepass in pairs(gamepasses) do
		if gamepass[1] == pass[1] and gamepass[2] == pass[2] then
			
			if plr.UserId ~= userId then
				local owns = false

				local gamepassId = pass[1]
				local productId = pass[2]

				if mps:UserOwnsGamePassAsync(userId, gamepassId) then
					owns = true

				else
					local data = giftedData:GetAsync(userId .. "-" .. pass[1])
					if data then 
						owns = true 
					end
				end

				if not owns then
					playersGifted[plr.UserId] = userId
					mps:PromptProductPurchase(plr, pass[2])
				end
			end
		end
	end
end)


game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)

		local hum = char:WaitForChild("Humanoid")
		
		local walkId = gamepasses[1][1]
		local jumpId = gamepasses[2][1]
		
		local ownsWalkBoost = mps:UserOwnsGamePassAsync(plr.UserId, walkId)
		local ownsJumpBoost = mps:UserOwnsGamePassAsync(plr.UserId, jumpId)
		
		if not ownsWalkBoost then
			local data = giftedData:GetAsync(plr.UserId .. "-" .. walkId)
			if data then ownsWalkBoost = true end
		end
		if not ownsJumpBoost then
			local data = giftedData:GetAsync(plr.UserId .. "-" .. jumpId)
			if data then ownsJumpBoost = true end
		end

		if ownsWalkBoost then
			hum.WalkSpeed *= 2
		end

		if ownsJumpBoost then
			hum.JumpHeight *= 2
		end
	end)
end)


mps.ProcessReceipt = function(receiptInfo)
	local plrId = receiptInfo.PlayerId
	local purchasedId = receiptInfo.ProductId
	
	for i, pass in pairs(gamepasses) do
		
		local passId = pass[1]
		local productId = pass[2]
		
		if purchasedId == productId then
			
			local giftUserId = playersGifted[plrId]
			if giftUserId then
				playersGifted[plrId] = nil
				
				local success, err = pcall(function()
					giftedData:SetAsync(giftUserId .. "-" .. passId, true)
				end)
				
				if success then
					return Enum.ProductPurchaseDecision.PurchaseGranted
				else
					return Enum.ProductPurchaseDecision.NotProcessedYet
				end
				
			else
				return Enum.ProductPurchaseDecision.NotProcessedYet
			end
		end
	end
end