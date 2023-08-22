local colourWheel = script.Parent:WaitForChild("ColourWheel")
local wheelPicker = colourWheel:WaitForChild("Picker")

local darknessPicker = script.Parent:WaitForChild("DarknessPicker")
local darknessSlider = darknessPicker:WaitForChild("Slider")

local colourDisplay = script.Parent:WaitForChild("ColourDisplay")


local uis = game:GetService("UserInputService")


local buttonDown = false
local movingSlider = false


local function updateColour(centreOfWheel)
	
	
	local colourPickerCentre = Vector2.new(
		colourWheel.Picker.AbsolutePosition.X + (colourWheel.Picker.AbsoluteSize.X/2),
		colourWheel.Picker.AbsolutePosition.Y + (colourWheel.Picker.AbsoluteSize.Y/2)
	)
	local h = (math.pi - math.atan2(colourPickerCentre.Y - centreOfWheel.Y, colourPickerCentre.X - centreOfWheel.X)) / (math.pi * 2)
	
	local s = (centreOfWheel - colourPickerCentre).Magnitude / (colourWheel.AbsoluteSize.X/2)
	
	local v = math.abs((darknessSlider.AbsolutePosition.Y - darknessPicker.AbsolutePosition.Y) / darknessPicker.AbsoluteSize.Y - 1)
	
	
	local hsv = Color3.fromHSV(math.clamp(h, 0, 1), math.clamp(s, 0, 1), math.clamp(v, 0, 1))
	
	
	colourDisplay.ImageColor3 = hsv
	darknessPicker.UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, hsv), 
		ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
	}
end


colourWheel.MouseButton1Down:Connect(function()
	buttonDown = true
end)

darknessPicker.MouseButton1Down:Connect(function()
	movingSlider = true
end)


uis.InputEnded:Connect(function(input)
	
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	
	buttonDown = false
	movingSlider = false
end)


uis.InputChanged:Connect(function(input)
	
	if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	
	
	local mousePos = uis:GetMouseLocation() - Vector2.new(0, game:GetService("GuiService"):GetGuiInset().Y)
	
	local centreOfWheel = Vector2.new(colourWheel.AbsolutePosition.X + (colourWheel.AbsoluteSize.X/2), colourWheel.AbsolutePosition.Y + (colourWheel.AbsoluteSize.Y/2))
	
	local distanceFromWheel = (mousePos - centreOfWheel).Magnitude
	
	
	if distanceFromWheel <= colourWheel.AbsoluteSize.X/2 and buttonDown then
		
		wheelPicker.Position = UDim2.new(0, mousePos.X - colourWheel.AbsolutePosition.X, 0, mousePos.Y - colourWheel.AbsolutePosition.Y)

		
	elseif movingSlider then
		
		darknessSlider.Position = UDim2.new(darknessSlider.Position.X.Scale, 0, 0, 
			math.clamp(
			mousePos.Y - darknessPicker.AbsolutePosition.Y, 
			0, 
			darknessPicker.AbsoluteSize.Y)
		)	
	end
	
	
	updateColour(centreOfWheel)
end)