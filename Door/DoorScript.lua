local Door = game.Workspace.DoorGroup.Door
local lol = false

local open = "!open"
local close = "!close"

function onChatted(chat, recipient, speaker)
	
	local name = speaker.Name
	chat = string.lower(chat)
	
	if chat == open and lol == false then

		Door.Transparency = 0.1
		wait(0.1)
		Door.Transparency = 0.2
		wait(0.1)
		Door.Transparency = 0.3
		wait(0.1)
		Door.Transparency = 0.4
		wait(0.1)
		Door.Transparency = 0.5
		wait(0.1)
		Door.Transparency = 0.6
		wait(0.1)
		Door.Transparency = 0.7
		wait(0.1)
		Door.Transparency = 0.8
		wait(0.1)
		Door.Transparency = 0.9
		wait(0.1)
		Door.Transparency = 1
		wait(0.1)
		Door.CanCollide = false
		lol = true
	end

	
	if chat == close and lol == true then
		
		wait(0.1)
		Door.Transparency = 0.9
		wait(0.1)
		Door.Transparency = 0.8
		wait(0.1)
		Door.Transparency = 0.7
		wait(0.1)
		Door.Transparency = 0.6
		wait(0.1)
		Door.Transparency = 0.5
		wait(0.1)
		Door.Transparency = 0.4
		wait(0.1)
		Door.Transparency = 0.3
		wait(0.1)
		Door.Transparency = 0.2
		wait(0.1)
		Door.Transparency = 0.1
		wait(0.1)
		Door.Transparency = 0
		Door.CanCollide = true
		lol = false
	end
end


function onPlayerEntered(Player)
	Player.Chatted:connect(function(chat, recipient) onChatted(chat, recipient, Player) end)
end


game.Players.PlayerAdded:connect(onPlayerEntered)