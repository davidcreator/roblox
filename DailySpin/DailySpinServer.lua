local dss =	game:GetService("DataStoreService")
local ds = dss:GetDataStore("DAILY SPINS DATA STORE")


function save(plr)
	
	local cash = plr.leaderstats.Cash.Value
	local lastSpun = plr.LastSpun.Value
	
	local combinedData = {cash, lastSpun}
	
	ds:SetAsync(plr.UserId, combinedData)
end

game.Players.PlayerRemoving:Connect(save)

game:BindToClose(function()
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		save(plr)
	end
end)


game.Players.PlayerAdded:Connect(function(plr)
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr
	
	local cashValue = Instance.new("IntValue")
	cashValue.Name = "Cash"
	cashValue.Parent = ls
	
	local lastSpunValue = Instance.new("IntValue")
	lastSpunValue.Name = "LastSpun"
	lastSpunValue.Parent = plr
	
	
	local loadedData = ds:GetAsync(plr.UserId) or {0, 0}
	
	local cash = loadedData[1]
	local lastSpun = loadedData[2]
	
	cashValue.Value = cash
	lastSpunValue.Value = lastSpun
end)


local remoteEvent = game.ReplicatedStorage:WaitForChild("DailySpinReplicatedStorage"):WaitForChild("DailySpinRE")

local plrsSpinning = {}


remoteEvent.OnServerEvent:Connect(function(plr)
	
	local lastSpunValue = plr.LastSpun
	local timeSince = os.time() - lastSpunValue.Value
	
	if timeSince >= 24*60*60 and not plrsSpinning[plr] then
		plrsSpinning[plr] = true
		
		local spinRewards = require(game.ReplicatedStorage.DailySpinReplicatedStorage:WaitForChild("DailySpinSettings")).rewards
		
		local rewardPos = math.random(1, #spinRewards)
		local reward = spinRewards[rewardPos]
		
		local spinTime = Random.new():NextNumber(3, 5)
		
		remoteEvent:FireClient(plr, rewardPos, spinTime)
		
		task.wait(spinTime)
		
		lastSpunValue.Value = os.time()
		plr.leaderstats.Cash.Value += reward
		
		plrsSpinning[plr] = false
	end
end)