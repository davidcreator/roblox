local btn = script.Parent
local btnText = btn:WaitForChild("BtnText")

local isHovering = false

local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local giveStrokeTween = tweenService:Create(btnText, tweenInfo, {TextStrokeTransparency = 0})
local removeStrokeTween = tweenService:Create(btnText, tweenInfo, {TextStrokeTransparency = 1})


btn.MouseEnter:Connect(function()
	
	isHovering = true
	
	giveStrokeTween:Play()
end)

btn.MouseLeave:Connect(function()
	
	isHovering = false
	
	removeStrokeTween:Play()
end)

btn.MouseButton1Down:Connect(function()
	
	removeStrokeTween:Play()
end)

btn.MouseButton1Up:Connect(function()
	
	if not isHovering then
		removeStrokeTween:Play()
	else
		giveStrokeTween:Play()
	end
end)