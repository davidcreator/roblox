local mps = game:GetService("MarketplaceService")
local LasergunId = 7550414
local SwordId = 7550415
local SpeedCoilId = 7550412
local GravCoilId = 7550418
 
game.Players.PlayerAdded:Connect(function(player)
 	
    if mps:UserOwnsGamePassAsync(player.UserId, LasergunId) then    
        print(player.Name .. " owns the gamepass: " .. LasergunId)
 
        game.ServerStorage.HyperlaserGun:Clone().Parent = player:WaitForChild("Backpack")
        game.ServerStorage.HyperlaserGun:Clone().Parent = player:WaitForChild("StarterGear")
    end


	if mps:UserOwnsGamePassAsync(player.UserId, SwordId) then    
        print(player.Name .. " owns the gamepass: " .. SwordId)
 
        game.ServerStorage.ClassicSword:Clone().Parent = player:WaitForChild("Backpack")
        game.ServerStorage.ClassicSword:Clone().Parent = player:WaitForChild("StarterGear")
	end
	
	
	if mps:UserOwnsGamePassAsync(player.UserId, SpeedCoilId) then    
        print(player.Name .. " owns the gamepass: " .. SpeedCoilId)
 
        game.ServerStorage.SpeedCoil:Clone().Parent = player:WaitForChild("Backpack")
        game.ServerStorage.SpeedCoil:Clone().Parent = player:WaitForChild("StarterGear")
	end
	
	
	if mps:UserOwnsGamePassAsync(player.UserId, GravCoilId) then    
        print(player.Name .. " owns the gamepass: " .. GravCoilId)
 
        game.ServerStorage.GravityCoil:Clone().Parent = player:WaitForChild("Backpack")
        game.ServerStorage.GravityCoil:Clone().Parent = player:WaitForChild("StarterGear")
    end	
end)