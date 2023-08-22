local mps = game:GetService("MarketplaceService")

local id = 7550418

local player = game.Players.LocalPlayer


script.Parent.MouseButton1Click:Connect(function()
			
	mps:PromptGamePassPurchase(player, id)	
end)