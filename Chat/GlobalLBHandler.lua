local ds = game:GetService("DataStoreService")

local coinsODS = ds:GetOrderedDataStore("CoinsStats")


local timeUntilReset = 10


while wait(1) do
	
	
	timeUntilReset = timeUntilReset - 1
	
	script.Parent.Parent.ResetTime.Text = "Resetting in " .. timeUntilReset .. " seconds..."
	
	
	if timeUntilReset == 0 then
		
		timeUntilReset = 10
	
	
		for i, plr in pairs(game.Players:GetPlayers()) do
			
			coinsODS:SetAsync(plr.UserId, plr.leaderstats.Coins.Value)
		end
		
		for i, leaderboardRank in pairs(script.Parent:GetChildren()) do
			
			if leaderboardRank.ClassName == "Frame" then
				leaderboardRank:Destroy()
			end
		end
		
		
		local success, errorMsg = pcall(function()
			
			local data = coinsODS:GetSortedAsync(false, 5)
			local coinsPage = data:GetCurrentPage()
			
			for rankInLB, dataStored in ipairs(coinsPage) do
				
				
				local name = game.Players:GetNameFromUserIdAsync(tonumber(dataStored.key))
				local coins = dataStored.value
				
				
				local template = script.Template:Clone()
				
				template.Name = name .. "Leaderboard"
				
				template.PlrName.Text = name
				
				template.Rank.Text = "#" .. rankInLB
				
				template.Coins.Text = coins
				
				template.Parent = script.Parent				
			end			
		end)
	end
end