local tweenService = game:GetService("TweenService")

local speed = 3
local openDoorTime = 2
local closeDoorTime = 2

local elevator = script.Parent

local floors = elevator:WaitForChild("FloorPositions")
local floorButtons = elevator:WaitForChild("FloorButtons")
local floorDoors = elevator:WaitForChild("FloorDoors")

local carriage = elevator:WaitForChild("Carriage")
local carriageDoors = carriage:WaitForChild("Door")
local carriageButtons = carriage:WaitForChild("Buttons")
local carriageDoorButtons = carriageButtons:WaitForChild("DoorButtons")
local carriageFloorButtons = carriageButtons:WaitForChild("FloorButtons")
local carriageCurrentFloor = carriageButtons:WaitForChild("CurrentFloor")

local soundContainer = carriage.SoundContainer
local dingSound = soundContainer:FindFirstChild("Ding")
local doorOpenSound = soundContainer:FindFirstChild("DoorOpen")
local doorCloseSound = soundContainer:FindFirstChild("DoorClose")
local goingDownSound = soundContainer:FindFirstChild("GoingDown")
local goingUpSound = soundContainer:FindFirstChild("GoingUp")
local movingSound = soundContainer:FindFirstChild("Moving")
local musicSound = soundContainer:FindFirstChild("Music")


local floorQueue = {}

local currentFloor = 1
local goalFloor = 1

local carriageDoorDebounce = false


function tween(cframeValue, goalCFrame, duration)
	
	if cframeValue and goalCFrame and not cframeValue:FindFirstChild("CURRENTLY TWEENING") then
		
		local tweeningValue = Instance.new("StringValue")
		tweeningValue.Name = "CURRENTLY TWEENING"
		tweeningValue.Parent = cframeValue
		
		local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local newTween = tweenService:Create(cframeValue, tweenInfo, {Value = goalCFrame})
		
		newTween:Play()
		newTween.Completed:Wait()
		
		tweeningValue:Destroy()
	end
end


local floorPositions = {}

for i = 1, #floors:GetChildren() do
	table.insert(floorPositions, floors[i].CFrame)
end

carriage:SetPrimaryPartCFrame(floorPositions[currentFloor])


--BUTTONS FOR CALLING ELEVATOR TO A FLOOR
for i, floorButton in pairs(floorButtons:GetChildren()) do
	
	local floorNumber = tonumber(floorButton.Name)
	
	local callButton = floorButton.CallButton
	callButton.Light.Material = Enum.Material.Metal
	
	local clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 10
	clickDetector.Parent = callButton
	
	clickDetector.MouseClick:Connect(function(plr)
		
		if not table.find(floorQueue, floorNumber) then
			table.insert(floorQueue, floorNumber)
			
			callButton.Light.Material = Enum.Material.Neon
			
			while table.find(floorQueue, floorNumber) do
				task.wait(0.5)
			end
			callButton.Light.Material = Enum.Material.Metal
		end
	end)
	
	local currentFloorUI = floorButton.CurrentFloor.CurrentFloorGui.CurrentFloorFrame
	
	task.spawn(function()
		while true do
			task.wait(0.3)
			
			currentFloorUI.CurrentFloorText.Text = currentFloor
			
			if goalFloor > currentFloor then
				currentFloorUI.GoingDown.Visible = false
				currentFloorUI.GoingUp.Visible = true
				
			elseif goalFloor < currentFloor then
				currentFloorUI.GoingUp.Visible = false
				currentFloorUI.GoingDown.Visible = true
				
			else
				currentFloorUI.GoingDown.Visible = false
				currentFloorUI.GoingUp.Visible = false
			end
		end
	end)
end


