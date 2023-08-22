local mps = game:GetService("MarketplaceService")


local coinsProductIDs = 
{
	[1096714714] = 100,
	[1096715119] = 500,
	[1096715447] = 1000,
	[1096715703] = 5000,
}


game.Players.PlayerAdded:Connect(function(plr)
		
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr
	
	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Parent = ls
end)



mps.ProcessReceipt = function(purchaseInfo)
	
	
	local plrPurchased = game.Players:GetPlayerByUserId(purchaseInfo.PlayerId)
	
	if not plrPurchased then
		
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	
	for productID, coinsGiven in pairs(coinsProductIDs) do
		
		if purchaseInfo.ProductId == productID then
			
			
			plrPurchased.leaderstats.Coins.Value = plrPurchased.leaderstats.Coins.Value + coinsGiven
			
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
	end
end
