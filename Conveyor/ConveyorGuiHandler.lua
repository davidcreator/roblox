local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")

local cam = workspace.CurrentCamera
local mouse = game.Players.LocalPlayer:GetMouse()

local selectedConveyor = nil
local currentRotation = 0

local conveyors = game:GetService("ReplicatedStorage"):WaitForChild("ConveyorSystemReplicatedStorage"):WaitForChild("Conveyors")
local placeRemote = game:GetService("ReplicatedStorage")["ConveyorSystemReplicatedStorage"]:WaitForChild("PlaceConveyorEvent")
local removeRemote = game:GetService("ReplicatedStorage")["ConveyorSystemReplicatedStorage"]:WaitForChild("RemoveConveyorEvent")

local openBtn = script.Parent:WaitForChild("ConveyorButton")
local frame = script.Parent:WaitForChild("ConveyorFrame")
frame.Visible = false
local scrollingFrame = frame:WaitForChild("ConveyorList")


function createConveyorFrame()
	
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child.ClassName == script:WaitForChild("ConveyorItem").ClassName then
			child:Destroy()
		end
	end
	
	local conveyorButtons = {}
	
	for _, conveyor in pairs(conveyors:GetChildren()) do
		
		local newButton = script:WaitForChild("ConveyorItem"):Clone()
		
		local conveyorName = conveyor.Name
		newButton.ConveyorName.Text = conveyorName
		
		local conveyorModel = conveyor:Clone()
		conveyorModel:PivotTo(CFrame.new())
		conveyorModel.Parent = newButton.ConveyorImage
		
		local currentCamera = Instance.new("Camera")
		currentCamera.CFrame = CFrame.new(conveyorModel:GetPivot().Position + Vector3.new(4, 3, 4), conveyorModel:GetPivot().Position + Vector3.new(0, -2, 0))
		newButton.ConveyorImage.CurrentCamera = currentCamera
		currentCamera.Parent = newButton.ConveyorImage
		
		newButton.MouseButton1Click:Connect(function()
			if selectedConveyor == conveyor then
				selectedConveyor = nil
			else
				selectedConveyor = conveyor
			end
		end)
		
		table.insert(conveyorButtons, {conveyor.Configuration.Speed.Value, newButton})
	end
	
	table.sort(conveyorButtons, function(a, b)
		return a[1] > b[1]
	end)
	
	for _, conveyorButton in pairs(conveyorButtons) do
		conveyorButton[2].Parent = scrollingFrame
	end
end

createConveyorFrame()
conveyors.ChildAdded:Connect(createConveyorFrame)
conveyors.ChildRemoved:Connect(createConveyorFrame)


openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
	
	if frame.Visible == false then
		selectedConveyor = nil
	end
end)


uis.InputBegan:Connect(function(inp, p)

	if p then return end

	if inp.KeyCode == Enum.KeyCode.R then
		currentRotation += 90
		
	elseif inp.KeyCode == Enum.KeyCode.X then
		
		local rayparams = RaycastParams.new()
		rayparams.FilterType = Enum.RaycastFilterType.Whitelist
		rayparams.FilterDescendantsInstances = {workspace:WaitForChild("CREATED CONVEYORS")}
		local mouseRay = workspace:Raycast(cam.CFrame.Position, CFrame.new(cam.CFrame.Position, mouse.Hit.Position).LookVector * 100, rayparams)

		if mouseRay then

			local conveyor = mouseRay.Instance.Parent
			while conveyor.Parent ~= workspace["CREATED CONVEYORS"] do
				conveyor = conveyor.Parent
			end

			if conveyor.CREATOR.Value == game.Players.LocalPlayer.UserId then
				removeRemote:FireServer(conveyor)
			end
		end
	end
end)


mouse.Button1Up:Connect(function()
	
	if selectedConveyor then	
		local conveyorModel = cam:FindFirstChild("SELECTED CONVEYOR")
		if conveyorModel then
			
			local overlapparams = OverlapParams.new()
			overlapparams.FilterType = Enum.RaycastFilterType.Whitelist
			overlapparams.FilterDescendantsInstances = {workspace:WaitForChild("CREATED CONVEYORS")}
			local partsInConveyor = workspace:GetPartBoundsInBox(conveyorModel.Conveyor.CFrame, conveyorModel.Conveyor.Size, overlapparams)

			local conveyorBlocked = false

			for _, part in pairs(partsInConveyor) do
				if part.Name == "Conveyor" then
					conveyorBlocked = true
					break
				end
			end
			
			local raycastparams = RaycastParams.new()
			raycastparams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
			local downRay = workspace:Raycast(conveyorModel:GetPivot().Position, Vector3.new(0, -100, 0), raycastparams)

			if not downRay or downRay.Instance:FindFirstAncestorWhichIsA("Folder") == workspace:WaitForChild("CREATED CONVEYORS") then
				conveyorBlocked = true
			end
			
			if not conveyorBlocked then
				
				local pos = conveyorModel:GetPivot().Position
				local rot = currentRotation
				
				placeRemote:FireServer(selectedConveyor, pos, rot)
			end
		end
	end
end)