--SET UP FLOOR DOORS
for i, floorDoor in pairs(floorDoors:GetChildren()) do
	
	local floorNumber = tonumber(floorDoor.Name)
	
	local leftDoor = floorDoor.LeftDoor
	local leftDoorCFrame = leftDoor.PrimaryPart.CFrame
	
	local cframeValueLeft = Instance.new("CFrameValue")
	cframeValueLeft.Name = "CFrameValue"
	cframeValueLeft.Value = CFrame.new()
	cframeValueLeft.Parent = leftDoor
	
	if floorNumber == currentFloor then
		cframeValueLeft.Value = CFrame.new(leftDoor.PrimaryPart.Size.X * leftDoor.PrimaryPart.CFrame.RightVector)
	end
	leftDoor:SetPrimaryPartCFrame(leftDoorCFrame * cframeValueLeft.Value)
	
	cframeValueLeft:GetPropertyChangedSignal("Value"):Connect(function()
		leftDoor:SetPrimaryPartCFrame(leftDoorCFrame * cframeValueLeft.Value)
	end)
	
	local rightDoor = floorDoor.RightDoor
	local rightDoorCFrame = rightDoor.PrimaryPart.CFrame

	local cframeValueRight = Instance.new("CFrameValue")
	cframeValueRight.Name = "CFrameValue"
	cframeValueRight.Value = CFrame.new()
	cframeValueRight.Parent = rightDoor
	
	if floorNumber == currentFloor then
		cframeValueRight.Value = CFrame.new(rightDoor.PrimaryPart.Size.X * -rightDoor.PrimaryPart.CFrame.RightVector)
	end
	rightDoor:SetPrimaryPartCFrame(rightDoorCFrame * cframeValueRight.Value)

	cframeValueRight:GetPropertyChangedSignal("Value"):Connect(function()
		rightDoor:SetPrimaryPartCFrame(rightDoorCFrame * cframeValueRight.Value)
	end)
end


--SET UP ELEVATOR BUTTONS
for i, floorButton in pairs(carriageFloorButtons:GetChildren()) do
	
	local floorNumber = tonumber(floorButton.Name)
	
	floorButton.Light.Material = Enum.Material.Metal
	
	local clickDetector = Instance.new("ClickDetector")
	clickDetector.MaxActivationDistance = 10
	clickDetector.Parent = floorButton
	
	clickDetector.MouseClick:Connect(function(plr)
		
		if not table.find(floorQueue, floorNumber) and currentFloor ~= floorNumber then
			table.insert(floorQueue, floorNumber)

			floorButton.Light.Material = Enum.Material.Neon

			while table.find(floorQueue, floorNumber) do
				task.wait(0.5)
			end
			floorButton.Light.Material = Enum.Material.Metal
		end
	end)
	
	local buttonGui = Instance.new("SurfaceGui")
	buttonGui.Face = Enum.NormalId.Right
	buttonGui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
	buttonGui.PixelsPerStud = 300
	local buttonText = Instance.new("TextLabel")
	buttonText.BackgroundTransparency = 1
	buttonText.Font = Enum.Font.RobotoCondensed
	buttonText.FontFace.Weight = Enum.FontWeight.Bold
	buttonText.TextScaled = true
	buttonText.TextColor3 = Color3.fromRGB(163, 168, 185)
	buttonText.AnchorPoint = Vector2.new(0.5, 0.5)
	buttonText.Position = UDim2.new(0.5, 0, 0.5, 0)
	buttonText.Size = UDim2.new(0.7, 0, 0.7, 0)
	buttonText.Text = floorNumber
	buttonText.Parent = buttonGui
	buttonGui.Parent = floorButton
end


--SET UP ELEVATOR DOORS
local carriageLeftDoor = carriageDoors.LeftDoor

local carriageLeftDoorCFrame = carriageLeftDoor.PrimaryPart.CFrame

local cframeValueLeft = Instance.new("CFrameValue")
cframeValueLeft.Name = "CFrameValue"
cframeValueLeft.Value = CFrame.new(carriageLeftDoor.PrimaryPart.Size.X * carriageLeftDoor.PrimaryPart.CFrame.RightVector)
cframeValueLeft.Parent = carriageLeftDoor

local leftDoorOffset = carriageLeftDoor.PrimaryPart.Position - carriage.PrimaryPart.Position

carriageLeftDoor:SetPrimaryPartCFrame(carriageLeftDoorCFrame * cframeValueLeft.Value)
cframeValueLeft:GetPropertyChangedSignal("Value"):Connect(function()
	carriageLeftDoor:SetPrimaryPartCFrame((carriage.PrimaryPart.CFrame + leftDoorOffset) * cframeValueLeft.Value)
end)


