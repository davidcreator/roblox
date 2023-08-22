local elevator = script.Parent

local cabin = elevator:WaitForChild("Cabin"):WaitForChild("Cabin")
local cabinBtns = cabin.Parent:WaitForChild("Buttons")

local callBtns = elevator:WaitForChild("CallButtons")

local doors = elevator:WaitForChild("Doors")


local elevatorQueue = {}
local currentFloor = 1


local elevatorSpeed = 3
local doorSpeed = 0.5

local tweenService = game:GetService("TweenService")
local doorTI = TweenInfo.new(doorSpeed, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)


local elevatorMoving = false


for i, cabinPart in pairs(cabin.Parent:GetDescendants()) do
	
	if cabinPart:IsA("BasePart") and cabinPart ~= cabin then
		
		local weldConstraint = Instance.new("WeldConstraint")
		weldConstraint.Part0 = cabinPart
		weldConstraint.Part1 = cabin
		weldConstraint.Parent = cabinPart
		
		cabinPart.Anchored = false
	end
end


for i, btn in pairs(cabinBtns:GetChildren()) do
	Instance.new("ClickDetector", btn)
end
for i, btn in pairs(callBtns:GetChildren()) do
	Instance.new("ClickDetector", btn)
end


for i, btn in pairs(cabinBtns:GetChildren()) do
	
	btn.ClickDetector.MouseClick:Connect(function()
		table.insert(elevatorQueue, btn.Name)
	end)
end
for i, btn in pairs(callBtns:GetChildren()) do

	btn.ClickDetector.MouseClick:Connect(function()
		table.insert(elevatorQueue, btn.Name)
	end)
end


