local char = script.Parent
local humanoid = char:WaitForChild("Humanoid")

local cas = game:GetService("ContextActionService")

local seat = nil

local heightIncrease = 0
local rotation = 0
local movement = 0


function height(actionName, actionState)
	
	if actionName == "Up" and actionState == Enum.UserInputState.Begin then
		heightIncrease = 10
		
	elseif actionName == "Down" and actionState == Enum.UserInputState.Begin then
		heightIncrease = -10
		
	else
		heightIncrease = 0
	end
end

function rotate(actionName, actionState)
	
	if actionName == "Left" and actionState == Enum.UserInputState.Begin then
		rotation = -10
		
	elseif actionName == "Right" and actionState == Enum.UserInputState.Begin then
		rotation = 10
		
	else
		rotation = 0
	end
end

function move(actionName, actionState)
	
	if actionName == "Forward" and actionState == Enum.UserInputState.Begin then
		movement = 20

	elseif actionName == "Backward" and actionState == Enum.UserInputState.Begin then
		movement = -20

	else
		movement = 0
	end
end


humanoid.Seated:Connect(function(active, seatPart)
	
	if active and seatPart:IsA("VehicleSeat") and seatPart.Parent.Name == "Helicopter" then
		
		
		cas:BindAction("Up", height, false, "e")
		cas:BindAction("Down", height, false, "q")
		cas:BindAction("Left", rotate, false, "a")
		cas:BindAction("Right", rotate, false, "d")
		cas:BindAction("Forward", move, false, "w")
		cas:BindAction("Backward", move, false, "s")
		
		seat = seatPart
		
		
	elseif not active then
		
		cas:UnbindAction("Up")
		cas:UnbindAction("Down")
		cas:UnbindAction("Left")
		cas:UnbindAction("Right")
		cas:UnbindAction("Forward")
		cas:UnbindAction("Backward")
		
		seat = nil
	end
end)


game:GetService("RunService").RenderStepped:Connect(function()
	
	if seat then
		
		
		local bp = seat.BodyPosition
		local bg = seat.BodyGyro
		
		bp.Position = seat.Position + Vector3.new(0, heightIncrease, 0) + (seat.CFrame.LookVector * movement)
		bg.CFrame = seat.CFrame * CFrame.Angles(0, rotation, 0)
	end
end)