local carriageRightDoor = carriageDoors.RightDoor

local carriageRightDoorCFrame = carriageRightDoor.PrimaryPart.CFrame

local cframeValueRight = Instance.new("CFrameValue")
cframeValueRight.Name = "CFrameValue"
cframeValueRight.Value = CFrame.new(carriageRightDoor.PrimaryPart.Size.X * -carriageRightDoor.PrimaryPart.CFrame.RightVector)
cframeValueRight.Parent = carriageRightDoor

local rightDoorOffset = carriageRightDoor.PrimaryPart.Position - carriage.PrimaryPart.Position

carriageRightDoor:SetPrimaryPartCFrame(carriageRightDoorCFrame * cframeValueRight.Value)
cframeValueRight:GetPropertyChangedSignal("Value"):Connect(function()
	carriageRightDoor:SetPrimaryPartCFrame((carriage.PrimaryPart.CFrame + rightDoorOffset) * cframeValueRight.Value)
end)


--SET UP ELEVATOR OPEN DOOR BUTTON
local carriageOpenDoorButton = carriageDoorButtons.OpenDoor
carriageOpenDoorButton.Light.Material = Enum.Material.Metal

local openClickDetector = Instance.new("ClickDetector")
openClickDetector.MaxActivationDistance = 10
openClickDetector.Parent = carriageOpenDoorButton


openClickDetector.MouseClick:Connect(function(plr)
	
	local currentFloorDoors = floorDoors[currentFloor]
	local currentLeftDoor = currentFloorDoors.LeftDoor
	local currentRightDoor = currentFloorDoors.RightDoor
	
	local isOpen = currentLeftDoor.CFrameValue.Value.Position.Magnitude > 0 or currentRightDoor.CFrameValue.Value.Position.Magnitude > 0

	if currentFloor == goalFloor and not carriageDoorDebounce and not isOpen then
		carriageDoorDebounce = true
		
		carriageOpenDoorButton.Light.Material = Enum.Material.Neon
		
		local leftGoalCF = CFrame.new(currentLeftDoor.PrimaryPart.Size.X * currentLeftDoor.PrimaryPart.CFrame.RightVector)
		local rightGoalCF = CFrame.new(currentRightDoor.PrimaryPart.Size.X * -currentRightDoor.PrimaryPart.CFrame.RightVector)
		
		task.spawn(tween, currentLeftDoor.CFrameValue, leftGoalCF, openDoorTime)
		task.spawn(tween, currentRightDoor.CFrameValue, rightGoalCF, openDoorTime)
		
		if doorOpenSound then
			doorOpenSound:Play()
		end
		
		task.wait(0.2)
		
		local leftCarriageDoorGoalCF = CFrame.new(carriageLeftDoor.PrimaryPart.Size.X * carriageLeftDoor.PrimaryPart.CFrame.RightVector)
		local rightCarriageDoorGoalCF = CFrame.new(carriageRightDoor.PrimaryPart.Size.X * -carriageRightDoor.PrimaryPart.CFrame.RightVector)
		
		task.spawn(tween, cframeValueLeft, leftCarriageDoorGoalCF, openDoorTime)
		task.spawn(tween, cframeValueRight, rightCarriageDoorGoalCF, openDoorTime)

		task.wait(openDoorTime)
		carriageOpenDoorButton.Light.Material = Enum.Material.Metal
		carriageDoorDebounce = false
	end
end)


--SET UP ELEVATOR CLOSE DOOR BUTTON
local carriageCloseDoorButton = carriageDoorButtons.CloseDoor
carriageCloseDoorButton.Light.Material = Enum.Material.Metal

local closeClickDetector = Instance.new("ClickDetector")
closeClickDetector.MaxActivationDistance = 10
closeClickDetector.Parent = carriageCloseDoorButton


