local btn = script.Parent

local isHovering = false


btn.MouseEnter:Connect(function()
	
	isHovering = true
	
	btn:TweenSize(UDim2.new(0.281, 0, 0.138, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseLeave:Connect(function()
	
	isHovering = false
	
	btn:TweenSize(UDim2.new(0.273, 0, 0.134, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Down:Connect(function()
	
	btn:TweenSize(UDim2.new(0.265, 0, 0.13, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Up:Connect(function()
	
	if not isHovering then
		btn:TweenSize(UDim2.new(0.273, 0, 0.134, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	else
		btn:TweenSize(UDim2.new(0.281, 0, 0.138, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	end
end)