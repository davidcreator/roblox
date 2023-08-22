local MarketplaceService = game:GetService("MarketplaceService") 
local GamepassID = 7365423
 
game.Players.PlayerAdded:Connect(function(Player)
 
	if MarketplaceService:UserOwnsGamePassAsync(Player.UserId, GamepassID) then		
		print(Player.Name .. " owns the gamepass: " .. GamepassID)

		game.ServerStorage.Gun:clone().Parent = Player:WaitForChild("Backpack")
		game.ServerStorage.Gun:clone().Parent = Player:WaitForChild("StarterGear")
	end
end)