rs.Heartbeat:Connect(function()
	
	if selectedConveyor then
		
		local conveyorModel = nil
		
		if cam:FindFirstChild("SELECTED CONVEYOR") and cam["SELECTED CONVEYOR"].ConveyorName.Value == selectedConveyor.Name then
			conveyorModel = cam["SELECTED CONVEYOR"]
			
		else
			
			if cam:FindFirstChild("SELECTED CONVEYOR") then
				cam["SELECTED CONVEYOR"]:Destroy()
			end
			
			conveyorModel = selectedConveyor:Clone()
			
			for _, desc in pairs(conveyorModel:GetDescendants()) do
				if desc:IsA("BasePart") then
					
					desc.CanCollide = false
					desc.Transparency = 0.7
					
					local r = Instance.new("NumberValue")
					r.Name = "R"
					r.Value = desc.Color.R
					r.Parent = desc
					local g = Instance.new("NumberValue")
					g.Name = "G"
					g.Value = desc.Color.G
					g.Parent = desc
					local b = Instance.new("NumberValue")
					b.Name = "B"
					b.Value = desc.Color.B
					b.Parent = desc
					
					desc.Color = Color3.new(r.Value, math.clamp(g.Value + 0.3, 0, 1), b.Value)
				end
			end
			
			local nameValue = Instance.new("StringValue")
			nameValue.Name = "ConveyorName"
			nameValue.Value = selectedConveyor.Name
			nameValue.Parent = conveyorModel
		end
		
		conveyorModel.Name = "SELECTED CONVEYOR"
		conveyorModel.Parent = cam
		
		local rayparams = RaycastParams.new()
		rayparams.FilterDescendantsInstances = {conveyorModel, game.Players.LocalPlayer.Character}
		local mouseRay = workspace:Raycast(cam.CFrame.Position, CFrame.new(cam.CFrame.Position, mouse.Hit.Position).LookVector * 100, rayparams)
		
		if mouseRay and (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - mouseRay.Position).Magnitude <= 30 then
			
			local pos = mouseRay.Position
			pos = Vector3.new(math.round(pos.X * 2)/2, math.round(pos.Y * 2)/2, math.round(pos.Z * 2)/2)
			pos = pos + Vector3.new(0, conveyorModel.Conveyor.Size.Y/2, 0)
			
			conveyorModel:PivotTo(CFrame.new(pos) * CFrame.Angles(0, math.rad(currentRotation), 0))
			
			local overlapparams = OverlapParams.new()
			overlapparams.FilterType = Enum.RaycastFilterType.Whitelist
			overlapparams.FilterDescendantsInstances = {workspace:WaitForChild("CREATED CONVEYORS")}
			local partsInConveyor = workspace:GetPartBoundsInBox(conveyorModel.Conveyor.CFrame, conveyorModel.Conveyor.Size, overlapparams)
			
			local conveyorBlocked = false
			
			for _, part in pairs(partsInConveyor) do
				if part.Name == "Conveyor" then
					conveyorBlocked = true
					break
				end
			end
			
			local raycastparams = RaycastParams.new()
			raycastparams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
			local downRay = workspace:Raycast(pos, Vector3.new(0, -100, 0), raycastparams)

			if not downRay or downRay.Instance:FindFirstAncestorWhichIsA("Folder") == workspace:WaitForChild("CREATED CONVEYORS") then
				conveyorBlocked = true
			end
			
			for _, desc in pairs(conveyorModel:GetDescendants()) do
				if desc:IsA("BasePart") then
					
					if conveyorBlocked then
						desc.Color = Color3.new(math.clamp(desc.R.Value + 0.5, 0, 1), desc.G.Value, desc.B.Value)
					else
						desc.Color = Color3.new(desc.R.Value, math.clamp(desc.G.Value + 0.3, 0, 1), desc.B.Value)
					end
				end
			end
			
		else
			conveyorModel:Destroy()
		end
		
	else
		
		if cam:FindFirstChild("SELECTED CONVEYOR") then
			cam["SELECTED CONVEYOR"]:Destroy()
		end
	end
end)