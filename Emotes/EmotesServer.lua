local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("EmotesDS")


local repl = game.ReplicatedStorage:WaitForChild("EmotesReplicatedStorage")
local re = repl:WaitForChild("RE")
local allEmotes = repl:WaitForChild("Emotes")


--Saving data
function save(plr)
	
	local cash = plr.leaderstats.Cash.Value
	
	local ownedEmotes = plr.Emotes:GetChildren()
	local emoteNames = {}
	
	for i, emote in pairs(ownedEmotes) do
		table.insert(emoteNames, emote.Name)
	end
	
	local combinedData = {cash, emoteNames}
	
	ds:SetAsync(plr.UserId, combinedData)
end

game.Players.PlayerRemoving:Connect(save)

game:BindToClose(function()
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		save(plr)
	end
end)


--Loading data
game.Players.PlayerAdded:Connect(function(plr)
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr	
	
	local cashV = Instance.new("IntValue")
	cashV.Name = "Cash"
	cashV.Parent = ls
	
	
	local emotesF = Instance.new("Folder")
	emotesF.Name = "Emotes"
	emotesF.Parent = plr
	
	
	local data = ds:GetAsync(plr.UserId) or {1000, {}}
	
	cashV.Value += data[1]
	
	for i, emote in pairs(data[2]) do
		
		if allEmotes:FindFirstChild(emote) then
			allEmotes[emote]:Clone().Parent = emotesF
		end
	end
end)


--Handling purchases
re.OnServerEvent:Connect(function(plr, emoteN)
	
	if emoteN and allEmotes:FindFirstChild(emoteN) and allEmotes[emoteN]:FindFirstChild("PRICE") then
		
		local price = allEmotes[emoteN].PRICE.Value
		local pCash = plr.leaderstats.Cash
		
		local pEmotes = plr.Emotes
		
		if pCash.Value >= price and not pEmotes:FindFirstChild(emoteN) then
			pCash.Value -= price
			
			allEmotes[emoteN]:Clone().Parent = pEmotes
		end
	end
end)