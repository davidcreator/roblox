local dss = game:GetService("DataStoreService")
local playerDS = dss:GetDataStore("PLAYERS DATA STORE")
local codesDS = dss:GetDataStore("CODES DATA STORE")

local rs = game:GetService("ReplicatedStorage"):WaitForChild("CodesReplicatedStorage")
local re = rs:WaitForChild("RemoteEvent")
local codes = require(rs:WaitForChild("CodesModule"))
local tools = rs:WaitForChild("ToolRewards")

local fireServerDebounce = {}


function saveData(plr)
	if not plr:FindFirstChild("DATA FAILED TO LOAD") then
		
		local cash = plr.leaderstats.Cash.Value
		
		local codeTools = {}
		for _, child in pairs(plr.StarterGear:GetChildren()) do
			if tools:FindFirstChild(child.Name) then
				table.insert(codeTools, child.Name)
			end
		end
		
		local redeemedCodes = {}
		for _, value in pairs(plr["REDEEMED CODES"]:GetChildren()) do
			table.insert(redeemedCodes, value.Name)
		end
		
		local compiledData = {
			Cash = cash;
			Tools = codeTools;
			Redeemed = redeemedCodes;
		}
		
		local success, err = nil, nil
		while not success do
			success, err = pcall(function()
				playerDS:SetAsync(plr.UserId, compiledData)
			end)
			if err then
				warn(err)
			end
			task.wait(0.1)
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
			return playerDS:GetAsync(plr.UserId)
		end)
	end
	dataFailedWarning:Destroy()
	
	if not plrData then
		plrData = {Cash = 0; Tools = {}; Redeemed = {}}
	end
	
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	
	local cashVal = Instance.new("IntValue")
	cashVal.Name = "Cash"
	cashVal.Value = plrData.Cash
	cashVal.Parent = ls
	
	ls.Parent = plr
	
	for _, toolName in pairs(plrData.Tools) do
		if tools:FindFirstChild(toolName) then
			tools[toolName]:Clone().Parent = plr.StarterGear
			
			if plr.Character then
				tools[toolName]:Clone().Parent = plr.Backpack
			end
		end
	end
	
	local redeemedFolder = Instance.new("Folder")
	redeemedFolder.Name = "REDEEMED CODES"
	
	for _, redeemedCode in pairs(plrData.Redeemed) do
		local value = Instance.new("StringValue")
		value.Name = redeemedCode
		value.Parent = redeemedFolder
	end
	
	redeemedFolder.Parent = plr
end)


function giveReward(plr, code)
	local redeemedValue = Instance.new("StringValue")
	redeemedValue.Name = code
	redeemedValue.Parent = plr["REDEEMED CODES"]
	
	re:FireClient(plr, "SUCCESS", "Successfully redeemed!")
	
	for _, reward in pairs(codes[code].reward) do
		if type(reward) == "string" then
			local splitReward = string.split(reward, " ")
			local rewardAmount = tonumber(splitReward[1])
			local rewardType = splitReward[2]

			if plr.Character and plr.Character:FindFirstChild("Humanoid") then
				local hasProperty = false
				hasProperty = pcall(function()
					local checkForProperty = plr.Character.Humanoid[rewardType]
				end)
				if hasProperty then
					plr.Character.Humanoid[rewardType] = rewardAmount
				end
			end

			if plr.leaderstats:FindFirstChild(rewardType) then
				plr.leaderstats[rewardType].Value += rewardAmount
			end

		elseif reward:IsA("Tool") then
			reward:Clone().Parent = plr.StarterGear
			if plr.Character then
				reward:Clone().Parent = plr.Backpack
			end
		end
	end
end


re.OnServerEvent:Connect(function(plr, instruction, value)
	
	if not fireServerDebounce[plr] then
		fireServerDebounce[plr] = true
		
		if instruction == "REDEEM CODE" then
			local codeInfo = codes[value]
			
			if not codeInfo then
				re:FireClient(plr, "ERROR", "Code not found!")
				
			else
				if (codeInfo.expiresAt and os.time() > codeInfo.expiresAt) then
					re:FireClient(plr, "ERROR", "Code has expired!")
					
				else
					if (not codeInfo.repeatable and plr["REDEEMED CODES"]:FindFirstChild(value)) then
						re:FireClient(plr, "ERROR", "Already redeemed!")
						
					else
						local maxRedeems = codeInfo.maxRedeems
						
						if maxRedeems then
							local getSucc, codeData = nil, nil
							getSucc, codeData = pcall(function()
								return codesDS:GetAsync(value)
							end)
							
							if not getSucc then
								re:FireClient(plr, "ERROR", "Something went wrong.. Try again.")
								
							else
								if not codeData then 
									codeData = 0 
								end
								
								if codeData < maxRedeems then
									local setSucc, err = pcall(function()
										codesDS:SetAsync(value, codeData + 1)
									end)
									
									if setSucc then
										giveReward(plr, value)
										
									else
										re:FireClient(plr, "ERROR", "Something went wrong.. Try again.")
									end
									
								else
									re:FireClient(plr, "ERROR", "Code redeemed by other players.")
								end
							end
						
						else
							giveReward(plr, value)
						end
					end
				end
			end
		end
		
		task.wait(1)
		fireServerDebounce[plr] = false
	end
end)