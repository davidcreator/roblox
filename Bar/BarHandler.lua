local bar = script.Parent

local heightTemplate = script:WaitForChild("PlayerHeight")


local goingUp = false


local maxHeight = workspace.HeightPart.Size.Y
local minHeight = 0

local heightDifference = maxHeight - minHeight


local increments = 1 / heightDifference



game:GetService("RunService").RenderStepped:Connect(function()
	
	
	for i, child in pairs(bar:GetChildren()) do
		
		if child:IsA("Frame") then child:Destroy() end
	end
	
	
	for i, plr in pairs(game.Players:GetPlayers()) do


		local heightIndicator = heightTemplate:Clone()

		local plrImage = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		heightIndicator.PlayerImage.Image = plrImage

		heightIndicator.Parent = bar


		local char = plr.Character or plr.CharacterAdded:Wait()
		local hrp = char:WaitForChild("HumanoidRootPart")
			

		local yHeight = math.clamp(hrp.Position.Y, minHeight, maxHeight)
			
		local yPos

		if goingUp then
			yPos = yHeight * increments

		else
			yPos = (maxHeight - yHeight) * increments
		end
		
		heightIndicator.Position = UDim2.new(heightIndicator.Position.X.Scale, heightIndicator.Position.X.Offset, yPos, 0)
	end
end)