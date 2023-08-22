local clothesIds = {1210857662, 6709022132, 6959669630, 6781213791, 6559275186, 6555794614}

local template = script:WaitForChild("Display")

local mps = game:GetService("MarketplaceService")
local is = game:GetService("InsertService")


for i, id in pairs(clothesIds) do
	
	local display = template:Clone()
	
	local productInfo = mps:GetProductInfo(id, Enum.InfoType.Asset)
	
	local name = productInfo.Name
	local price = productInfo.PriceInRobux
	
	display.BuyButton.ClothingDetailsGui.ClothingDetails.Text = name .. "\n" .. price .. " Robux"
	
	local asset = is:LoadAsset(id):GetChildren()[1]
	
	asset.Parent = display.NPC
	
	
	display.BuyButton.ClickDetector.MouseClick:Connect(function(plr)
		
		mps:PromptPurchase(plr, id)
	end)
	
	
	display.TryButton.ClickDetector.MouseClick:Connect(function(plr)
		
		if asset:IsA("Shirt") then
			
			plr.Character.Shirt.ShirtTemplate = asset.ShirtTemplate
			
		elseif asset:IsA("Pants") then
			
			plr.Character.Pants.PantsTemplate = asset.PantsTemplate
		end
	end)
	
	display:SetPrimaryPartCFrame(display.PrimaryPart.CFrame + Vector3.new(0, 0, display.PrimaryPart.Size.Z * (i - 1)))
	display.Parent = workspace
end