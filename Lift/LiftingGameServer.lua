local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("LIFTING SIMULATOR")

--Save data
function saveData(player)
	local weight = player.leaderstats.Weight.Value
	ds:SetAsync(player.UserId .. "Weight", weight)
end

game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for i, player in pairs(game.Players:GetPlayers()) do
		saveData(player)
	end
end)

--Create leaderstats
game.Players.PlayerAdded:Connect(function(player)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local weight = Instance.new("IntValue")
	weight.Name = "Weight"
	weight.Parent = leaderstats
	
	local data = ds:GetAsync(player.UserId .. "Weight") or 0
	
	weight.Value = data
	
	
	local function scaleBody()
		if not player.Character then player.CharacterAdded:Wait() end
		player.Character.Humanoid.HeadScale.Value = 1 + (weight.Value/20)
		player.Character.Humanoid.BodyDepthScale.Value = 1 + (weight.Value/20)
		player.Character.Humanoid.BodyWidthScale.Value = 1 + (weight.Value/20)
		player.Character.Humanoid.BodyHeightScale.Value = 1 + (weight.Value/20)
		
		local tool = player.Character:FindFirstChildOfClass("Tool") or player.Backpack:FindFirstChildOfClass("Tool")
		
		if tool then
			tool.Handle.Mesh.Scale = Vector3.new(
				game.StarterPack.Weight.Handle.Mesh.Scale.X + (weight.Value/20 * game.StarterPack.Weight.Handle.Mesh.Scale.X),
				game.StarterPack.Weight.Handle.Mesh.Scale.Y + (weight.Value/20 * game.StarterPack.Weight.Handle.Mesh.Scale.Y),
				game.StarterPack.Weight.Handle.Mesh.Scale.Z + (weight.Value/20 * game.StarterPack.Weight.Handle.Mesh.Scale.Z)
			)
		end
	end
	
	scaleBody()
	weight:GetPropertyChangedSignal("Value"):Connect(scaleBody)
end)

--Give weight when player lifts
local cooldowns = {}

game.ReplicatedStorage.WeightRE.OnServerEvent:Connect(function(player)
	if cooldowns[player] then return end
	cooldowns[player] = true
	
	player.leaderstats.Weight.Value += 1
	
	wait(0.5)
	cooldowns[player] = false
end)