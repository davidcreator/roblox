local increment = 15

function findClosestStructure(structure:Model, position:Vector3, rotation:number)
	
	rotation = math.round(rotation / 90) * 90
	position = position - Vector3.new(0, increment/2, 0)
	position = Vector3.new(math.round(position.X / increment) * increment, math.round(position.Y / increment) * increment, math.round(position.Z / increment) * increment)
	
	local hitboxSize = structure.Hitbox.Size
	
	local overlapParams = OverlapParams.new()
	overlapParams.FilterType = Enum.RaycastFilterType.Whitelist
	local filter = {}
	for _, d in pairs(workspace["STRUCTURES"]:GetDescendants()) do
		if d.Name == "HumanoidRootPart" or d.Name == "Hitbox" then
			table.insert(filter, d)
		end
	end
	overlapParams.FilterDescendantsInstances = filter
	
	local parts = workspace:GetPartBoundsInBox(CFrame.new(position + Vector3.new(0, increment/2 + 0.01, 0)) * CFrame.Angles(0, math.rad(rotation), 0), hitboxSize, overlapParams)
	
	for _, part in pairs(parts) do
		if (part.Name == "HumanoidRootPart" or part.Name == "Hitbox") and (part.Position - position).Magnitude < increment then
			return
		end
	end
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Whitelist
	raycastParams.FilterDescendantsInstances = filter
	
	local r1 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(0, -increment/2 - 1, 0), raycastParams)
	local r2 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(0, -increment/2 - 1, -increment/2 - 1), raycastParams)
	local r3 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(0, -increment/2 - 1, increment/2 + 1), raycastParams)
	local r4 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(-increment/2 - 1, -increment/2 - 1, 0), raycastParams)
	local r5 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(increment/2 + 1, -increment/2 - 1, 0), raycastParams)
	local r6 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(0, 0, -increment/2 - 1), raycastParams)
	local r7 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(0, 0, increment/2 + 1), raycastParams)
	local r8 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(-increment/2 - 1, 0, 0), raycastParams)
	local r9 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(increment/2 + 1, 0, 0), raycastParams)
	local r10 = workspace:Raycast(position + Vector3.new(0, 0.001, 0), Vector3.new(0, -increment/2 - 1, 0))
	
	local raycastPosition = nil
	
	if r1 and r1.Instance.Anchored == true then print(r1)
		raycastPosition = r1.Instance.Position + Vector3.new(0, increment, 0)
	elseif r2 and r2.Instance.Anchored == true then
		raycastPosition = r2.Instance.Position + Vector3.new(0, increment, increment)
	elseif r3 and r3.Instance.Anchored == true then
		raycastPosition = r3.Instance.Position + Vector3.new(0, increment, -increment)
	elseif r4 and r4.Instance.Anchored == true then
		raycastPosition = r4.Instance.Position + Vector3.new(increment, increment, 0)
	elseif r5 and r5.Instance.Anchored == true then
		raycastPosition = r5.Instance.Position + Vector3.new(-increment, increment, 0)
	elseif r6 and r6.Instance.Anchored == true then
		raycastPosition = r6.Instance.Position + Vector3.new(0, 0, increment)
	elseif r7 and r7.Instance.Anchored == true then
		raycastPosition = r7.Instance.Position + Vector3.new(0, 0, -increment)
	elseif r8 and r8.Instance.Anchored == true then
		raycastPosition = r8.Instance.Position + Vector3.new(increment, 0, 0)
	elseif r9 and r9.Instance.Anchored == true then
		raycastPosition = r9.Instance.Position + Vector3.new(-increment, 0, 0)
	elseif r10 and r10.Instance.Anchored == true then
		raycastPosition = r10.Position + Vector3.new(0, increment/2, 0)
	end
	
	if raycastPosition then
		return CFrame.new(raycastPosition) * CFrame.Angles(0, math.rad(rotation), 0)
	end
end

return findClosestStructure
