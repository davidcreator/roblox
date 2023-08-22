local door = script.Parent.Door

local lever = script.Parent.Lever

local leverOff = script.Parent.LeverOff
local leverOn = script.Parent.LeverOn

local cd = lever:WaitForChild("ClickDetector")


local ts = game:GetService("TweenService")


local isOpen = false


cd.MouseClick:Connect(function()
	
	isOpen = not isOpen
	
	
	if isOpen then	
		
		ts:Create(lever, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {CFrame = leverOn.CFrame}):Play()
			
		door.Transparency = 1
		door.CanCollide = false
		
		
	else
		
		ts:Create(lever, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut), {CFrame = leverOff.CFrame}):Play()

		door.Transparency = 0
		door.CanCollide = true
	end
end)