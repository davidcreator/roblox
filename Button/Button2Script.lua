local btn = script.Parent

local isHovering = false

local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local colourDarkTween = tweenService:Create(btn, tweenInfo, {ImageColor3 = Color3.fromRGB(165, 98, 30)})
local colourBrightTween = tweenService:Create(btn, tweenInfo, {ImageColor3 = Color3.fromRGB(204, 135, 37)})
local colourDefaultTween = tweenService:Create(btn, tweenInfo, {ImageColor3 = Color3.fromRGB(190, 120, 35)})


btn.MouseEnter:Connect(function()
	
	isHovering = true
	
	colourBrightTween:Play()
end)

btn.MouseLeave:Connect(function()
	
	isHovering = false
	
	colourDefaultTween:Play()
end)

btn.MouseButton1Down:Connect(function()
	
	colourDarkTween:Play()
end)

btn.MouseButton1Up:Connect(function()
	
	if not isHovering then
		colourDefaultTween:Play()
	else
		colourBrightTween:Play()
	end
end)