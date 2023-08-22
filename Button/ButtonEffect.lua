local button = script.Parent:WaitForChild("Button")
local shadow = script.Parent:WaitForChild("ButtonShadow")

local glow = button:WaitForChild("Glow")
glow.ImageTransparency = 1


local originalPos = button.Position
local buttonOffset = button.Position.Y.Scale - shadow.Position.Y.Scale


local tweenService = game:GetService("TweenService")
local glowTI = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)


button.MouseEnter:Connect(function()
	
	local btnPosition = button.Position - UDim2.new(0, 0, buttonOffset/2, 0)
	
	button:TweenPosition(btnPosition, "InOut", "Quint", 0.25, true)
	
	script.HoverSound:Play()
end)

button.MouseLeave:Connect(function()

	button:TweenPosition(originalPos, "Out", "Bounce", 0.25, true)
	
	local glowTween = tweenService:Create(glow, glowTI, {ImageTransparency = 1})
	glowTween:Play()
end)


button.MouseButton1Down:Connect(function()

	button:TweenPosition(shadow.Position, "InOut", "Quint", 0.5, true)
		
	local glowTween = tweenService:Create(glow, glowTI, {ImageTransparency = 0})
	glowTween:Play()
	
	script.ButtonPress:Play()
end)


button.MouseButton1Up:Connect(function()
	
	button:TweenPosition(originalPos, "Out", "Bounce", 0.25, true)
	
	local glowTween = tweenService:Create(glow, glowTI, {ImageTransparency = 1})
	glowTween:Play()
	
	script.ButtonRelease:Play()
end)