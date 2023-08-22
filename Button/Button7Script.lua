local btn = script.Parent
local uiGradient = btn:WaitForChild("UIGradient")

local isHovering = false

local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local gradientRestoreTween = tweenService:Create(uiGradient, tweenInfo, {Offset = Vector2.new(-0.35, 0)})
local gradientAddTween = tweenService:Create(uiGradient, tweenInfo, {Offset = Vector2.new(1, 0)})


btn.MouseEnter:Connect(function()
	
	isHovering = true
	
	gradientAddTween:Play()
end)

btn.MouseLeave:Connect(function()
	
	isHovering = false
	
	gradientRestoreTween:Play()
end)

btn.MouseButton1Down:Connect(function()
	
	gradientRestoreTween:Play()
end)

btn.MouseButton1Up:Connect(function()
	
	if not isHovering then
		gradientRestoreTween:Play()
	else
		gradientAddTween:Play()
	end
end)