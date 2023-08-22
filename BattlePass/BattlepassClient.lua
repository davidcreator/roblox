--Open and close GUI
local open = false

script.Parent.Position = UDim2.new(0.5, 0, 0.978, 0)

script.Parent.MouseButton1Click:Connect(function()
	
	open = not open
	
	if open then
		script.Parent:TweenPosition(UDim2.new(0.5, 0, 0.676, 0), "InOut", "Quint", 0.5)
	else
		script.Parent:TweenPosition(UDim2.new(0.5, 0, 0.978, 0), "InOut", "Quint", 0.5)
	end
end)

--Tiers UI
local maxTiers = 30
local tier = game.Players.LocalPlayer:WaitForChild("Tier")
script.Parent.BattlepassFrame.TierNumber.Text = "TIER " .. tier.Value

for i = 1, maxTiers do --Set up scrolling frame with tier rewards
	
	local newTier = script.RewardFrame:Clone()
	newTier.Name = i
	newTier.TierNumber.Text = "TIER " .. i
	newTier.RewardName.Text = (i * 100) .. " CASH"
	
	if i <= tier.Value then
		
		newTier.NotClaimedImage:Destroy()
	end
	
	newTier.Parent = script.Parent.BattlepassFrame.RewardsScroller
	
	script.Parent.BattlepassFrame.RewardsScroller.CanvasSize = UDim2.new(0, script.Parent.BattlepassFrame.RewardsScroller.UIListLayout.AbsoluteContentSize.X, 0, 0)
end

tier:GetPropertyChangedSignal("Value"):Connect(function() --Update UI when tier changes
	
	script.Parent.BattlepassFrame.TierNumber.Text = "TIER " .. tier.Value
	
	for i, tierReward in pairs(script.Parent.BattlepassFrame.RewardsScroller:GetChildren()) do
		if tonumber(tierReward.Name) and tonumber(tierReward.Name) <= tier.Value then
			
			if tierReward:FindFirstChild("NotClaimedImage") then tierReward.NotClaimedImage:Destroy() end
		end
	end
end)

--Missions UI
local missionsFolder = game.Players.LocalPlayer:WaitForChild("Missions")

for i, mission in pairs(missionsFolder:GetChildren()) do
	
	local missionAmount = string.gsub(mission.Name, "%D", "")
	
	local missionFrame = script.Parent.BattlepassFrame.MissionsFrame["Mission" .. i]
	missionFrame.Task.Text = mission.Name
	missionFrame.ProgressBarBG.Progress.Text = math.floor(mission.Value) .. "/" .. missionAmount
	
	missionFrame.ProgressBarBG.Bar.Size = UDim2.new(math.clamp(mission.Value / missionAmount, 0, 1), 0, 1, 0)
	
	mission:GetPropertyChangedSignal("Value"):Connect(function()
		
		missionFrame.ProgressBarBG.Progress.Text = math.floor(mission.Value) .. "/" .. missionAmount

		missionFrame.ProgressBarBG.Bar.Size = UDim2.new(math.clamp(mission.Value / missionAmount, 0, 1), 0, 1, 0)
	end)
end

if #missionsFolder:GetChildren() < 1 then --Make sure the right amount of missions is shown
	script.Parent.BattlepassFrame.MissionsFrame:ClearAllChildren()
elseif #missionsFolder:GetChildren() < 2 then
	script.Parent.BattlepassFrame.MissionsFrame.Mission2:Destroy()
	script.Parent.BattlepassFrame.MissionsFrame.Mission3:Destroy()
elseif #missionsFolder:GetChildren() < 3 then
	script.Parent.BattlepassFrame.MissionsFrame.Mission3:Destroy()
end