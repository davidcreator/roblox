local dss = game:GetService("DataStoreService")

local dailyRewardDS = dss:GetDataStore("DailyRewards")


local rewardsForStreak = 
{
	[1] = 100,
	[2] = 250,
	[3] = 500,
	[4] = 1000,
	[5] = 1750,
	[6] = 3000,
	[7] = 7500,
}


game.Players.PlayerAdded:Connect(function(plr)
	
	local success, dailyRewardInfo = pcall(function()
		return dailyRewardDS:GetAsync(plr.UserId .. "-DailyRewards")
	end)
	if type(dailyRewardInfo) ~= "table" then dailyRewardInfo = {nil, nil, nil} end
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = plr
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	
	cash.Value = dailyRewardInfo[1] or 0
	
	cash.Parent = leaderstats
	
	
	local lastOnline = dailyRewardInfo[2]
	local currentTime = os.time()
	
	local timeDifference
	
	if lastOnline then	
		timeDifference = currentTime - lastOnline
	end
	
	if not timeDifference or timeDifference >= 24*60*60 then
		
		local streak = dailyRewardInfo[3] or 1
		local reward = rewardsForStreak[streak]
		
		local dailyRewardGui = plr.PlayerGui:WaitForChild("DailyRewardGui")
		local mainGui = dailyRewardGui:WaitForChild("MainGui")
		local claimBtn = mainGui:WaitForChild("ClaimButton")
		local rewardLabel = mainGui:WaitForChild("RewardLabel")
		
		rewardLabel.Text = reward
		
		dailyRewardGui.Enabled = true
		
		claimBtn.MouseButton1Click:Connect(function()
			
			cash.Value = cash.Value + reward
			
			dailyRewardGui.Enabled = false
			
			local streak = streak + 1
			if streak > 7 then streak = 1 end
			
			local success, errormsg = pcall(function()
				
				dailyRewardDS:SetAsync(plr.UserId .. "-DailyRewards", {cash.Value, os.time(), streak})
			end)
		end)
		
	elseif timeDifference then
		
		wait((24*60*60) - timeDifference)
		
		if game.Players:FindFirstChild(plr) then
			
			local streak = dailyRewardInfo[3] or 1
			local reward = rewardsForStreak[streak]
			
			local dailyRewardGui = plr.PlayerGui:WaitForChild("DailyRewardGui")
			local mainGui = dailyRewardGui:WaitForChild("MainGui")
			local claimBtn = mainGui:WaitForChild("ClaimButton")
			local rewardLabel = mainGui:WaitForChild("RewardLabel")
			
			rewardLabel.Text = reward
			
			dailyRewardGui.Enabled = true
			
			claimBtn.MouseButton1Click:Connect(function()
				
				cash.Value = cash.Value + reward
				
				dailyRewardGui.Enabled = false
				
				local streak = streak + 1
				if streak > 7 then streak = 1 end
				
				pcall(function()
					
					dailyRewardDS:SetAsync(plr.UserId .. "-DailyRewards", {cash.Value, os.time(), streak})
				end)
			end)
		end
	end
end)