--DATA HANDLING
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("DATA")


function saveData(plr:Player)
	
	if not plr:FindFirstChild("DATA FAILED TO LOAD") then
		
		local plrCash = plr.leaderstats.Cash.Value
		
		local success, err = nil, nil
		while not success do
			success, err = pcall(function()
				ds:SetAsync(plr.UserId, plrCash)
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

	local success, plrCash = nil, nil
	while not success do
		success, plrCash = pcall(function()
			return ds:GetAsync(plr.UserId)
		end)
		task.wait(0.02)
	end
	dataFailedWarning:Destroy()

	if not plrCash then
		plrCash = 0
	end

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"

	local cashVal = Instance.new("IntValue")
	cashVal.Name = "Cash"
	cashVal.Value = plrCash
	cashVal.Parent = ls

	ls.Parent = plr
end)


--GAME LOOP
local minigameModules = game:GetService("ServerStorage"):WaitForChild("MinigameModules")

local minPlayersToStart = 2
local intermissionTime = 5
local timeToTeleportPlayers = 3
local timeAfterEnd = 5

_G.rnd = Random.new()

local statusVal = Instance.new("StringValue")
statusVal.Name = "GAME STATUS"
statusVal.Parent = game:GetService("ReplicatedStorage")


function getPlayerList()
	local plrs = {}
	for _, plr in pairs(game.Players:GetPlayers()) do
		if (plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0) then
			table.insert(plrs, plr)
		end
	end
	return plrs
end


while true do
	
	local plrsInGame = getPlayerList()
	while #plrsInGame < minPlayersToStart do
		statusVal.Value = "Waiting for " .. (minPlayersToStart - #plrsInGame) .. " more player" .. ((minPlayersToStart - #plrsInGame) ~= 1 and "s" or "") .. " to start"
		task.wait(0.2)
		plrsInGame = getPlayerList()
	end
	
	for i = intermissionTime, 0, -1 do
		statusVal.Value = "Game starting in " .. i .. "s"
		task.wait(1)
	end
	
	local allMinigames = minigameModules:GetChildren()
	local chosenMinigame
	while true do
		chosenMinigame = require(allMinigames[_G.rnd:NextInteger(1, #allMinigames)])
		
		if (not chosenMinigame.Configuration["MINIMUM_PLAYERS"] or chosenMinigame.Configuration["MINIMUM_PLAYERS"] <= #plrsInGame) then
			break
		end
	end
	
	statusVal.Value = "Now playing " .. chosenMinigame.Configuration["DISPLAY_NAME"]
	
	task.wait(timeToTeleportPlayers)
	
	local gameEnd = nil
	
	task.spawn(function()
		local gameStart = tick()
		while true do
			
			local timeSinceStart = tick() - gameStart
			local timeLeft = math.clamp(chosenMinigame.Configuration["DURATION"] - timeSinceStart, 0, math.huge)
			
			local mins = tostring(math.floor(timeLeft / 60))
			local secs = math.round(timeLeft - mins*60)
			if string.len(tostring(secs)) < 2 then
				secs = "0" .. tostring(secs)
			end
			
			if (not gameEnd and timeLeft > 0) then
				statusVal.Value = mins .. ":" .. secs
			else
				break
			end
			
			task.wait(0.2)
		end
	end)
	
	gameEnd = chosenMinigame.BeginGame(getPlayerList())
	
	local endMessage = "Game over!"
	if #gameEnd > 0 then
		endMessage = "Winners: "
		for _, winner in pairs(gameEnd) do
			endMessage = endMessage .. winner.Name
			
			if _ == #gameEnd - 1 then
				endMessage = endMessage .. " and "
			elseif _ < #gameEnd then
				endMessage = endMessage .. ", "
			end
			
			winner.leaderstats.Cash.Value += chosenMinigame.Configuration["REWARD"]
			
			winner:LoadCharacter()
		end
	end
	
	statusVal.Value = endMessage
	
	task.wait(timeAfterEnd)
end