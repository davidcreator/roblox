local badgeservice = game:GetService("BadgeService")
local id = 12345

local bool = script.OwnerInGame


game.Players.PlayerAdded:Connect(function(plr)
	if plr.Name == "TopSecretSpy1177" then
		bool.Value = true
		
	elseif bool.Value == true then
		badgeservice:AwardBadge(plr.UserId, id)
	end
end)
	
game.Players.PlayerRemoving:Connect(function(plr)
	if plr.Name == "TopSecretSpy1177" then
		bool.Value = false
	end
end)