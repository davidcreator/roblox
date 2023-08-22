local gamepassIDs = {25375907, 25375884, 25375939, 25375958}

local mps = game:GetService("MarketplaceService")


script.Parent.Visible = false


for i, id in pairs(gamepassIDs) do
	
	local frame = script.GamepassFrame:Clone()
	
	local info = mps:GetProductInfo(id, Enum.InfoType.GamePass)
	
	frame.GamepassName.Text = info.Name
	frame.GamepassDescription.Text = info.Description
	frame.GamepassPrice.Text = info.PriceInRobux .. " Robux"
	frame.GamepassIcon.Image = "rbxassetid://" .. info.IconImageAssetId
	
	if not mps:UserOwnsGamePassAsync(game.Players.LocalPlayer.UserId, id) then
		
		frame.BuyButton.MouseButton1Click:Connect(function()
			
			mps:PromptGamePassPurchase(game.Players.LocalPlayer, id)
		end)
		
	else
		
		frame.BuyButton.Text = "Bought"
		frame.BuyButton.BackgroundColor3 = Color3.fromRGB(3, 75, 0)
		frame.BuyButton.UIStroke1.Color = Color3.fromRGB(2, 58, 0)
		frame.BuyButton.UIStroke2.Color = Color3.fromRGB(2, 58, 0)
	end
	
	frame.Parent = script.Parent.GamepassScroller
	
	script.Parent.GamepassScroller.CanvasSize = UDim2.new(0, 0, 0, script.Parent.GamepassScroller.UIListLayout.AbsoluteContentSize.Y)
end


script.Parent.CloseButton.MouseButton1Click:Connect(function()
	
	script.Parent.Visible = not script.Parent.Visible
end)

script.Parent.Parent.GamepassShopButton.MouseButton1Click:Connect(function()
	
	script.Parent.Visible = not script.Parent.Visible
end)