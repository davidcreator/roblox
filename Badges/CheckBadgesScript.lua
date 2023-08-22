local badgeservice = game:GetService("BadgeService")
local id1 = 12345
local id2 = 1234

game.Players.PlayerAdded:Connect(function(plr)	
	
	local int = Instance.new("IntValue",plr)
	int.Name = "Badges"
	int.Value = 0

	badgeservice:AwardBadge(plr.UserId, id1)
	int.Value = int.Value + 1
	
	game.Players.CharacterAdded:Connect(function()
		badgeservice:AwardBadge(plr.UserId, id2)
		int.Value = int.Value + 1
	end)
end)