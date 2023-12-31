local client:Player = game.Players.LocalPlayer

local clientAchievements:Folder = client:WaitForChild("ACHIEVEMENTS FOLDER")

local plrGui:PlayerGui = script.Parent

local mainGui:ScreenGui = plrGui:WaitForChild("AchievementsMainGui")
local openMainButton:TextButton = mainGui:WaitForChild("OpenButton")
local mainFrame:Frame = mainGui:WaitForChild("AchievementsFrame"); mainFrame.Visible = false

local notifGui:ScreenGui = plrGui:WaitForChild("AchievementsNotification"); notifGui.Enabled = false
local notifFrame:Frame = notifGui:WaitForChild("NotificationFrame")
local notifFramePos:UDim2 = notifFrame.Position


local rs:ReplicatedStorage = game.ReplicatedStorage:WaitForChild("AchievementSystemReplicatedStorage")
local remote:RemoteEvent = rs:WaitForChild("AchievementsRemoteEvent")
local allAchievements:ModuleScript = require(rs:WaitForChild("AchievementsList"))


--Open main GUI
openMainButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = not mainFrame.Visible
end)

--Close main GUI
mainFrame:WaitForChild("CloseButton").MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)


--Notification GUI
local achievementsQueue = {}

remote.OnClientEvent:Connect(function(instruction, arg)
	
	if instruction == "AWARD ACHIEVEMENT" then
		
		local achievementInfo = allAchievements[arg]
		if achievementInfo then
			table.insert(achievementsQueue, arg)
			repeat
				task.wait(0.2)
			until table.find(achievementsQueue, arg) == 1
			
			local notifFrameClosedPos = notifFramePos + UDim2.new(notifFrame.Size.X.Scale, 0, 0, 0)
			
			notifFrame.Position = notifFrameClosedPos
			notifFrame.AchievementName.Text = arg
			notifFrame.AchievementImage.Image = type(achievementInfo.ImageId) == "number" and "rbxassetid://" .. achievementInfo.ImageId or achievementInfo.ImageId
			notifFrame.Description.Text = achievementInfo.Description
			
			notifGui.Enabled = true
			
			notifFrame:TweenPosition(notifFramePos, "Out", "Quart", 0.8, true)
			
			task.wait(2)
			
			notifFrame:TweenPosition(notifFrameClosedPos, "In", "Quart", 0.8, true)
			
			task.wait(0.8)
			notifGui.Enabled = false
			
			table.remove(achievementsQueue, table.find(achievementsQueue, arg))
		end
	end
end)


--Update main frame
local function updateMain()
	for _, frame in pairs(mainFrame:WaitForChild("AchievementsScroller"):GetChildren()) do
		if frame:IsA("Frame") or frame:IsA("ImageLabel") or frame:IsA("ImageButton") or frame:IsA("TextButton") or frame:IsA("TextLabel") then
			frame:Destroy()
		end
	end
	
	local newFrames = {}
	
	for achievement, achievementInfo in pairs(allAchievements) do
		local name = achievement
		local image = type(achievementInfo.ImageId) == "number" and "rbxassetid://" .. achievementInfo.ImageId or achievementInfo.ImageId
		local desc = achievementInfo.Description
		local owned = clientAchievements:FindFirstChild(name)
		
		local newFrame = script:WaitForChild("AchievementTemplate"):Clone()
		newFrame.Name, newFrame.AchievementName.Text = name, name
		newFrame.AchievementImage.Image = image
		newFrame.Description.Text = desc
		newFrame.Acquired.Visible = owned
		
		if not owned then
			newFrame.ImageColor3 = Color3.fromRGB(newFrame.ImageColor3.R - 50, newFrame.ImageColor3.G - 50, newFrame.ImageColor3.B - 50)
			for _, uiElement in pairs(newFrame:GetDescendants()) do
				if uiElement:IsA("Frame") then 
					uiElement.BackgroundColor3 = Color3.fromRGB(uiElement.BackgroundColor3.R - 50, uiElement.BackgroundColor3.G - 50, uiElement.BackgroundColor3.B - 50)
				elseif uiElement:IsA("TextLabel") or uiElement:IsA("TextButton") then
					uiElement.BackgroundColor3 = Color3.fromRGB(uiElement.BackgroundColor3.R - 50, uiElement.BackgroundColor3.G - 50, uiElement.BackgroundColor3.B - 50)
					uiElement.TextColor3 = Color3.fromRGB(uiElement.TextColor3.R - 50, uiElement.TextColor3.G - 50, uiElement.TextColor3.B - 50)
				elseif uiElement:IsA("ImageLabel") or uiElement:IsA("ImageButton") then
					uiElement.ImageColor3 = Color3.fromRGB(uiElement.ImageColor3.R - 50, uiElement.ImageColor3.G - 50, uiElement.ImageColor3.B - 50)
				end
			end
		end
		
		table.insert(newFrames, newFrame)
	end
	
	table.sort(newFrames, function(a, b)
		return allAchievements[a.Name].OrderRank < allAchievements[b.Name].OrderRank
	end)
	
	for _, newFrame in pairs(newFrames) do
		newFrame.Parent = mainFrame.AchievementsScroller
	end
end

updateMain()
clientAchievements.ChildAdded:Connect(updateMain)