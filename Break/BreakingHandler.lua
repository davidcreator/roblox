local glass = script.Parent

local isBroken = false


glass.Touched:Connect(function(hit)
	

	if game.Players:GetPlayerFromCharacter(hit.Parent) and not isBroken then
		
		isBroken = true
		
		
		local minX, maxX = glass.Position.X - glass.Size.X/2, glass.Position.X + glass.Size.X/2
		local minY, maxY = glass.Position.Y - glass.Size.Y/2, glass.Position.Y + glass.Size.Y/2

		local pointOfBreak = Vector3.new(math.random(minX, maxX), math.random(minY, maxY), glass.Position.Z)
		
		local bottomLeft = Vector3.new(glass.Position.X - glass.Size.X/2, glass.Position.Y - glass.Size.Y/2, glass.Position.Z)
		local topLeft = Vector3.new(glass.Position.X - glass.Size.X/2, glass.Position.Y + glass.Size.Y/2, glass.Position.Z)
		local bottomRight = Vector3.new(glass.Position.X + glass.Size.X/2, glass.Position.Y - glass.Size.Y/2, glass.Position.Z)
		local topRight = Vector3.new(glass.Position.X + glass.Size.X/2, glass.Position.Y + glass.Size.Y/2, glass.Position.Z)
		
		
		local part1 = Instance.new("Part")
		part1.Size = Vector3.new(pointOfBreak.X - bottomLeft.X, pointOfBreak.Y - bottomLeft.Y, glass.Size.Z)
		part1.Position = Vector3.new(bottomLeft.X + part1.Size.X/2, bottomLeft.Y + part1.Size.Y/2, glass.Position.Z)
		
		local part2 = Instance.new("Part")
		part2.Size = Vector3.new(pointOfBreak.X - topLeft.X, topLeft.Y - pointOfBreak.Y, glass.Size.Z)
		part2.Position = Vector3.new(topLeft.X + part2.Size.X/2, topLeft.Y - part2.Size.Y/2, glass.Position.Z)
		
		local part3 = Instance.new("Part")
		part3.Size = Vector3.new(bottomRight.X - pointOfBreak.X, pointOfBreak.Y - bottomRight.Y, glass.Size.Z)
		part3.Position = Vector3.new(bottomRight.X - part3.Size.X/2, bottomRight.Y + part3.Size.Y/2, glass.Position.Z)
		
		local part4 = Instance.new("Part")
		part4.Size = Vector3.new(topRight.X - pointOfBreak.X, topRight.Y - pointOfBreak.Y, glass.Size.Z)
		part4.Position = Vector3.new(topRight.X - part4.Size.X/2, topRight.Y - part4.Size.Y/2, glass.Position.Z)
		
		
		local wedges = {}
		
		
		local wedge1 = Instance.new("WedgePart")
		wedge1.Orientation = Vector3.new(0, -90, 180)
		wedge1.Size = Vector3.new(part1.Size.Z, part1.Size.Y, part1.Size.X)
		wedge1.Position = part1.Position
		table.insert(wedges, wedge1)
		
		local wedge2 = Instance.new("WedgePart")
		wedge2.Orientation = Vector3.new(0, 90, 0)
		wedge2.Size = Vector3.new(part1.Size.Z, part1.Size.Y, part1.Size.X)
		wedge2.Position = part1.Position
		table.insert(wedges, wedge2)
		
		
		local wedge3 = Instance.new("WedgePart")
		wedge3.Orientation = Vector3.new(0, -90, 0)
		wedge3.Size = Vector3.new(part2.Size.Z, part2.Size.Y, part2.Size.X)
		wedge3.Position = part2.Position
		table.insert(wedges, wedge3)

		local wedge4 = Instance.new("WedgePart")
		wedge4.Orientation = Vector3.new(0, 90, 180)
		wedge4.Size = Vector3.new(part2.Size.Z, part2.Size.Y, part2.Size.X)
		wedge4.Position = part2.Position
		table.insert(wedges, wedge4)
		
		
		local wedge5 = Instance.new("WedgePart")
		wedge5.Orientation = Vector3.new(0, -90, 0)
		wedge5.Size = Vector3.new(part3.Size.Z, part3.Size.Y, part3.Size.X)
		wedge5.Position = part3.Position
		table.insert(wedges, wedge5)

		local wedge6 = Instance.new("WedgePart")
		wedge6.Orientation = Vector3.new(0, 90, 180)
		wedge6.Size = Vector3.new(part3.Size.Z, part3.Size.Y, part3.Size.X)
		wedge6.Position = part3.Position
		table.insert(wedges, wedge6)


		local wedge7 = Instance.new("WedgePart")
		wedge7.Orientation = Vector3.new(0, -90, 180)
		wedge7.Size = Vector3.new(part4.Size.Z, part4.Size.Y, part4.Size.X)
		wedge7.Position = part4.Position
		table.insert(wedges, wedge7)

		local wedge8 = Instance.new("WedgePart")
		wedge8.Orientation = Vector3.new(0, 90, 0)
		wedge8.Size = Vector3.new(part4.Size.Z, part4.Size.Y, part4.Size.X)
		wedge8.Position = part4.Position
		table.insert(wedges, wedge8)
		
		
		for i, wedge in pairs(wedges) do
			
			wedge.Material = Enum.Material.Glass
			wedge.Transparency = 0.6
			wedge.Color = Color3.fromRGB(159, 243, 233)
			
			wedge.Parent = workspace
		end
		
		
		glass.Transparency = 1
		glass.CanCollide = false
	end
end)