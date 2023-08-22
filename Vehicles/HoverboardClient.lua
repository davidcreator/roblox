local uis = game:GetService("UserInputService")
local cas = game:GetService("ContextActionService")

local re = game.ReplicatedStorage:WaitForChild("HoverboardRE")

local currentHoverboard = nil


local rotation = 0
local movement = 0


uis.InputBegan:Connect(function(inp, processed)
	
	if inp.KeyCode == Enum.KeyCode.F and not processed then
		
		re:FireServer()
		
		currentHoverboard = nil
		
		rotation = 0
		movement = 0
		
		cas:UnbindAction("LeftHoverboard")
		cas:UnbindAction("RightHoverboard")
		cas:UnbindAction("ForwardHoverboard")
		cas:UnbindAction("BackwardHoverboard")
	end
end)
	

re.OnClientEvent:Connect(function(board)
	
	currentHoverboard = board
	
	cas:BindAction("LeftHoverboard", rotate, false, "a")
	cas:BindAction("RightHoverboard", rotate, false, "d")
	cas:BindAction("ForwardHoverboard", move, false, "w")
	cas:BindAction("BackwardHoverboard", move, false, "s")
end)


function rotate(actionName, actionState)
	
	rotation = 
		actionName == "LeftHoverboard" and actionState == Enum.UserInputState.Begin and 20 
		or actionName == "RightHoverboard" and actionState == Enum.UserInputState.Begin and -20
		or 0
end

function move(actionName, actionState)
	
	movement =
		actionName == "ForwardHoverboard" and actionState == Enum.UserInputState.Begin and -8
		or actionName == "BackwardHoverboard" and actionState == Enum.UserInputState.Begin and 8
		or 0
end


game:GetService("RunService").Heartbeat:Connect(function()
	
	if currentHoverboard then
		
		local ray = Ray.new(currentHoverboard.Position, -currentHoverboard.CFrame.UpVector * 1000)
		local part = workspace:FindPartOnRayWithIgnoreList(ray, {currentHoverboard})
		
		local groundY = part.Position.Y + (part.Size.Y / 2)
		
		currentHoverboard.BodyPosition.Position = Vector3.new(currentHoverboard.Position.X, groundY + 1.5, currentHoverboard.Position.Z) + (currentHoverboard.CFrame.RightVector * movement)-- + Vector3.new(0, groundY + 2, 0)
		currentHoverboard.BodyGyro.CFrame = currentHoverboard.CFrame * CFrame.Angles(0, rotation, 0)
		
		script.Parent.HumanoidRootPart.Velocity = Vector3.new()
	end
end)