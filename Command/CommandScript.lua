local Players = game:GetService("Players")

local command1 = "!kill"
local command2 = "!lasergun"

function onChatted(chat, recipient, speaker)
	
	local name = speaker.Name
	chat = string.lower(chat)
	
	if (chat == command1) then
		
		local player = Players:FindFirstChild(name)
		
		local humanoid = player.Character.Humanoid
		
		if humanoid then
			humanoid.Health = 0
		end
	end

	
	if (chat == command2) then
		
		local player = Players:FindFirstChild(name)
		
		game.ServerStorage.Gun:clone().Parent = player:WaitForChild("Backpack")
	end
end


function onPlayerEntered(Player)
	Player.Chatted:connect(function(chat, recipient) onChatted(chat, recipient, Player) end)
end


game.Players.PlayerAdded:connect(onPlayerEntered)