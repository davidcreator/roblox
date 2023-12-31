local prefix = ":" --The prefix before commands

local playerPermissions = { --Permission levels for commands - a level of 0 in a command ModuleScript means anyone can use the command
	[1] = {},
	[2] = {},
	[3] = {84182809},
}


local cmds = game:GetService("ServerStorage"):WaitForChild("Commands")


game.Players.PlayerAdded:Connect(function(plr)
	
	local plrPermission = 0
	
	for permissionLevel, playersAtPermission in pairs(playerPermissions) do
		
		if table.find(playersAtPermission, plr.UserId) then
			plrPermission = permissionLevel
			break
		end
	end
	
	plr.Chatted:Connect(function(message)
		
		local prefixMessage = string.sub(message, 1, 1)

		if prefixMessage == prefix then
			
			local afterPrefixMessage = string.sub(message, 2, -1)
			local splitMessage = string.split(afterPrefixMessage, " ")
			
			local command = splitMessage[1]
			if cmds:FindFirstChild(command) then
				
				local arguments = splitMessage
				table.remove(arguments, 1)
				
				local cmdFunction = require(cmds[command])
				cmdFunction(plr, plrPermission, arguments)
			end
		end
	end)
end)