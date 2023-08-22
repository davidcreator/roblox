local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("DATA")

local mps = game:GetService("MarketplaceService")

local devProducts = require(game:GetService("ReplicatedStorage"):WaitForChild("DeveloperProducts"))


function saveData(plr:Player)
	
	if not plr:FindFirstChild("DATA FAILED TO LOAD") then
		
		local plrCash = plr.leaderstats.Cash.Value
		
		local success, err = nil, nil
		
		while true do
			
			success, err = pcall(function()
				ds:SetAsync(plr.UserId .. " - Cash", plrCash)
			end)
			
			if not success then
				warn(err)
				task.wait(0.02)
			else
				break
			end
		end
	end
end

function loadData(plr:Player)
	
	local dataFailedWarning = Instance.new("StringValue")
	dataFailedWarning.Name = "DATA FAILED TO LOAD"

	local success, plrData = nil, nil
	
	while true do
		success, plrData = pcall(function()
			return ds:GetAsync(plr.UserId .. " - Cash")
		end)
		task.wait(0.02)
		if not success then
			dataFailedWarning.Parent = plr
			warn(plrData)
		else
			break
		end
	end
	dataFailedWarning:Destroy()
	
	return plrData
end

function setupLeaderstats(plr:Player, savedCash:number)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = savedCash or 0
	cash.Parent = leaderstats
end

function handlePurchase(purchaseInfo)
	
	local plr = game.Players:GetPlayerByUserId(purchaseInfo.PlayerId)
	
	if not plr or plr:FindFirstChild("DATA FAILED TO LOAD") then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	local productID = purchaseInfo.ProductId
	
	if devProducts[productID] then
		plr.leaderstats.Cash.Value += devProducts[productID].Cash
		
		return Enum.ProductPurchaseDecision.PurchaseGranted
		
	else
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end


game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for _, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)

game.Players.PlayerAdded:Connect(function(plr)
	
	local plrData = loadData(plr)
	setupLeaderstats(plr, plrData)
end)





mps.ProcessReceipt = handlePurchase