local frame = script.Parent.SpinFrame
frame.Visible = false

local btn = script.Parent.OpenSpinButton


local lastSpunValue = game.Players.LocalPlayer:WaitForChild("LastSpun")

local re = game.ReplicatedStorage.DailySpinReplicatedStorage.DailySpinRE


btn.MouseButton1Click:Connect(function()
	
	if not frame.Visible then
		
		local timeDiff = os.time() - lastSpunValue.Value
		
		if timeDiff >= 24 * 60 * 60 and frame.Visible == false then
			
			frame.CentrePivot:ClearAllChildren()
			frame.CentrePivot.Rotation = Random.new():NextInteger(0, 360)
			
			frame.SpinButton.SpinText.Text = "SPIN!"
			
			local module = require(game.ReplicatedStorage.DailySpinReplicatedStorage.DailySpinSettings)
			local rewards = module.rewards
			local colours = module.colours
			
			local circumference = frame.CentrePivot.AbsoluteSize.X * math.pi
			local numSectors = #rewards
			
			local absoluteSectorWidth = (circumference / numSectors)
			local sectorWidth = absoluteSectorWidth / frame.CentrePivot.AbsoluteSize.X
			
			for i = #rewards, 2, -1 do
				local j = Random.new():NextInteger(1, i)
				rewards[i], rewards[j] = rewards[j], rewards[i]
			end
			
			for i, reward in pairs(rewards) do
				
				local newSector = script:WaitForChild("SectorPivot"):Clone()
				newSector.Name = i
				
				newSector.Sector.Size = UDim2.new(sectorWidth, 0, 0.5, 0)

				local rotation = (i - 1) * (360 / numSectors)
				newSector.Rotation = rotation
				
				newSector.Sector.RewardAmount.Text = reward
				
				newSector.Sector.ImageColor3 = colours[reward]
				
				newSector.Parent = frame.CentrePivot
			end
			
			frame.Visible = true
		end
		
	else
		frame.Visible = false
	end
end)

frame.SpinButton.MouseButton1Click:Connect(function()
	
	if frame.SpinButton.SpinText.Text == "SPIN!" then
		
		local timeDiff = os.time() - lastSpunValue.Value
		
		if timeDiff >= 24 * 60 * 60 then
			re:FireServer()
		end
		
	else
		frame.Visible = false
	end
end)

re.OnClientEvent:Connect(function(rewardPos, spinTime)
	
	local rotAmount = Random.new():NextInteger(1, 4) * 360
	
	local ts = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(spinTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	
	local goalSector = frame.CentrePivot[rewardPos]
	local sectorRot = goalSector.Rotation
	rotAmount += (360 - sectorRot)
	
	local rotationTween = ts:Create(frame.CentrePivot, tweenInfo, {Rotation = rotAmount})
	rotationTween:Play()
	
	rotationTween.Completed:Wait()
	
	frame.SpinButton.SpinText.Text = "CLAIM!"
end)


while task.wait(1) do
	
	local timeDiff = os.time() - lastSpunValue.Value
	local timeLeft = (24 * 60 * 60) - timeDiff
	
	local h = math.floor(timeLeft / 60 / 60)
	h = string.format("%0.2i", h)
	local m = math.floor((timeLeft - (h * 60 * 60)) / 60)
	m = string.format("%0.2i", m)
	local s = timeLeft - (h * 60 * 60) - (m * 60)
	s = string.format("%0.2i", s)
	
	btn.TimeToNextSpin.Text = h .. ":" .. m .. ":" .. s
	
	if timeDiff >= 24 * 60 * 60 then
		btn.TimeToNextSpin.Visible = false
		btn.ImageColor3 = Color3.fromRGB(255, 255, 255)
		
	else
		btn.TimeToNextSpin.Visible = true
		btn.ImageColor3 = Color3.fromRGB(150, 150, 150)
	end
end