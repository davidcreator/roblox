local devProducts = require(game:GetService("ReplicatedStorage"):WaitForChild("DeveloperProducts"))

local mps = game:GetService("MarketplaceService")

local gui = script.Parent
local cashDisplay = gui:WaitForChild("CashDisplayFrame")
local cashShop = gui:WaitForChild("CashShopFrame");cashShop.Visible = false

local plr = game.Players.LocalPlayer
local plrCash = plr:WaitForChild("leaderstats"):WaitForChild("Cash")


function updateDisplay()
	
	local newCash = tostring(plrCash.Value)
	local nSubs = 0
	
	while true do
		newCash, nSubs = string.gsub(newCash, "^(-?%d+)(%d%d%d)", "%1,%2")
		
		if nSubs == 0 then
			break
		end
	end
	
	cashDisplay.CashAmount.Text = "$" .. newCash
end

function createDevProductFrame(productId:number)
	
	local newFrame = script:WaitForChild("DevProductFrame"):Clone()
	
	local productInfo = mps:GetProductInfo(productId, Enum.InfoType.Product)
	newFrame.DevProductCash.Text = devProducts[productId].Cash .. " Cash"
	newFrame.DevProductPrice.Text = productInfo.PriceInRobux .. "R$"
	newFrame.DevProductImage.Image = "rbxassetid://" .. productInfo.IconImageAssetId
	
	newFrame.BuyButton.MouseButton1Click:Connect(function()
		mps:PromptProductPurchase(plr, productId)
	end)
		
	return newFrame
end

function createScrollingFrame()
	
	local devProductFrames = {}
	
	for productId, cash in pairs(devProducts) do
		table.insert(devProductFrames, {cash.Cash, createDevProductFrame(productId)})
	end
	
	table.sort(devProductFrames, function(a, b)
		return a[1] < b[1]
	end)
	
	for _, frame in pairs(devProductFrames) do
		frame[2].Parent = cashShop.DevProductSrollingFrame
	end
end

function openShop()
	cashShop.Visible = true
end

function closeShop()
	cashShop.Visible = false
end


updateDisplay()
plrCash:GetPropertyChangedSignal("Value"):Connect(updateDisplay)

createScrollingFrame()

cashDisplay.OpenShopButton.MouseButton1Click:Connect(function()
	if cashShop.Visible == false then
		openShop()
	else 
		closeShop()
	end
end)
cashShop.CloseShopButton.MouseButton1Click:Connect(closeShop)