local colourGradientFrame = script.Parent.ColourGradientFrame
local colourSlider = colourGradientFrame:WaitForChild("Slider")

local darknessGradientFrame =  script.Parent.DarknessGradientFrame
local darknessSlider = darknessGradientFrame:WaitForChild("Slider")

local colourPreview = script.Parent.ColourPreview


local mouse = game.Players.LocalPlayer:GetMouse()

local movingColourSlider = false
local movingDarknessSlider = false


colourSlider.MouseButton1Down:Connect(function()

	movingColourSlider = true
end)
colourGradientFrame.MouseButton1Down:Connect(function()

	movingColourSlider = true
end)

darknessSlider.MouseButton1Down:Connect(function()

	movingDarknessSlider = true
end)
darknessGradientFrame.MouseButton1Down:Connect(function()

	movingDarknessSlider = true
end)


colourSlider.MouseButton1Up:Connect(function()

	movingColourSlider = false
end)
colourGradientFrame.MouseButton1Up:Connect(function()

	movingColourSlider = false
end)

darknessSlider.MouseButton1Up:Connect(function()

	movingDarknessSlider = false
end)
darknessGradientFrame.MouseButton1Up:Connect(function()

	movingDarknessSlider = false
end)


mouse.Button1Up:Connect(function()

	movingColourSlider = false
	movingDarknessSlider = false
end)



mouse.Move:Connect(function()

	if movingColourSlider then

		local xOffset = (mouse.X - colourGradientFrame.AbsolutePosition.X)
		
		xOffset = math.clamp(xOffset, 0, colourGradientFrame.AbsoluteSize.X)

		local sliderPosNew = UDim2.new(0, xOffset, colourSlider.Position.Y)
		colourSlider.Position = sliderPosNew
	end
	
	if movingDarknessSlider then
		
		local xOffset = (mouse.X - colourGradientFrame.AbsolutePosition.X)

		xOffset = math.clamp(xOffset, 0, colourGradientFrame.AbsoluteSize.X)

		local sliderPosNew = UDim2.new(0, xOffset, colourSlider.Position.Y)
		darknessSlider.Position = sliderPosNew
	end
end)



function returnColour(percentage, gradientKeyPoints)

	local leftColour = gradientKeyPoints[1]
	local rightColour = gradientKeyPoints[#gradientKeyPoints]
	
	local lerpPercent = 0.5
	local colour = leftColour.Value


	for i = 1, #gradientKeyPoints - 1 do
		
		if gradientKeyPoints[i].Time <= percentage and gradientKeyPoints[i + 1].Time >= percentage then
			
			leftColour = gradientKeyPoints[i]
			rightColour = gradientKeyPoints[i + 1]
			
			lerpPercent = (percentage - leftColour.Time) / (rightColour.Time - leftColour.Time)
			
			colour = leftColour.Value:Lerp(rightColour.Value, lerpPercent)
			
			return colour
		end
	end
end

function updateColourPreview()
	
	local colourMinXPos = colourGradientFrame.AbsolutePosition.X
	local colourMaxXPos = colourMinXPos + colourGradientFrame.AbsoluteSize.X

	local colourXPixelSize = colourMaxXPos - colourMinXPos

	local colourSliderX = colourSlider.AbsolutePosition.X

	local colourXPos = (colourSliderX - colourMinXPos) / colourXPixelSize
	
	
	local darknessMinXPos = darknessGradientFrame.AbsolutePosition.X
	local darknessMaxXPos = darknessMinXPos + darknessGradientFrame.AbsoluteSize.X

	local darknessXPixelSize = darknessMaxXPos - darknessMinXPos

	local darknessSliderX = darknessSlider.AbsolutePosition.X

	local darknessXPos = (darknessSliderX - darknessMinXPos) / darknessXPixelSize


	local darkness = returnColour(darknessXPos, darknessGradientFrame.DarknessGradient.Color.Keypoints)
	local darknessR, darknessG, darknessB = 255 - math.floor(darkness.R * 255), 255 - math.floor(darkness.G * 255), 255 - math.floor(darkness.B * 255)
	
	
	local colour = returnColour(colourXPos, colourGradientFrame.ColourGradient.Color.Keypoints)
	local colourR, colourG, colourB = math.floor(colour.R * 255), math.floor(colour.G * 255), math.floor(colour.B * 255)
	
	local resultColour = Color3.fromRGB(colourR - darknessR, colourG - darknessG, colourB - darknessB)

	colourPreview.BackgroundColor3 = resultColour
end


colourSlider:GetPropertyChangedSignal("Position"):Connect(updateColourPreview)
darknessSlider:GetPropertyChangedSignal("Position"):Connect(updateColourPreview)