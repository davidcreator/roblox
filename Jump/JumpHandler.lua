local startingJump = 0

local increment = 1
local period = 1

function calculateJumpIncrease(wins)
	
	local increase = increment + wins
	return increase
end


local dss = game:GetService("DataStoreService")
local datastore = dss:GetDataStore("DATA STORE")


function saveData(plr)
	if not plr:FindFirstChild("DATA FAILED TO LOAD") then

		local jump = plr.leaderstats.Jump.Value
		local wins = plr.leaderstats.Wins.Value
		
		local compiledData = {jump, wins}

		local success, err = nil, nil
		while not success do
			success, err = pcall(function()
				datastore:SetAsync(plr.UserId, compiledData)
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
			return datastore:GetAsync(plr.UserId)
		end)
		task.wait(0.02)
	end
	dataFailedWarning:Destroy()

	if not plrData then
		plrData = {startingJump, 0}
	end

	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"

	local jumpVal = Instance.new("IntValue")
	jumpVal.Name = "Jump"
	jumpVal.Value = plrData[1]
	jumpVal.Parent = ls

	local winsVal = Instance.new("IntValue")
	winsVal.Name = "Wins"
	winsVal.Value = plrData[2]
	winsVal.Parent = ls

	ls.Parent = plr
	
	local char = plr.Character or plr.CharacterAdded:Wait()
	char:WaitForChild("Humanoid").JumpHeight = jumpVal.Value
	
	plr.CharacterAdded:Connect(function(char)
		char:WaitForChild("Humanoid").JumpHeight = jumpVal.Value
	end)
end)


function handleWinPad(winpad)
	
	local onDebounce = {}
	local debounceTime = 5
	
	winpad.Touched:Connect(function(hit)
		
		local plr = game.Players:GetPlayerFromCharacter(hit.Parent) or game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
		
		if plr and not onDebounce[plr] then
			onDebounce[plr] = true
			
			plr:LoadCharacter()
			
			plr.leaderstats.Jump.Value = startingJump
			plr.leaderstats.Wins.Value += tonumber(winpad.Name) or 1
			
			task.wait(debounceTime)
			onDebounce[plr] = nil
		end
	end)
end

for _, winpad in pairs(workspace:WaitForChild("WinPads"):GetChildren()) do
	handleWinPad(winpad)
end

workspace.WinPads.ChildAdded:Connect(handleWinPad)


while true do
	
	task.wait(period)
	
	for _, plr in pairs(game.Players:GetPlayers()) do
		
		local plrLS = plr:FindFirstChild("leaderstats")
		if plrLS then
			local plrJump = plrLS:FindFirstChild("Jump")
			local plrWins = plrLS:FindFirstChild("Wins")
			
			if plrJump and plrWins then
				local increase = calculateJumpIncrease(plrWins.Value)
				plrJump.Value += increase
				
				if plr.Character and plr.Character:FindFirstChild("Humanoid") then
					plr.Character.Humanoid.JumpHeight = plrJump.Value
				end
			end
		end
	end
end