local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("calendarData")


local dayRewards = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1800, 1900, 2000, 2500, 3000, 3500, 4000, 5000}


function saveData(p, daysParam)
	
	local cash = p.leaderstats.Cash.Value
	
	local days = daysParam or {}
	
	ds:SetAsync(p.UserId, {cash, days})
end


game.Players.PlayerAdded:Connect(function(p)
	
	local ls = Instance.new("Folder", p)
	ls.Name = "leaderstats"
	
	local cash = Instance.new("IntValue", ls)
	cash.Name = "Cash"
	
	
	local data = ds:GetAsync(p.UserId)
	local days = {}
	
	if data then
		
		cash.Value = data[1]
		
		days = data[2]
	end
	
	if os.date("%m") == "12" then
		
		local day = tonumber(os.date("%d"))
		
		if not days[tostring(day)] then
			
			days[tostring(day)] = true
			
			saveData(p, days)

			cash.Value += dayRewards[day]
		end
	end
end)


game.Players.PlayerRemoving:Connect(function(p)
	
	saveData(p, ds:GetAsync(p.UserId)[2])
end)

game:BindToClose(function()
	
	for i, p in pairs(game.Players:GetPlayers()) do
		saveData(p, ds:GetAsync(p.UserId)[2])
	end
end)