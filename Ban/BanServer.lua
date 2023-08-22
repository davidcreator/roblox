local adminIDs = {84182809}

local re = game.ReplicatedStorage:WaitForChild("BanGuiReplicatedStorage"):WaitForChild("BanRemoteEvent")
local gui = game.ReplicatedStorage.BanGuiReplicatedStorage:WaitForChild("BanGui")

local dss = game:GetService("DataStoreService")
local banData = dss:GetDataStore("Ban Data")


game.Players.PlayerAdded:Connect(function(plr)
	if table.find(adminIDs, plr.UserId) then
		
		plr.CharacterAdded:Connect(function(char)
			local newGui = gui:Clone()
			newGui.Parent = plr.PlayerGui
		end)
		
	else
		local plrBanData = banData:GetAsync(plr.UserId)
		if plrBanData then
			local reason = plrBanData["reason"]
			local days = plrBanData["days"]
			local timeOfBan = plrBanData["timeOfBan"]
			
			local timeOfUnban = timeOfBan + (days * 24 * 60 * 60)
			local timeNow = tick()
			
			if timeNow >= timeOfUnban then
				banData:RemoveAsync(plr.UserId)
				
			else
				local date = os.date("%c", timeOfUnban)
				local kickMessage = "You have been banned for: " .. reason .. "\nYou will be unbanned on " .. date
				
				plr:Kick(kickMessage)
			end
		end
	end
end)

re.OnServerEvent:Connect(function(plr, userId, banReason, length)
	if table.find(adminIDs, plr.UserId) then
		
		if tonumber(length) and tonumber(length) > 0 then
			
			local plrBanData = {
				reason = banReason,
				days = length,
				timeOfBan = tick(),
			}
			
			local timeNow = tick()
			local timeOfUnban = timeNow + (length * 24 * 60 * 60)
			
			local player = game.Players:GetPlayerByUserId(userId)
			
			if player then
				local date = os.date("%c", timeOfUnban)
				local kickMessage = "You have been banned for: " .. banReason .. "\nYou will be unbanned on " .. date
				
				player:Kick(kickMessage)
			end
			
			banData:SetAsync(userId, plrBanData)
		end
	end
end)