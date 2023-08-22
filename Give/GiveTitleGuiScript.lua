local title = game.ServerStorage.PlrTitleGui

local groupId = 2929563


game.Players.PlayerAdded:Connect(function(plr)	
	plr.CharacterAdded:Connect(function(char)
	
		local plrTitle = title:Clone()
		
		plrTitle.PlrName.Text = char.Name
		
		if plr:IsInGroup(groupId) then
			
			plrTitle.GroupRank.Text = plr:GetRoleInGroup(groupId)
			
		else
			
			plrTitle.GroupRank:Destroy()
			
			
		end
		
		plrTitle.Parent = char.Head
		
	end)
end)