closeClickDetector.MouseClick:Connect(function(plr)

	local currentFloorDoors = floorDoors[currentFloor]
	local currentLeftDoor = currentFloorDoors.LeftDoor
	local currentRightDoor = currentFloorDoors.RightDoor

	local isOpen = cframeValueLeft.Value.Position.Magnitude > 0 or cframeValueRight.Value.Position.Magnitude > 0

	if currentFloor == goalFloor and not carriageDoorDebounce and isOpen then
		carriageDoorDebounce = true

		carriageCloseDoorButton.Light.Material = Enum.Material.Neon

		local emptyCFrame = CFrame.new()

		task.spawn(tween, cframeValueLeft, emptyCFrame, closeDoorTime)
		task.spawn(tween, cframeValueRight, emptyCFrame, closeDoorTime)

		if doorCloseSound then
			doorCloseSound:Play()
		end
		
		task.wait(0.2)
		
		task.spawn(tween, currentLeftDoor.CFrameValue, emptyCFrame, closeDoorTime)
		task.spawn(tween, currentRightDoor.CFrameValue, emptyCFrame, closeDoorTime)

		task.wait(closeDoorTime)
		carriageCloseDoorButton.Light.Material = Enum.Material.Metal
		carriageDoorDebounce = false
	end
end)


--SET UP ELEVATOR MOVEMENT
local carriageCFV = Instance.new("CFrameValue")
carriageCFV.Name = "CFrameValue"
carriageCFV.Value = carriage.PrimaryPart.CFrame
carriageCFV.Parent = carriage

carriageCFV:GetPropertyChangedSignal("Value"):Connect(function()
	carriage:SetPrimaryPartCFrame(carriageCFV.Value)
end)


--ELEVATOR LOOP
local currentFloorUI = carriageCurrentFloor.CurrentFloorGui.CurrentFloorFrame

