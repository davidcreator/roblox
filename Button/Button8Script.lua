local btn = script.Parent
local btnText = btn:WaitForChild("BtnText")

local btnHoverArea = btn.Parent

local lineTop = btnHoverArea:WaitForChild("LineTop")
local lineBottom = btnHoverArea:WaitForChild("LineBottom")

local isHovering = false

local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local btnSizeInTween = tweenService:Create(btn, tweenInfo, {Size = UDim2.new(0.001, 0, 1, 0), ImageTransparency = 1})
local btnSizeOutTween = tweenService:Create(btn, tweenInfo, {Size = UDim2.new(1, 0, 1, 0), ImageTransparency = 0})

local textTransparentTween = tweenService:Create(btnText, tweenInfo, {TextTransparency = 1}) 
local textOpaqueTween = tweenService:Create(btnText, tweenInfo, {TextTransparency = 0})

local bottomLineTweenOut = tweenService:Create(lineBottom, tweenInfo, {Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 0})
local bottomLineTweenIn = tweenService:Create(lineBottom, tweenInfo, {Size = UDim2.new(0, 0, 0, 1), BackgroundTransparency = 1})
local topLineTweenOut = tweenService:Create(lineTop, tweenInfo, {Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 0})
local topLineTweenIn = tweenService:Create(lineTop, tweenInfo, {Size = UDim2.new(0, 0, 0, 1), BackgroundTransparency = 1})


local function hoverTween()
	
	btnSizeOutTween:Cancel()
	textOpaqueTween:Cancel()
	bottomLineTweenIn:Cancel()
	topLineTweenIn:Cancel()
	
	btnSizeInTween:Play()
	textTransparentTween:Play()
	bottomLineTweenOut:Play()
	topLineTweenOut:Play()
end

local function hoverTweenReverse()

	btnSizeInTween:Cancel()
	textTransparentTween:Cancel()
	bottomLineTweenOut:Cancel()
	topLineTweenOut:Cancel()
	
	btnSizeOutTween:Play()
	textOpaqueTween:Play()
	bottomLineTweenIn:Play()
	topLineTweenIn:Play()
end


btnHoverArea.MouseEnter:Connect(function()
	
	isHovering = true
	
	hoverTween()
end)

btnHoverArea.MouseLeave:Connect(function()
	
	isHovering = false
	
	hoverTweenReverse()
end)

btnHoverArea.MouseButton1Down:Connect(function()
	
	hoverTweenReverse()
end)

btnHoverArea.MouseButton1Up:Connect(function()
	
	if not isHovering then
		hoverTweenReverse()
	else
		hoverTween()
	end
end)