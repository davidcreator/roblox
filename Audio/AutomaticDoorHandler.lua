local lDoor = script.Parent.LeftDoor
local rDoor = script.Parent.RightDoor

local lDoorClosed = script.Parent.LeftDoorClosedPos
local lDoorOpened = script.Parent.LeftDoorOpenedPos

local rDoorClosed = script.Parent.RightDoorClosedPos
local rDoorOpened = script.Parent.RightDoorOpenedPos


local sensor = script.Parent.Sensor


local isOpen = false


local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(1.4, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local lTweenOpen = tweenService:Create(lDoor, tweenInfo, {CFrame = lDoorOpened.CFrame})
local lTweenClose = tweenService:Create(lDoor, tweenInfo, {CFrame = lDoorClosed.CFrame})

local rTweenOpen = tweenService:Create(rDoor, tweenInfo, {CFrame = rDoorOpened.CFrame})
local rTweenClose = tweenService:Create(rDoor, tweenInfo, {CFrame = rDoorClosed.CFrame})


while wait() do
	
	local plrs = game.Players:GetPlayers()
	
	for i, plr in pairs(plrs) do
		
		local char = plr.Character or plr.CharacterAdded:Wait()
		local hrp = char:FindFirstChild("HumanoidRootPart")
		
		if not hrp then return end
		
		
		local magnitude = (hrp.Position - sensor.Position).Magnitude
		
		
		if magnitude < 16 then
			
			if isOpen then return end
			
			isOpen = true
			
			
			lTweenOpen:Play()
			rTweenOpen:Play()
			
			
			wait(3)
			
			
			lTweenClose:Play()
			rTweenClose:Play()
			
			
			isOpen = false
			
		end
	end	
end