while true do
	task.wait(0.1)
	
	currentFloorUI.CurrentFloorText.Text = currentFloor
	if goalFloor > currentFloor then
		currentFloorUI.GoingDown.Visible = false
		currentFloorUI.GoingUp.Visible = true

	elseif goalFloor < currentFloor then
		currentFloorUI.GoingUp.Visible = false
		currentFloorUI.GoingDown.Visible = true

	else
		currentFloorUI.GoingDown.Visible = false
		currentFloorUI.GoingUp.Visible = false
	end
	
	if #floorQueue > 0 then
		goalFloor = floorQueue[1]
		
		if goalFloor ~= currentFloor then	
			
			goalFloor = floorQueue[1]
			
			local goingUp = goalFloor > currentFloor
			
			if goingUp then
				currentFloorUI.GoingDown.Visible = false
				currentFloorUI.GoingUp.Visible = true
			else
				currentFloorUI.GoingUp.Visible = false
				currentFloorUI.GoingDown.Visible = true
			end
			
			
			local currentFloorDoors = floorDoors[currentFloor]
			local currentLeftDoor = currentFloorDoors.LeftDoor
			local currentRightDoor = currentFloorDoors.RightDoor

			local isOpen = cframeValueLeft.Value.Position.Magnitude > 0 or cframeValueRight.Value.Position.Magnitude > 0

			if isOpen then
				while carriageDoorDebounce do
					task.wait(1)
				end
				
				carriageDoorDebounce = true
				
				carriageCloseDoorButton.Light.Material = Enum.Material.Neon
				
				local emptyCFrame = CFrame.new()

				task.spawn(tween, cframeValueLeft, emptyCFrame, closeDoorTime)
				task.spawn(tween, cframeValueRight, emptyCFrame, closeDoorTime)

				if doorCloseSound then
					doorCloseSound:Play()
				end

				task.wait(0.2)

				task.spawn(tween, currentLeftDoor.CFrameValue, emptyCFrame, closeDoorTime)
				task.spawn(tween, currentRightDoor.CFrameValue, emptyCFrame, closeDoorTime)

				task.wait(closeDoorTime)
				carriageCloseDoorButton.Light.Material = Enum.Material.Metal
				carriageDoorDebounce = false
			end
			cframeValueLeft.Value = CFrame.new()
			cframeValueRight.Value = CFrame.new()
			currentLeftDoor.CFrameValue.Value = CFrame.new()
			currentRightDoor.CFrameValue.Value = CFrame.new()
			
			task.wait(1)
			if goingUp and goingUpSound then
				goingUpSound:Play()
			elseif not goingUp and goingDownSound then
				goingDownSound:Play()
			end
			
			task.wait(goingUpSound.TimeLength)
			
			if movingSound then
				movingSound:Play()
			end
			if musicSound then
				musicSound:Play()
			end
			
			local startFloor = goingUp and currentFloor + 1 or currentFloor - 1
			local step =  goingUp and 1 or -1
			
			for i = startFloor, goalFloor, step do
				
				if movingSound and not movingSound.IsPlaying then
					movingSound:Play()
				end
				if musicSound and not musicSound.IsPlaying then
					musicSound:Play()
				end
				
				local floorCFrame = floorPositions[i]
				
				local distance = (carriage.PrimaryPart.Position - floorCFrame.Position).Magnitude
				local duration = distance / speed
				
				tween(carriageCFV, floorCFrame, duration)
				
				if table.find(floorQueue, i) and i ~= goalFloor then
					if dingSound then
						dingSound:Play()
					end
					
					currentFloor = i
					currentFloorUI.CurrentFloorText.Text = currentFloor
						
					task.wait(1)
						
					carriageDoorDebounce = true
					
					currentFloorDoors = floorDoors[currentFloor]
					currentLeftDoor = currentFloorDoors.LeftDoor
					currentRightDoor = currentFloorDoors.RightDoor
						
					local leftGoalCF = CFrame.new(currentLeftDoor.PrimaryPart.Size.X * currentLeftDoor.PrimaryPart.CFrame.RightVector)
					local rightGoalCF = CFrame.new(currentRightDoor.PrimaryPart.Size.X * -currentRightDoor.PrimaryPart.CFrame.RightVector)

					task.spawn(tween, currentLeftDoor.CFrameValue, leftGoalCF, openDoorTime)
					task.spawn(tween, currentRightDoor.CFrameValue, rightGoalCF, openDoorTime)

					if doorOpenSound then
						doorOpenSound:Play()
					end
					
					carriageOpenDoorButton.Light.Material = Enum.Material.Neon

					task.wait(0.2)

					local leftCarriageDoorGoalCF = CFrame.new(carriageLeftDoor.PrimaryPart.Size.X * carriageLeftDoor.PrimaryPart.CFrame.RightVector)
					local rightCarriageDoorGoalCF = CFrame.new(carriageRightDoor.PrimaryPart.Size.X * -carriageRightDoor.PrimaryPart.CFrame.RightVector)

					task.spawn(tween, cframeValueLeft, leftCarriageDoorGoalCF, openDoorTime)
					task.spawn(tween, cframeValueRight, rightCarriageDoorGoalCF, openDoorTime)
						
					task.wait(openDoorTime)
					carriageDoorDebounce = false
					carriageOpenDoorButton.Light.Material = Enum.Material.Metal
					
					
					if movingSound then
						movingSound:Stop()
					end
					if musicSound then
						musicSound:Stop()
					end
					
					table.remove(floorQueue, table.find(floorQueue, i))
					
					task.wait(7)
					while carriageDoorDebounce do
						task.wait(1)
					end
						
					carriageDoorDebounce = true
						
					local emptyCFrame = CFrame.new()

					task.spawn(tween, cframeValueLeft, emptyCFrame, closeDoorTime)
					task.spawn(tween, cframeValueRight, emptyCFrame, closeDoorTime)

					if doorCloseSound then
						doorCloseSound:Play()
					end

					task.wait(0.2)

					task.spawn(tween, currentLeftDoor.CFrameValue, emptyCFrame, closeDoorTime)
					task.spawn(tween, currentRightDoor.CFrameValue, emptyCFrame, closeDoorTime)

					task.wait(closeDoorTime + 1)
					carriageDoorDebounce = false
	
					if goingUp and goingUpSound then
						goingUpSound:Play()
					elseif not goingUp and goingDownSound then
						goingDownSound:Play()
					end
					
					task.wait(goingUpSound.TimeLength)
				end
				
				
				currentFloor = i
				currentFloorUI.CurrentFloorText.Text = currentFloor
			end
			
			if movingSound then
				movingSound:Stop()
			end
			if musicSound then
				musicSound:Stop()
			end
		
		
			if dingSound then
				dingSound:Play()
			end
			
			
			task.wait(1)

			carriageDoorDebounce = true
			
			carriageOpenDoorButton.Light.Material = Enum.Material.Neon
			
			local currentFloorDoors = floorDoors[currentFloor]
			local currentLeftDoor = currentFloorDoors.LeftDoor
			local currentRightDoor = currentFloorDoors.RightDoor

			local leftGoalCF = CFrame.new(currentLeftDoor.PrimaryPart.Size.X * currentLeftDoor.PrimaryPart.CFrame.RightVector)
			local rightGoalCF = CFrame.new(currentRightDoor.PrimaryPart.Size.X * -currentRightDoor.PrimaryPart.CFrame.RightVector)

			task.spawn(tween, currentLeftDoor.CFrameValue, leftGoalCF, openDoorTime)
			task.spawn(tween, currentRightDoor.CFrameValue, rightGoalCF, openDoorTime)

			if doorOpenSound then
				doorOpenSound:Play()
			end

			task.wait(0.2)

			local leftCarriageDoorGoalCF = CFrame.new(carriageLeftDoor.PrimaryPart.Size.X * carriageLeftDoor.PrimaryPart.CFrame.RightVector)
			local rightCarriageDoorGoalCF = CFrame.new(carriageRightDoor.PrimaryPart.Size.X * -carriageRightDoor.PrimaryPart.CFrame.RightVector)

			task.spawn(tween, cframeValueLeft, leftCarriageDoorGoalCF, openDoorTime)
			task.spawn(tween, cframeValueRight, rightCarriageDoorGoalCF, openDoorTime)

			task.wait(openDoorTime)
			carriageDoorDebounce = false
			carriageOpenDoorButton.Light.Material = Enum.Material.Metal
		
			table.remove(floorQueue, 1)
		else
			local currentFloorDoors = floorDoors[currentFloor]
			local currentLeftDoor = currentFloorDoors.LeftDoor
			local currentRightDoor = currentFloorDoors.RightDoor
			
			local isOpen = cframeValueLeft.Value.Position.Magnitude > 0 or cframeValueRight.Value.Position.Magnitude > 0
			
			if not isOpen then
				
				carriageDoorDebounce = true

				carriageOpenDoorButton.Light.Material = Enum.Material.Neon

				local leftGoalCF = CFrame.new(currentLeftDoor.PrimaryPart.Size.X * currentLeftDoor.PrimaryPart.CFrame.RightVector)
				local rightGoalCF = CFrame.new(currentRightDoor.PrimaryPart.Size.X * -currentRightDoor.PrimaryPart.CFrame.RightVector)

				task.spawn(tween, currentLeftDoor.CFrameValue, leftGoalCF, openDoorTime)
				task.spawn(tween, currentRightDoor.CFrameValue, rightGoalCF, openDoorTime)

				if doorOpenSound then
					doorOpenSound:Play()
				end

				task.wait(0.2)

				local leftCarriageDoorGoalCF = CFrame.new(carriageLeftDoor.PrimaryPart.Size.X * carriageLeftDoor.PrimaryPart.CFrame.RightVector)
				local rightCarriageDoorGoalCF = CFrame.new(carriageRightDoor.PrimaryPart.Size.X * -carriageRightDoor.PrimaryPart.CFrame.RightVector)

				task.spawn(tween, cframeValueLeft, leftCarriageDoorGoalCF, openDoorTime)
				task.spawn(tween, cframeValueRight, rightCarriageDoorGoalCF, openDoorTime)

				task.wait(openDoorTime)
				carriageOpenDoorButton.Light.Material = Enum.Material.Metal
				carriageDoorDebounce = false
			end
			
			table.remove(floorQueue, 1)
		end
		
		task.wait(4)
	end
end