local conveyors = game:GetService("ReplicatedStorage"):WaitForChild("ConveyorSystemReplicatedStorage"):WaitForChild("Conveyors")
local placeRemote = game:GetService("ReplicatedStorage")["ConveyorSystemReplicatedStorage"]:WaitForChild("PlaceConveyorEvent")
local removeRemote = game:GetService("ReplicatedStorage")["ConveyorSystemReplicatedStorage"]:WaitForChild("RemoveConveyorEvent")

local createdConveyors = Instance.new("Folder")
createdConveyors.Name = "CREATED CONVEYORS"
createdConveyors.Parent = workspace


function hideWall(wall)
	
	wall.Transparency = 1
	wall.CanCollide = false
	
	for _, desc in pairs(wall:GetDescendants()) do
		if desc:IsA("BasePart") then
			desc.Transparency = 1
			desc.CanCollide = false
		end
	end
end

function showWall(wall)
	print(wall)
	wall.Transparency = 0
	wall.CanCollide = true

	for _, desc in pairs(wall:GetDescendants()) do
		if desc:IsA("BasePart") then
			desc.Transparency = 0
			desc.CanCollide = true
		end
	end
end


placeRemote.OnServerEvent:Connect(function(plr, conveyor, pos, rot)
	
	if plr.Character and plr.Character.Humanoid.Health > 0 and conveyor and conveyor.Parent == conveyors then
		
		local dist = (plr.Character.HumanoidRootPart.Position - pos).Magnitude
		
		if dist <= 30 then
			pos = Vector3.new(math.round(pos.X * 2)/2, math.round(pos.Y * 2)/2, math.round(pos.Z * 2)/2)
			rot = math.round(rot / 90) * 90
			
			local raycastparams = RaycastParams.new()
			raycastparams.FilterDescendantsInstances = {plr.Character}
			local downRay = workspace:Raycast(pos, Vector3.new(0, -100, 0), raycastparams)
			
			if downRay and downRay.Instance:FindFirstAncestorWhichIsA("Folder") ~= createdConveyors then
				pos = Vector3.new(pos.X, downRay.Position.Y + conveyor.Conveyor.Size.Y/2, pos.Z)
			
				local conveyorCF = CFrame.new(pos) * CFrame.Angles(0, math.rad(rot), 0)
				
				local overlapparams = OverlapParams.new()
				overlapparams.FilterType = Enum.RaycastFilterType.Whitelist
				overlapparams.FilterDescendantsInstances = {createdConveyors}
				local partsInConveyor = workspace:GetPartBoundsInBox(conveyorCF, conveyor.Conveyor.Size, overlapparams)
				
				local conveyorBlocked = false

				for _, part in pairs(partsInConveyor) do
					if part.Name == "Conveyor" then
						conveyorBlocked = true
						break
					end
				end
				
				if not conveyorBlocked then
					
					local newConveyor = conveyor:Clone()
					newConveyor:PivotTo(conveyorCF)
					newConveyor.Parent = createdConveyors
					newConveyor.Conveyor.AssemblyLinearVelocity = conveyorCF.LookVector * newConveyor.Configuration.Speed.Value
					
					local creatorValue = Instance.new("IntValue")
					creatorValue.Name = "CREATOR"
					creatorValue.Value = plr.UserId
					creatorValue.Parent = newConveyor
					
					local connectedValue = Instance.new("ObjectValue")
					connectedValue.Name = "CONNECTED TO"
					connectedValue.Parent = newConveyor
					
					hideWall(newConveyor.Walls.FrontWall)
					
					local raycastparams = RaycastParams.new()
					raycastparams.FilterType = Enum.RaycastFilterType.Whitelist
					
					local conveyorWalls = {}
					for _, createdConveyor in pairs(createdConveyors:GetChildren()) do
						if createdConveyor ~= newConveyor then
							table.insert(conveyorWalls, createdConveyor.Walls)
						end
					end
					raycastparams.FilterDescendantsInstances = {conveyorWalls}
					
					local frontPos = newConveyor.Conveyor.Position
					frontPos = frontPos + newConveyor.Conveyor.Size.Z/2 * newConveyor.Conveyor.CFrame.LookVector
					frontPos = frontPos - newConveyor.Conveyor.CFrame.LookVector * 0.1
					local frontRay = workspace:Raycast(frontPos, newConveyor.Conveyor.CFrame.LookVector * 0.5, raycastparams)
					
					local backPos = newConveyor.Conveyor.Position
					backPos = backPos - newConveyor.Conveyor.Size.Z/2 * newConveyor.Conveyor.CFrame.LookVector
					backPos = backPos + newConveyor.Conveyor.CFrame.LookVector * 0.1
					local backRay = workspace:Raycast(backPos, -newConveyor.Conveyor.CFrame.LookVector * 0.5, raycastparams)
					
					local leftPos = newConveyor.Conveyor.Position
					leftPos = leftPos - newConveyor.Conveyor.Size.X/2 * newConveyor.Conveyor.CFrame.RightVector
					leftPos = leftPos + newConveyor.Conveyor.CFrame.RightVector * 0.1
					local leftRay = workspace:Raycast(leftPos, -newConveyor.Conveyor.CFrame.RightVector * 0.5, raycastparams)
					
					local rightPos = newConveyor.Conveyor.Position
					rightPos = rightPos + newConveyor.Conveyor.Size.X/2 * newConveyor.Conveyor.CFrame.RightVector
					rightPos = rightPos - newConveyor.Conveyor.CFrame.RightVector * 0.1
					local rightRay = workspace:Raycast(rightPos, newConveyor.Conveyor.CFrame.RightVector * 0.5, raycastparams)
					
					if frontRay then
						
						local hitWall = frontRay.Instance
						while hitWall.Parent.Name ~= "Walls" do
							hitWall = hitWall.Parent
						end

						hideWall(hitWall)
						hideWall(newConveyor.Walls.FrontWall)
								
						connectedValue.Value = hitWall
						
						if hitWall.Name == "LeftWall" then
							local newVel = hitWall.Parent.Parent.Conveyor.CFrame.LookVector * math.sqrt((hitWall.Parent.Parent.Configuration.Speed.Value^2)/2)
							newVel = newVel + hitWall.Parent.Parent.Conveyor.CFrame.RightVector * math.sqrt((hitWall.Parent.Parent.Configuration.Speed.Value^2)/2)
							hitWall.Parent.Parent.Conveyor.AssemblyLinearVelocity = newVel
						elseif hitWall.Name == "RightWall" then
							local newVel = hitWall.Parent.Parent.Conveyor.CFrame.LookVector * math.sqrt((hitWall.Parent.Parent.Configuration.Speed.Value^2)/2)
							newVel = newVel - hitWall.Parent.Parent.Conveyor.CFrame.RightVector * math.sqrt((hitWall.Parent.Parent.Configuration.Speed.Value^2)/2)
							hitWall.Parent.Parent.Conveyor.AssemblyLinearVelocity = newVel
						end
					end
					
					if backRay then
						
						local hitWall = backRay.Instance
						while hitWall.Parent.Name ~= "Walls" do
							hitWall = hitWall.Parent
						end

						if hitWall.Name == "FrontWall" and (not hitWall.Parent.Parent["CONNECTED TO"].Value or hitWall.Parent.Parent["CONNECTED TO"].Value.Parent == nil) then

							hideWall(hitWall)
							hideWall(newConveyor.Walls.BackWall)

							hitWall.Parent.Parent["CONNECTED TO"].Value = newConveyor.Walls.BackWall
						end
					end
					
					if leftRay then

						local hitWall = leftRay.Instance
						while hitWall.Parent.Name ~= "Walls" do
							hitWall = hitWall.Parent
						end

						if hitWall.Name == "FrontWall" and (not hitWall.Parent.Parent["CONNECTED TO"].Value or hitWall.Parent.Parent["CONNECTED TO"].Value.Parent == nil) then

							hideWall(hitWall)
							hideWall(newConveyor.Walls.LeftWall)

							hitWall.Parent.Parent["CONNECTED TO"].Value = newConveyor.Walls.LeftWall

							local newVel = newConveyor.Conveyor.CFrame.LookVector * math.sqrt((newConveyor.Configuration.Speed.Value^2)/2)
							newVel = newVel + newConveyor.Conveyor.CFrame.RightVector * math.sqrt((newConveyor.Configuration.Speed.Value^2)/2)
							newConveyor.Conveyor.AssemblyLinearVelocity = newVel
						end
					end
						
					if rightRay then
						
						local hitWall = rightRay.Instance
						while hitWall.Parent.Name ~= "Walls" do
							hitWall = hitWall.Parent
						end

						if hitWall.Name == "FrontWall" and (not hitWall.Parent.Parent["CONNECTED TO"].Value or hitWall.Parent.Parent["CONNECTED TO"].Value.Parent == nil) then

							hideWall(hitWall)
							hideWall(newConveyor.Walls.RightWall)

							hitWall.Parent.Parent["CONNECTED TO"].Value = newConveyor.Walls.RightWall

							local newVel = newConveyor.Conveyor.CFrame.LookVector * math.sqrt((newConveyor.Configuration.Speed.Value^2)/2)
							newVel = newVel - newConveyor.Conveyor.CFrame.RightVector * math.sqrt((newConveyor.Configuration.Speed.Value^2)/2)
							newConveyor.Conveyor.AssemblyLinearVelocity = newVel
						end
					end
				end
			end
		end
	end
end)


removeRemote.OnServerEvent:Connect(function(plr, conveyor)
	
	if plr and conveyor and conveyor.Parent == createdConveyors then
		
		if conveyor.CREATOR.Value == plr.UserId then
			
			if conveyor["CONNECTED TO"].Value and conveyor["CONNECTED TO"].Value.Parent ~= nil then
				showWall(conveyor["CONNECTED TO"].Value)
				conveyor["CONNECTED TO"].Value.Parent.Parent.Conveyor.AssemblyLinearVelocity = conveyor["CONNECTED TO"].Value.Parent.Parent.Conveyor.CFrame.LookVector * conveyor["CONNECTED TO"].Value.Parent.Parent.Configuration.Speed.Value
			end
			
			conveyor:Destroy()
		end
	end
end)