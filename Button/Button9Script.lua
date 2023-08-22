local btn = script.Parent
local pulseBtn = btn:WaitForChild("Pulse")

local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local function pulse()
	
	local pulseBtnClone = pulseBtn:Clone()
	pulseBtnClone.Parent = btn
	
	local tweenFade = tweenService:Create(pulseBtnClone, tweenInfo, {ImageTransparency = 1})
	
	pulseBtnClone:TweenSize(UDim2.new(2, 0, 2, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quint, 1)
	tweenFade:Play()
end


btn.MouseEnter:Connect(function()

	pulse()
end)

btn.MouseButton1Down:Connect(function()
	
	pulse()
end)