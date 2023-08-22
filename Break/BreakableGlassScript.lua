for i, glass in pairs(workspace:WaitForChild("BreakableGlass"):GetChildren()) do
	
	local isBroken = false
	
	glass.Touched:Connect(function(hit)
		
		if not isBroken then
			isBroken = true
			
			
			local positionOfBreak = hit.Position * Vector3.new(1, 1, 0) + Vector3.new(0, 0, glass.Position.Z)			
			
			local bottomLeft = Vector3.new(glass.Position.X - glass.Size.X/2, glass.Position.Y - glass.Size.Y/2, glass.Position.Z)
			local topRight = Vector3.new(glass.Position.X + glass.Size.X/2, glass.Position.Y + glass.Size.Y/2, glass.Position.Z)
			local bottomRight = Vector3.new(glass.Position.X + glass.Size.X/2, glass.Position.Y - glass.Size.Y/2, glass.Position.Z)
			local topLeft = Vector3.new(glass.Position.X - glass.Size.X/2, glass.Position.Y + glass.Size.Y/2, glass.Position.Z)
			
			
			local wedges = {}
			
			local size = Vector3.new(
				positionOfBreak.X - bottomLeft.X, 
				positionOfBreak.Y - bottomLeft.Y, 
				glass.Size.Z
			)
			local pos = Vector3.new(
				bottomLeft.X + size.X/2, 
				bottomLeft.Y + size.Y/2,
				bottomLeft.Z + size.Z/2
			)
			local wedge1, wedge2 = Instance.new("WedgePart"), Instance.new("WedgePart")
			wedge1.Orientation = Vector3.new(0, -90, 180)
			wedge2.Orientation = Vector3.new(0, 90, 0)
			local rearrangedSize = Vector3.new(size.Z, size.Y, size.X)
			wedge1.Size, wedge2.Size = rearrangedSize, rearrangedSize
			wedge1.Position, wedge2.Position = pos, pos
			table.insert(wedges, wedge1)
			table.insert(wedges, wedge2)
			
			size = Vector3.new(
				positionOfBreak.X - topLeft.X,
				topLeft.Y - positionOfBreak.Y,
				glass.Size.Z
			)
			pos = Vector3.new(
				topLeft.X + size.X/2,
				topLeft.Y - size.Y/2, 
				glass.Position.Z
			)
			local wedge3, wedge4 = Instance.new("WedgePart"), Instance.new("WedgePart")
			wedge3.Orientation = Vector3.new(0, -90, 0)
			wedge4.Orientation = Vector3.new(0, 90, 180)
			local rearrangedSize = Vector3.new(size.Z, size.Y, size.X)
			wedge3.Size, wedge4.Size = rearrangedSize, rearrangedSize
			wedge3.Position, wedge4.Position = pos, pos
			table.insert(wedges, wedge3)
			table.insert(wedges, wedge4)
			
			size = Vector3.new(
				bottomRight.X - positionOfBreak.X,
				positionOfBreak.Y - bottomRight.Y,
				glass.Size.Z
			)
			pos = Vector3.new(
				bottomRight.X - size.X/2,
				bottomRight.Y + size.Y/2,
				glass.Position.Z
			)
			local wedge5, wedge6 = Instance.new("WedgePart"), Instance.new("WedgePart")
			wedge5.Orientation = Vector3.new(0, -90, 0)
			wedge6.Orientation = Vector3.new(0, 90, 180)
			local rearrangedSize = Vector3.new(size.Z, size.Y, size.X)
			wedge5.Size, wedge6.Size = rearrangedSize, rearrangedSize
			wedge5.Position, wedge6.Position = pos, pos
			table.insert(wedges, wedge5)
			table.insert(wedges, wedge6)
			
			size = Vector3.new(
				topRight.X - positionOfBreak.X,
				topRight.Y - positionOfBreak.Y,
				glass.Size.Z
			)
			pos = Vector3.new(
				topRight.X - size.X/2,
				topRight.Y - size.Y/2,
				glass.Position.Z
			)
			local wedge7, wedge8 = Instance.new("WedgePart"), Instance.new("WedgePart")
			wedge7.Orientation = Vector3.new(0, -90, 180)
			wedge8.Orientation = Vector3.new(0, 90, 0)
			local rearrangedSize = Vector3.new(size.Z, size.Y, size.X)
			wedge7.Size, wedge8.Size = rearrangedSize, rearrangedSize
			wedge7.Position, wedge8.Position = pos, pos
			table.insert(wedges, wedge7)
			table.insert(wedges, wedge8)
			
			
			local sound = script:WaitForChild("GlassSound"):Clone()
			sound.Parent = wedge1
			sound:Play()
			
			
			local velocity = hit.Velocity
			
			for i, wedge in pairs(wedges) do
				
				wedge.Material = glass.Material
				wedge.Transparency = glass.Transparency
				wedge.Color = glass.Color
				wedge.Parent = workspace
				
				local bv = Instance.new("BodyVelocity")
				bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				bv.Velocity = velocity / 3
				bv.Parent = wedge
				spawn(function()
					wait()
					bv:Destroy()
				end)
				
				game:GetService("Debris"):AddItem(wedge, 30)
			end
			
			glass:Destroy()
		end
	end)
end