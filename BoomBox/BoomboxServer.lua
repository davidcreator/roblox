local plr = script.Parent.Parent.Parent


local re = script.Parent:WaitForChild("BoomboxRE")

local music = script.Parent.Handle:WaitForChild("Music")


local mps = game:GetService("MarketplaceService")


local ds = game:GetService("DataStoreService")

local musicData = ds:GetDataStore("MusicData")
local musicList = musicData:GetAsync("MusicList - " .. plr.UserId) or {}

re:FireClient(plr, musicList)


re.OnServerEvent:Connect(function(plr, id)
	
	local success, isAudio = pcall(mps.GetProductInfo, mps, id)
	if not success or isAudio.AssetTypeId ~= 3 then return end

	local musicName = mps:GetProductInfo(id).Name
	
	
	music.SoundId = "rbxassetid://" .. id
	music:Play()
	
	
	musicList[id] = musicName
	musicData:SetAsync("MusicList - " .. plr.UserId, musicList)
	
	re:FireClient(plr, musicList)
end)

script.Parent.Equipped:Connect(function()
	re:FireClient(plr, musicList)
end)
script.Parent.Unequipped:Connect(function()
	music:Stop()
end)