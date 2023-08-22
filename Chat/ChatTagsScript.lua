local plrs = game.Players

local sss = game.ServerScriptService

local groupId = 2929563

local chatService = require(sss:WaitForChild('ChatServiceRunner'):WaitForChild('ChatService'))


chatService.SpeakerAdded:Connect(function(plr)
	
	local speaker = chatService:GetSpeaker(plr)
	
	
	if plrs[plr].UserId == 84182809 then
		
		speaker:SetExtraData('NameColor', Color3.fromRGB(255, 0, 0))
		speaker:SetExtraData('ChatColor', Color3.fromRGB(124, 238, 255))
		speaker:SetExtraData('Tags', {{TagText = 'Owner', TagColor = Color3.fromRGB(0, 222, 255)}})			


	elseif plrs[plr]:IsInGroup(groupId) then		
			
		speaker:SetExtraData('NameColor', Color3.fromRGB(0, 255, 178))
		speaker:SetExtraData('Tags', {{TagText = plrs[plr]:GetRoleInGroup(groupId), TagColor = Color3.fromRGB(0, 255, 77)}})			
	end	
end)