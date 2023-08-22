--Disable default inventory UI
game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

--Close UI on start
script.Parent.Enabled = false

--Variables
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local count = 0

local frame = script.Parent:WaitForChild("InventoryFrame")
local pointer = script.Parent:WaitForChild("Pointer")

local circumference = frame.AbsoluteSize.X * math.pi

local currentlyHovering = nil

local camera = workspace.CurrentCamera
local mouse = game.Players.LocalPlayer:GetMouse()


--Open and close the UI
uis.InputBegan:Connect(function(inp, p)
	if inp.KeyCode == Enum.KeyCode.E and not p then
		
		script.Parent.Enabled = not script.Parent.Enabled
	end
end)


--Add tools onto radial inventory
function updateSectors()
	
	local tools = game.Players.LocalPlayer.Backpack:GetChildren()
	
	if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
		table.insert(tools, game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"))
	end
	
	count = #tools
	
	currentlyHovering = nil
	for i, sector in pairs(frame:GetChildren()) do
		if sector:IsA("Frame") then
			sector:Destroy()
		end
	end
	
	table.sort(tools, function(a, b)
		return a.Name < b.Name
	end)
	
	local absoluteSectorWidth = (circumference / count)
	local sectorWidth = absoluteSectorWidth / frame.AbsoluteSize.X
	
	for i, tool in pairs(tools) do
		
		local newSector = script:WaitForChild("SectorPivot"):Clone()
		newSector.Sector.Size = UDim2.new(sectorWidth, 0, 0.5, 0)
		
		local rotation = (i-1) * (360/count)
		
		newSector.Rotation = rotation
		
		newSector.Sector.ImageTransparency = 1
		
		if tool.TextureId ~= "" then
			newSector.Sector.ToolViewportFrame:Destroy()
			
			newSector.Sector.ToolImageLabel.Image = tool.TextureId
			newSector.Sector.ToolImageLabel.Rotation = -rotation
			newSector.Sector.ToolImageLabel.Name = "ToolImage"
			
		else
			newSector.Sector.ToolImageLabel:Destroy()
			
			local vpf = newSector.Sector.ToolViewportFrame
			local camera = Instance.new("Camera")
			vpf.CurrentCamera = camera
			camera.Parent = vpf
			
			local toolClone = tool:Clone()
			local toolModel = Instance.new("Model")
			toolModel.Parent = vpf
			
			for x, descendant in pairs(toolClone:GetDescendants()) do
				if descendant:IsA("LocalScript") or descendant:IsA("ScreenGui") then
					descendant:Destroy()
				end
			end
			for x, child in pairs(toolClone:GetChildren()) do
				child.Parent = toolModel
			end
			toolClone:Destroy()
			
			local orientation = toolModel:GetBoundingBox()
			
			camera.CFrame = CFrame.new(toolModel.Handle.Position + (toolModel.Handle.CFrame.LookVector * 2), toolModel.Handle.Position)
			
			vpf.Rotation = -rotation
			vpf.Name = "ToolImage"
		end
		
		newSector.Name = i
		
		local toolValue = Instance.new("StringValue")
		toolValue.Name = "TOOL NAME"
		toolValue.Value = tool.Name
		toolValue.Parent = newSector
		
		newSector.Parent = frame
		
		local newLine = script:WaitForChild("LinePivot"):Clone()
		newLine.Rotation = rotation + (360/count/2)
		newLine.Parent = frame
	end
end

updateSectors()
game.Players.LocalPlayer.Backpack.ChildAdded:Connect(updateSectors)
game.Players.LocalPlayer.Backpack.ChildRemoved:Connect(updateSectors)
game.Players.LocalPlayer.Character.ChildAdded:Connect(updateSectors)
game.Players.LocalPlayer.Character.ChildRemoved:Connect(updateSectors)


--Tell server to equip tool for the player when they click on the UI
mouse.Button1Up:Connect(function()
	if currentlyHovering and script.Parent.Enabled == true then
		game.ReplicatedStorage:WaitForChild("InventoryRE"):FireServer(currentlyHovering["TOOL NAME"].Value)
		script.Parent.Enabled = false
	end
end)


--Rotate the pointer and check which tool the player is hovering on
rs.Stepped:Connect(function()
	
	if count > 0 and script.Parent.Enabled == true then
		local x, y = mouse.X, mouse.Y
		local viewportSize = camera.ViewportSize / 2

		local angle = math.deg(math.atan2(y - viewportSize.Y, x - viewportSize.X)) - 90
		if angle < 0 then
			angle = angle + 360
		end
		
		pointer.Rotation = angle
		
		local space = 360/count/2
		for i = 1, count do
			local degrees = (i-1) * (360/count)
			
			local min = degrees - space
			local max = degrees + space
			
			if min < 0 then
				min = min + 360
			end
			
			if (angle > min and angle < max) or (i == 1 and (angle > min or (angle < max and angle >= 0))) then
				if currentlyHovering then
					currentlyHovering.Sector.ToolImage.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
				end
				currentlyHovering = frame[i]
				currentlyHovering.Sector.ToolImage.BackgroundColor3 = Color3.fromRGB(191, 191, 191)
			end
		end
	end
end)