while true do
	
	local instruction
	
	repeat 
		wait()
		instruction = elevatorQueue[1]
	until instruction

	
	if instruction == "OpenDoorsButton" and not elevatorMoving then
		
		local lDoor = doors["Floor" .. currentFloor].LeftDoor
		tweenService:Create(lDoor.LeftDoor, doorTI, {Size = lDoor.LeftDoorOpened.Size, CFrame = lDoor.LeftDoorOpened.CFrame}):Play()
		local rDoor = doors["Floor" .. currentFloor].RightDoor
		tweenService:Create(rDoor.RightDoor, doorTI, {Size = rDoor.RightDoorOpened.Size, CFrame = rDoor.RightDoorOpened.CFrame}):Play()
		
		wait(doorSpeed)
		table.remove(elevatorQueue, 1)
		
		
	elseif instruction == "CloseDoorsButton" and not elevatorMoving then
		
		local lDoor = doors["Floor" .. currentFloor].LeftDoor
		tweenService:Create(lDoor.LeftDoor, doorTI, {Size = lDoor.LeftDoorClosed.Size, CFrame = lDoor.LeftDoorClosed.CFrame}):Play()
		local rDoor = doors["Floor" .. currentFloor].RightDoor
		tweenService:Create(rDoor.RightDoor, doorTI, {Size = rDoor.RightDoorClosed.Size, CFrame = rDoor.RightDoorClosed.CFrame}):Play()
		
		wait(doorSpeed)
		
		table.remove(elevatorQueue, 1)
		
		
		
	elseif instruction == "CallButton1" or instruction == "Floor1Button" then
		
		elevatorMoving = true
		
		
		if currentFloor ~= 1 then
			
			
			local lDoor = doors["Floor" .. currentFloor].LeftDoor
			tweenService:Create(lDoor.LeftDoor, doorTI, {Size = lDoor.LeftDoorClosed.Size, CFrame = lDoor.LeftDoorClosed.CFrame}):Play()
			local rDoor = doors["Floor" .. currentFloor].RightDoor
			tweenService:Create(rDoor.RightDoor, doorTI, {Size = rDoor.RightDoorClosed.Size, CFrame = rDoor.RightDoorClosed.CFrame}):Play()

			wait(doorSpeed)

			
			cabin.ElevatorSound:Play()
			
			local elevatorTI = TweenInfo.new(elevatorSpeed * math.abs(currentFloor - 1), Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
			tweenService:Create(cabin, elevatorTI, {CFrame = cabin.CFrame + Vector3.new(0, (doors["Floor1"].RightDoor.RightDoor.Position.Y - cabin.Position.Y), 0)}):Play()
			
			
			wait(elevatorSpeed * math.abs(currentFloor - 1))
			
			cabin.ElevatorSound:Stop()
			cabin.ElevatorPing:Play()
		end
		
		
		local lDoor = doors["Floor1"].LeftDoor
		tweenService:Create(lDoor.LeftDoor, doorTI, {Size = lDoor.LeftDoorOpened.Size, CFrame = lDoor.LeftDoorOpened.CFrame}):Play()
		local rDoor = doors["Floor1"].RightDoor
		tweenService:Create(rDoor.RightDoor, doorTI, {Size = rDoor.RightDoorOpened.Size, CFrame = rDoor.RightDoorOpened.CFrame}):Play()

		wait(doorSpeed)
		
		
		currentFloor = 1
		elevatorMoving = false
		table.remove(elevatorQueue, 1)
		
		
	elseif instruction == "CallButton2" or instruction == "Floor2Button" then

		elevatorMoving = true


		if currentFloor ~= 2 then


			local lDoor = doors["Floor" .. currentFloor].LeftDoor
			tweenService:Create(lDoor.LeftDoor, doorTI, {Size = lDoor.LeftDoorClosed.Size, CFrame = lDoor.LeftDoorClosed.CFrame}):Play()
			local rDoor = doors["Floor" .. currentFloor].RightDoor
			tweenService:Create(rDoor.RightDoor, doorTI, {Size = rDoor.RightDoorClosed.Size, CFrame = rDoor.RightDoorClosed.CFrame}):Play()

			wait(doorSpeed)
			
			
			cabin.ElevatorSound:Play()
			
			local elevatorTI = TweenInfo.new(elevatorSpeed * math.abs(currentFloor - 2), Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
			tweenService:Create(cabin, elevatorTI, {CFrame = cabin.CFrame + Vector3.new(0, (doors["Floor2"].RightDoor.RightDoor.Position.Y - cabin.Position.Y), 0)}):Play()

			
			wait(elevatorSpeed * math.abs(currentFloor - 2))
			
			cabin.ElevatorSound:Stop()
			cabin.ElevatorPing:Play()			
		end


		local lDoor = doors["Floor2"].LeftDoor
		tweenService:Create(lDoor.LeftDoor, doorTI, {Size = lDoor.LeftDoorOpened.Size, CFrame = lDoor.LeftDoorOpened.CFrame}):Play()
		local rDoor = doors["Floor2"].RightDoor
		tweenService:Create(rDoor.RightDoor, doorTI, {Size = rDoor.RightDoorOpened.Size, CFrame = rDoor.RightDoorOpened.CFrame}):Play()

		wait(doorSpeed)


		currentFloor = 2
		elevatorMoving = false
		table.remove(elevatorQueue, 1)
		
		
	elseif instruction == "CallButton3" or instruction == "Floor3Button" then

		elevatorMoving = true


		if currentFloor ~= 3 then
			

			local lDoor = doors["Floor" .. currentFloor].LeftDoor
			tweenService:Create(lDoor.LeftDoor, doorTI, {Size = lDoor.LeftDoorClosed.Size, CFrame = lDoor.LeftDoorClosed.CFrame}):Play()
			local rDoor = doors["Floor" .. currentFloor].RightDoor
			tweenService:Create(rDoor.RightDoor, doorTI, {Size = rDoor.RightDoorClosed.Size, CFrame = rDoor.RightDoorClosed.CFrame}):Play()

			wait(doorSpeed)
			
			
			cabin.ElevatorSound:Play()

			local elevatorTI = TweenInfo.new(elevatorSpeed * math.abs(currentFloor - 3), Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
			tweenService:Create(cabin, elevatorTI, {CFrame = cabin.CFrame + Vector3.new(0, (doors["Floor3"].RightDoor.RightDoor.Position.Y - cabin.Position.Y), 0)}):Play()


			wait(elevatorSpeed * math.abs(currentFloor - 3))
			
			cabin.ElevatorSound:Stop()
			cabin.ElevatorPing:Play()
		end


		local lDoor = doors["Floor3"].LeftDoor
		tweenService:Create(lDoor.LeftDoor, doorTI, {Size = lDoor.LeftDoorOpened.Size, CFrame = lDoor.LeftDoorOpened.CFrame}):Play()
		local rDoor = doors["Floor3"].RightDoor
		tweenService:Create(rDoor.RightDoor, doorTI, {Size = rDoor.RightDoorOpened.Size, CFrame = rDoor.RightDoorOpened.CFrame}):Play()

		wait(doorSpeed)


		currentFloor = 3
		elevatorMoving = false
		table.remove(elevatorQueue, 1)
	end
end