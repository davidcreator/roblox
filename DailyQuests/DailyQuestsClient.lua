local openBtn = script.Parent:WaitForChild("OpenQuestsButton")
local frame = script.Parent:WaitForChild("QuestsFrame")
frame.Visible = false

local tweenDebounce = false

local ogSize = openBtn.Size

openBtn.MouseButton1Down:Connect(function()
	openBtn:TweenSize(ogSize - UDim2.new(0, 2, 0, 2), "In", "Quint", 0.2, true)
end)

openBtn.MouseButton1Click:Connect(function()
	openBtn:TweenSize(ogSize, "In", "Quint", 0.2, true)

	if tweenDebounce then return end
	tweenDebounce = true

	if frame.Visible then
		frame:TweenPosition(UDim2.new(0.5, 0, 0.53, 0), "In", "Quint", 0.2, true)
		task.wait(0.2)
		frame.Visible = false
		tweenDebounce = false

	elseif not frame.Visible then
		frame.Position = UDim2.new(0.5, 0, 0.53, 0)
		frame.Visible = true
		frame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quint", 0.2, true)
		task.wait(0.2)
		tweenDebounce = false
	end
end)


local questsFolder = game.Players.LocalPlayer:WaitForChild("Quests")

local lastRefresh = questsFolder:WaitForChild("LastRefresh").Value
local nextRefresh = lastRefresh + (24*60*60)
task.spawn(function()
	while task.wait(1) do
		local now = os.time()

		local timeDiff = nextRefresh - now

		if timeDiff < 0 then break end

		local hours = math.floor(timeDiff / 60 / 60)
		hours = string.format("%02i", hours)
		local mins = math.floor((timeDiff / 60) - (hours * 60))
		mins = string.format("%02i", mins)
		local secs = timeDiff - (mins * 60) - (hours * 60 * 60)
		secs = string.format("%02i", secs)

		frame:WaitForChild("RefreshTime").Text = "Refreshes in " .. hours .. ":" .. mins .. ":" .. secs
	end

	frame:WaitForChild("RefreshTime").Text = "Rejoin for new quests"
end)


function updateQuestsUI()
	for i, child in pairs(frame.QuestsScroller:GetChildren()) do

		if child.ClassName == script:WaitForChild("QuestLabel").ClassName then
			child:Destroy()
		end
	end

	for i, child in pairs(questsFolder:GetChildren()) do
		if child:IsA("Folder") then

			local newLabel = script:WaitForChild("QuestLabel"):Clone()

			local questDesc = child.Name
			local reward = child.Reward.Value
			local goal = child.Goal.Value

			newLabel.CompletedLabel.Visible = false
			newLabel.BarBackground.ClipsDescendants = true
			newLabel.QuestDescription.Text = questDesc
			if newLabel.QuestDescription:FindFirstChild("TextShadow") then
				newLabel.QuestDescription.TextShadow.Text = questDesc
			end
			newLabel.Reward.Text = "$" .. reward
			if newLabel.Reward:FindFirstChild("TextShadow") then
				newLabel.Reward.TextShadow.Text = "$" .. reward
			end

			newLabel.Parent = frame.QuestsScroller

			local progress = child.Progress
			local maxSizeX = newLabel.BarBackground.Clipping.Size.X.Scale

			local function updateBar()

				local scale = math.clamp(progress.Value / goal, 0, 1) * maxSizeX
				newLabel.BarBackground.BarProgress.Text = math.floor(progress.Value) .. "/" .. goal
				if newLabel.BarBackground.BarProgress:FindFirstChild("TextShadow") then
					newLabel.BarBackground.BarProgress.TextShadow.Text = math.floor(progress.Value) .. "/" .. goal
				end

				newLabel.BarBackground.Clipping:TweenSize(UDim2.new(scale, 0, newLabel.BarBackground.Clipping.Size.Y.Scale, 0), "InOut", "Linear", 0.2, true)
				newLabel.BarBackground.Clipping.Bar:TweenSize(UDim2.new(maxSizeX / scale, 0, 1, 0), "InOut", "Linear", 0.2, true)
			end

			updateBar()
			progress:GetPropertyChangedSignal("Value"):Connect(updateBar)

			child.ChildAdded:Connect(function(added)
				if added.Name == "Completed" then
					newLabel.CompletedLabel.Visible = true
				end
			end)
			if child:FindFirstChild("Completed") then
				newLabel.CompletedLabel.Visible = true
			end
		end

		local contentSizeY = frame.QuestsScroller.UIListLayout.AbsoluteContentSize.Y
		local scale = contentSizeY / frame.AbsoluteSize.Y
		frame.QuestsScroller.CanvasSize = UDim2.new(0, 0, scale, 0)
	end
end


updateQuestsUI()
questsFolder.ChildAdded:Connect(updateQuestsUI)