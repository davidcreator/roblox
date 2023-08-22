local collectionService = game:GetService("CollectionService")

local uis = game:GetService("UserInputService")


local eButtonGui = game.ReplicatedStorage:WaitForChild("PressEGui")

local char = script.Parent
local humanoid = char.Humanoid
local hrp = char.HumanoidRootPart


local currentSeat
local nearestSeat

local distance = 10


local function getVehicleSeats()
	
	for i, descendantOfWorkspace in pairs(workspace:GetDescendants()) do
			
		if descendantOfWorkspace:IsA("VehicleSeat") then
			
			collectionService:AddTag(descendantOfWorkspace, "VehicleSeats")
			
			local guiClone = eButtonGui:Clone()
			guiClone.Enabled = false
			guiClone.Parent = descendantOfWorkspace
			
			descendantOfWorkspace.Disabled = true
		end
	end
	
	return collectionService:GetTagged("VehicleSeats")
end

local vehicleSeats = getVehicleSeats()


uis.InputBegan:Connect(function(key)
	
	if key.KeyCode == Enum.KeyCode.E and nearestSeat then
		
		nearestSeat:Sit(humanoid)
	end
end)


humanoid.Seated:Connect(function(isSeated, seatPart)
	
	if isSeated and seatPart:IsA("VehicleSeat") then
		
		seatPart.Disabled = false
		currentSeat = seatPart
		
	elseif currentSeat then
		
		currentSeat.Disabled = true
	end
end)


game:GetService("RunService").RenderStepped:Connect(function()
	
	local closestSeat	
	for i, vehicleSeat in pairs(vehicleSeats) do
			
		local distanceFromSeat = (hrp.Position - vehicleSeat.Position).Magnitude
		if distanceFromSeat <= distance then
			
			if not closestSeat then closestSeat = vehicleSeat end
			
			local distanceFromClosestSeat = (hrp.Position - closestSeat.Position).Magnitude
			
			
			if distanceFromSeat < distanceFromClosestSeat then
				
				closestSeat = vehicleSeat
			end
		end	
	end
	
	for i, vehicleSeat in pairs(vehicleSeats) do
		vehicleSeat.PressEGui.Enabled = false
	end
	
	
	if humanoid.Sit and humanoid.SeatPart:IsA("VehicleSeat") or closestSeat.Occupant then return end
	
	nearestSeat = closestSeat
	
	if nearestSeat then nearestSeat.PressEGui.Enabled = true end
end)