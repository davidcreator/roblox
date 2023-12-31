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
			return cashDS:GetAsync(plr.UserId)
		end)
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

	ls.Parent = plr
end)


local rnd = Random.new()

local minTimePerDrop = 2
local maxTimePerDrop = 5

local minReward = 5
local maxReward = 10

local minFallVelocity = -8
local maxFallVelocity = -12

while true do
	
	task.wait(rnd:NextNumber(minTimePerDrop, maxTimePerDrop))
	
	
	local airdrop = script:WaitForChild("Airdrop"):Clone()
	
	local randomPos = Vector3.new(rnd:NextNumber(-1024, 1024), 200, rnd:NextNumber(-1024, 1024))
	local newCF = CFrame.new(randomPos) * CFrame.Angles(0, rnd:NextNumber(0, 2*math.pi), 0)
	airdrop:PivotTo(newCF)

	local atch0 = Instance.new("Attachment")
	atch0.Name = "Attachment0"
	atch0.Parent = airdrop.Crate
	
	local lv = Instance.new("LinearVelocity")
	lv.MaxForce = math.huge
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
	lv.VectorVelocity = Vector3.new(rnd:NextNumber(-5, 5), rnd:NextNumber(maxFallVelocity, minFallVelocity), rnd:NextNumber(-5, 5))
	lv.Attachment0 = atch0
	lv.Parent = airdrop.Crate
	
	local av = Instance.new("AngularVelocity")
	av.MaxTorque = math.huge
	av.RelativeTo = Enum.ActuatorRelativeTo.Attachment0
	av.AngularVelocity = Vector3.new(0, rnd:NextNumber(-1, 1), 0)
	av.Attachment0 = atch0
	av.Parent = airdrop.Crate
	
	
	airdrop.Crate.Touched:Connect(function(hit)
		local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
		
		if plr and hit.Parent.Humanoid.Health > 0 then
			
			airdrop:Destroy()
			
			if not plr:FindFirstChild("DATA FAILED TO LOAD") then
				plr.leaderstats.Cash.Value += rnd:NextInteger(minReward, maxReward)
			end
		end
	end)
	
	
	airdrop.Parent = workspace
	
	
	task.spawn(function()
		repeat 
			task.wait(1)
		until not airdrop or airdrop.Parent ~= workspace or airdrop.Crate.AssemblyLinearVelocity.Y > minFallVelocity
		
		if airdrop and airdrop.Parent == workspace then
			lv:Destroy()
			av:Destroy()
			atch0:Destroy()
			
			airdrop.Crate.Parachute:Destroy()
			airdrop.Parachute.CanCollide = false
			
			game:GetService("Debris"):AddItem(airdrop.Parachute, 5)
		end
	end)
end