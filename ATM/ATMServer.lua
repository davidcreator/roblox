local re = game.ReplicatedStorage:WaitForChild("ATMRemoteEvent")

local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("ATM")

local pps = game:GetService("ProximityPromptService")


function saveData(plr)

	local cash = plr.leaderstats.Cash.Value

	pcall(function()
		ds:SetAsync(plr.UserId .. "Cash", cash)
	end)
end


game.Players.PlayerAdded:Connect(function(plr)

	local ls = Instance.new("Folder", plr)
	ls.Name = "leaderstats"

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = ls

	local plrCash
	pcall(function()
		plrCash = ds:GetAsync(plr.UserId .. "Cash")
	end)
	
	local depositedCash
	pcall(function()
		depositedCash = ds:GetAsync(plr.UserId .. "Deposited")
	end)
	
	if not depositedCash then
		
		ds:SetAsync(plr.UserId .. "Deposited", 0)
	end

	cash.Value = plrCash or 0
end)


game.Players.PlayerRemoving:Connect(saveData)

game:BindToClose(function()

	for i, plr in pairs(game.Players:GetPlayers()) do

		saveData(plr)
	end
end)


pps.PromptTriggered:Connect(function(prompt, plr)

	if prompt.Name == "ATMProximityPrompt" then

		local cashStored

		pcall(function()
			cashStored = ds:GetAsync(plr.UserId .. "Deposited")
		end)

		if cashStored then

			re:FireClient(plr, cashStored)
		end
	end
end)


re.OnServerEvent:Connect(function(plr, amount, option)

	if amount and option and tonumber(amount) then

		local cashStored

		pcall(function()
			cashStored = ds:GetAsync(plr.UserId .. "Deposited")
		end)

		if not cashStored then return end

		if option == "deposit" then

			if tonumber(amount) <= plr.leaderstats.Cash.Value then

				plr.leaderstats.Cash.Value -= amount

				cashStored += amount
			end

		elseif option == "withdraw" then

			if tonumber(amount) <= cashStored then

				plr.leaderstats.Cash.Value += amount

				cashStored -= amount
			end
		end

		pcall(function()
			ds:SetAsync(plr.UserId .. "Deposited", cashStored)
		end)
	end
end)