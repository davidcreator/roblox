local screenGui = script.Parent.Parent
screenGui.IgnoreGuiInset = true
screenGui.Enabled = true

local bg = screenGui:WaitForChild("Background")

local logo = bg:WaitForChild("Logo")
local uiGradient = logo:WaitForChild("UIGradient")

local playBtn = bg:WaitForChild("PlayButton")
local hasClickedPlay = false

playBtn.Position = UDim2.new(0.5, 0,1, 0)
uiGradient.Offset = Vector2.new(0, 0)

local tweenService = game:GetService("TweenService")
local tweenInfoFade = TweenInfo.new(6, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
local tweenInfoHover = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local fadeInTween = tweenService:Create(uiGradient, tweenInfoFade, {Offset = Vector2.new(0, -1)})
fadeInTween:Play()

fadeInTween.Completed:Wait()
wait(0.2)

playBtn:TweenPosition(UDim2.new(0.5, 0,0.741, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quint, 1)

wait(1)

playBtn.MouseButton1Click:Connect(function()
	
	if hasClickedPlay then return end
	hasClickedPlay = true
	
	bg:TweenPosition(UDim2.new(0.5, 0, -0.5, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 5)
	
	wait(5)
	
	bg.Parent:Destroy()
end)