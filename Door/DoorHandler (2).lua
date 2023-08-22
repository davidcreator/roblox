local door = script.Parent:WaitForChild("Door")
if not door.PrimaryPart then
	door.PrimaryPart = door:WaitForChild("HINGE")
end


--CONFIGURATION--
local keycardName = "KEYCARD"

local timeOpen = 8

local goalRot = 105

local openLength = 2
local closeLength = 1.2
-----------------

local pos = door:GetPivot().Position
local initialRot = door.PrimaryPart.Orientation.Y

local opened = false
local animationHappening = false

local prompt = Instance.new("ProximityPrompt")
prompt.ObjectText = "Keycard Door"
prompt.ActionText = "Open door"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.HoldDuration = 0
prompt.RequiresLineOfSight = false
prompt.MaxActivationDistance = 8
prompt.Parent = door

local cfv = Instance.new("CFrameValue")
cfv.Value = door:GetPivot()
cfv.Parent = door

cfv:GetPropertyChangedSignal("Value"):Connect(function()
	door:PivotTo(cfv.Value)
end)


function ease(x)
	local n1 = 7.5625
	local d1 = 2.75

	if (x < 1 / d1) then
		return n1 * x * x
	elseif (x < 2 / d1) then
		x -= 1.5/d1
		return n1 * (x) * x + 0.75
	elseif (x < 2.5 / d1) then
		x -= 2.25/d1
		return n1 * (x) * x + 0.9375
	else
		x -= 2.625/d1
		return n1 * (x) * x + 0.984375
	end
end


function closeDoor()

	if opened and not animationHappening then
		opened = false
		animationHappening = true

		local currentRot = door.PrimaryPart.Orientation.Y

		local closeStarted = tick()
		while true do
			local x = (tick() - closeStarted) / closeLength
			local rotOffset = ease(x) * -goalRot

			cfv.Value = CFrame.new(pos) * CFrame.Angles(0, math.rad((initialRot + goalRot) + rotOffset), 0)

			if x >= 1 then
				break
			end

			game:GetService("RunService").Heartbeat:Wait()
		end
		
		animationHappening = false
		prompt.Enabled = true
	end
end

function openDoor()
	
	if not opened and not animationHappening then
		opened = true
		animationHappening = true
		
		prompt.Enabled = false

		local openStarted = tick()
		
		while true do
			local x = (tick() - openStarted) / openLength
			local rotOffset = ease(x) * goalRot

			cfv.Value = CFrame.new(pos) * CFrame.Angles(0, math.rad(initialRot + rotOffset), 0)
			
			if x >= 1 then
				break
			end
			
			game:GetService("RunService").Heartbeat:Wait()
		end
		
		animationHappening = false
	end
end



prompt.Triggered:Connect(function(plr)
	
	local char = plr.Character
	if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
		
		if char:FindFirstChild(keycardName) and char[keycardName]:IsA("Tool") then
		
			task.spawn(openDoor)
			task.wait(timeOpen)
			task.spawn(closeDoor)
		end
	end
end)