--Data saving
local dss = game:GetService("DataStoreService")
local cashDS = dss:GetDataStore("PLAYERS DATA STORE")


function saveData(plr)
	if not plr:FindFirstChild("DATA FAILED TO LOAD") then

		local cash = plr.leaderstats.Cash.Value

		local success, err = nil, nil
		while not success do
			success, err = pcall(function()
				cashDS:SetAsync(plr.UserId, cash)
			end)
			if err then
				warn(err)
			end
			task.wait(0.02)
		end
	end
end

game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for _, plr in pairs(game.Players:GetPlayers()) do
		saveData(plr)
	end
end)

game.Players.PlayerAdded:Connect(function(plr)

	local dataFailedWarning = Instance.new("StringValue")
	dataFailedWarning.Name = "DATA FAILED TO LOAD"
	dataFailedWarning.Parent = plr

	local success, plrData = nil, nil
	while not success do
		success, plrData = pcall(function()
			return cashDS:GetAsync(plr.UserId)
		end)
		task.wait(0.02)
	end
	dataFailedWarning:Destroy()
	
	if not plrData then
		plrData = 0
	end

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"

	local cashVal = Instance.new("IntValue")
	cashVal.Name = "Cash"
	cashVal.Value = plrData
	cashVal.Parent = ls
	
	local bountyVal = Instance.new("IntValue")
	bountyVal.Name = "Bounty"
	bountyVal.Value = 0
	bountyVal.Parent = ls

	ls.Parent = plr
end)



--Bounty handling
local bountyPerKill = 100

local killEvent = game:GetService("ReplicatedStorage"):WaitForChild("BountyReplicatedStorage"):WaitForChild("KillEvent")

killEvent.Event:Connect(function(playerWhoKilled:Player, playerWhoDied:Player)
	
	playerWhoKilled.leaderstats.Bounty.Value += bountyPerKill
	playerWhoKilled.leaderstats.Cash.Value += playerWhoDied.leaderstats.Bounty.Value
	
	playerWhoDied.leaderstats.Bounty.Value = 0
end)

--[[
Call the 

	BindableEvent:Fire(playerWhoKilled, playerWhoDied)

method when you handle the death of a player, such as in the script for a sword.
]]