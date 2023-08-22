local donateAmounts = {500, 1000, 2000, 5000}
local ids = {1210650430, 1210650616, 1210650734, 1210650846}


local mps = game:GetService("MarketplaceService")

local dss = game:GetService("DataStoreService")
local ods = dss:GetOrderedDataStore("Donators")



for i, amount in pairs(donateAmounts) do
	
	local donateButton = script:WaitForChild("DonateButton"):Clone()
	donateButton.Text = amount .. " Robux"
	donateButton.Parent = script.Parent.DonatePart.DonateGui.DonateList
end


game.ReplicatedStorage.DonateRE.OnServerEvent:Connect(function(plr, button)
	
	
	local amount = string.gsub(button.Text, " Robux", "")
	local id = ids[table.find(donateAmounts, tonumber(amount))]
	
	mps:PromptProductPurchase(plr, id)
end)


mps.ProcessReceipt = function(purchaseInfo)
	
	local amount = mps:GetProductInfo(purchaseInfo.ProductId, Enum.InfoType.Product).PriceInRobux
	
	local success, err = pcall(function()
		local totalDonated = ods:GetAsync(purchaseInfo.PlayerId) or 0
		ods:SetAsync(purchaseInfo.PlayerId, totalDonated + amount)
	end)
	
	return success and Enum.ProductPurchaseDecision.PurchaseGranted or Enum.ProductPurchaseDecision.NotProcessedYet
end


while wait(5) do
	
	for i, child in pairs(script.Parent.LeaderboardPart.LeaderboardGui.LeaderboardList:GetChildren()) do
		
		if child:IsA("Frame") then child:Destroy() end
	end
	
	
	local pages = ods:GetSortedAsync(false, 100)
	local top = pages:GetCurrentPage()
	
	
	for rank, data in ipairs(top) do
		
		local username = game.Players:GetNameFromUserIdAsync(data.key)
		local donated = data.value
		
		local leaderboardFrame = script.LeaderboardFrame:Clone()
		leaderboardFrame.Rank.Text = "#" .. rank
		leaderboardFrame.Username.Text = username
		leaderboardFrame.Amount.Text = donated
		
		leaderboardFrame.Parent = script.Parent.LeaderboardPart.LeaderboardGui.LeaderboardList
	end
end