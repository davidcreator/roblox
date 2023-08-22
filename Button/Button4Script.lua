local btn = script.Parent

local isHovering = false

btn.MouseEnter:Connect(function()
	
	isHovering = true
	
	btn:TweenSize(UDim2.new(1.03, 0, 1.091, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseLeave:Connect(function()
	
	isHovering = false
	
	btn:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Down:Connect(function()
	
	btn:TweenSize(UDim2.new(0.97, 0, 0.909, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Up:Connect(function()
	
	if not isHovering then
		btn:TweenSize(UDim2.new(1, 0, 1, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	else
		btn:TweenSize(UDim2.new(1.03, 0, 1.091, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	end
end)