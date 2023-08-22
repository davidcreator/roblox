local btn = script.Parent
local outline = btn:WaitForChild("Outline")

local isHovering = false

btn.MouseEnter:Connect(function()
	
	isHovering = true
	
	outline:TweenSize(UDim2.new(1.03, 0, 1.091, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseLeave:Connect(function()
	
	isHovering = false
	
	outline:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Down:Connect(function()
	
	outline:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Up:Connect(function()
	
	if not isHovering then
		outline:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	else
		outline:TweenSize(UDim2.new(1.03, 0, 1.091, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	end
end)