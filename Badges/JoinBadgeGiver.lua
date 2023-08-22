local badgeId = 2124957495

local badgeService = game:GetService("BadgeService")


game.Players.PlayerAdded:Connect(function(plr)
	
	badgeService:AwardBadge(plr.UserId, badgeId)
end)