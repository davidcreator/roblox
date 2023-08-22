local leftFrame = script.Parent:WaitForChild("LeftBG"):WaitForChild("LeftFrame")
local rightFrame = script.Parent:WaitForChild("RightBG"):WaitForChild("RightFrame")


local ts = game:GetService("TweenService")
local ti = TweenInfo.new(5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)


local numValue = Instance.new("NumberValue")


numValue.Changed:Connect(function()
	
	
	local rightRot = math.clamp(numValue.Value - 180, -180, 0)
	
	rightFrame.Rotation = rightRot
	
	
	if numValue.Value <= 180 then
		
		leftFrame.Visible = false
		
		
	else
		
		local leftRot = math.clamp(numValue.Value - 360, -180, 0)
		
		leftFrame.Rotation = leftRot
		
		leftFrame.Visible = true
	end
end)


function progressBar()
	
	numValue.Value = 0

	local progressTween = ts:Create(numValue, ti, {Value = 360})
	progressTween:Play()
end


progressBar()