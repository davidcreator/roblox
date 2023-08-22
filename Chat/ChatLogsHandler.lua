local https = game:GetService("HttpService")

local webhook = "PUT WEBHOOK LINK HERE"


function sendDiscordMessage(message, name, picture)
	
	local info = {
		content = message,
		username = name,
		avatar_url = picture
	}
	
	local encoded = https:JSONEncode(info)
	
	https:PostAsync(webhook, encoded)
end


game.Players.PlayerAdded:Connect(function(player)
	
	local name = player.DisplayName .. " (@" .. player.Name .. ")"
	
	local imageUrl = "http://www.roblox.com/Thumbs/Avatar.ashx?x=100&y=100&Format=Png&Type=AvatarHeadShot&userId=" .. player.UserId
	
	player.Chatted:Connect(function(message)
		
		
		sendDiscordMessage(message, name, imageUrl)
	end)
end)