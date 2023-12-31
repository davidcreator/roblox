local badgeIds = {
	1338151805,
	1338152217,
	1338152564,
	1338152991,
	1338153317,
	1338162926,
	1581974685,
	2124476827,
	2124647572,
	2124684123,
	2124769992,
	2124769993,
	2124769994,
	2124769995,
	2124773711,
	2125759516,
	2128847177,
	2129021840,
	2129021843,
	2129745218,
	2129745220,
}

local openBtn = script.Parent:WaitForChild("OpenListButton")
local badgeList = script.Parent:WaitForChild("BadgeListBackground")
local closeBtn = badgeList:WaitForChild("CloseButton")
local scrollingFrame = badgeList:WaitForChild("BadgeList")

local badgeTemplate = script:WaitForChild("Badge")

badgeList.Visible = false

openBtn.MouseButton1Click:Connect(function()
	badgeList.Visible = not badgeList.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
	badgeList.Visible = false
end)


local ts = game:GetService("TweenService")
local ti = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

function buttonEffect(button)
	
	local originalSize = button.Size
	local hoverSize = UDim2.new(originalSize.X.Scale * 1.05, originalSize.X.Offset * 1.05, originalSize.Y.Scale * 1.05, originalSize.Y.Offset * 1.05)
	local clickSize = UDim2.new(originalSize.X.Scale * 0.95, originalSize.X.Offset * 0.95, originalSize.Y.Scale * 0.95, originalSize.Y.Offset * 0.95)
	
	local normalTween = ts:Create(button, ti, {Size = originalSize})
	local hoverTween = ts:Create(button, ti, {Size = hoverSize})
	local clickTween = ts:Create(button, ti, {Size = clickSize})
	
	local hovering = false
	
	button.MouseEnter:Connect(function()
		hovering = true
		hoverTween:Play()
	end)
	button.MouseLeave:Connect(function()
		hovering = false
		normalTween:Play()
	end)
	button.MouseButton1Down:Connect(function()
		clickTween:Play()
	end)
	button.MouseButton1Up:Connect(function()
		if hovering then
			hoverTween:Play()
		else
			normalTween:Play()
		end
	end)
end

buttonEffect(openBtn)
buttonEffect(closeBtn)


local badgeFrames = {}
local badgeService = game:GetService("BadgeService")

function createGui()
	
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child.ClassName == badgeTemplate.ClassName then
			child:Destroy()
		end
	end
	for _, badgeFrame in pairs(badgeFrames) do
		badgeFrame:Destroy()
	end
	badgeFrames = {}
	
	for _, badgeId in pairs(badgeIds) do
		
		local badgeInfo = nil 
		local success, err = pcall(function()
			badgeInfo = badgeService:GetBadgeInfoAsync(badgeId)
		end)
		
		if success then
			
			local newFrame = badgeTemplate:Clone()
			newFrame.Name = badgeId
			
			newFrame.BadgeImage.Image = "rbxassetid://" .. badgeInfo.IconImageId
			newFrame.BadgeName.Text = badgeInfo.Name
			newFrame.BadgeDescription.Text = badgeInfo.Description
			
			local userHasBadge = nil 
			success, err = pcall(function()
				userHasBadge = badgeService:UserHasBadgeAsync(game.Players.LocalPlayer.UserId, badgeId)
			end)
			
			if userHasBadge then
				newFrame.ImageColor3 = Color3.fromRGB(255, 255, 255)
			else
				newFrame.ImageColor3 = Color3.fromRGB(150, 150, 150)
			end
			
			table.insert(badgeFrames, newFrame)
		end
	end
end


while true do
	
	if #badgeFrames ~= #badgeIds then
		createGui()
	end
	
	table.sort(badgeFrames, function(a, b)
		return (a.ImageColor3.R > b.ImageColor3.R) or ((a.ImageColor3.R == b.ImageColor3.R) and (a.BadgeName.Text < b.BadgeName.Text))
	end)
	
	for _, badgeFrame in pairs(badgeFrames) do
		badgeFrame.Parent = script
	end
	for _, badgeFrame in pairs(badgeFrames) do
		badgeFrame.Parent = scrollingFrame
	end
	
	task.wait(15)
end