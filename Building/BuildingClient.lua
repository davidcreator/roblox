local frame = script.Parent:WaitForChild("BuildingFrame")
local template = script:WaitForChild("StructureButton")


local structures = game.ReplicatedStorage:WaitForChild("Structures")

local remote = game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PlaceStructure")


local char = game.Players.LocalPlayer.Character

local cam = workspace.CurrentCamera

local mouse = game.Players.LocalPlayer:GetMouse()
local uis = game:GetService("UserInputService")


local structureHotkeys = {}
local hotkeyOrder = {
	"Q","W","E","R","T","Y","U","I","O","P","A","S","D","F","G","H","J","K","L","Z","X","C","V","B","N","M"
}


local increment = 15


local selectedStructure = nil
local currentRot = 0


local buttons = {}

for _, structure in pairs(structures:GetChildren()) do
	
	structureHotkeys[Enum.KeyCode[structure.Hotkey.Value]] = structure
	
	local button = template:Clone()
	button.StructureName.Text = structure.Name
	button.Hotkey.Text = structure.Hotkey.Value
	
	local structureModel = structure:Clone()
	structureModel:PivotTo(CFrame.new())
	structureModel.Parent = button.StructureImage
	
	local cf, size = structureModel:GetBoundingBox()
	
	local currentCam = Instance.new("Camera")
	currentCam.CFrame = CFrame.new(Vector3.new(12, 12, 12), Vector3.new(0, cf.Position.Y, 0))
	currentCam.Parent = button.StructureImage
	button.StructureImage.CurrentCamera = currentCam
	
	button.MouseButton1Click:Connect(function()
		if selectedStructure == structure then
			selectedStructure = nil
		else
			selectedStructure = structure
		end
	end)
	
	table.insert(buttons, button)
end

table.sort(buttons, function(a, b)
	return table.find(hotkeyOrder, a.Hotkey.Text) < table.find(hotkeyOrder, b.Hotkey.Text)
end)

for _, button in pairs(buttons) do
	button.Parent = frame
end


uis.InputEnded:Connect(function(inp, p)
	if p then return end
	
	if selectedStructure and inp.KeyCode == Enum.KeyCode.R then
		currentRot += 90
		
	elseif selectedStructure and selectedStructure == structureHotkeys[inp.KeyCode] then
		selectedStructure = nil
		
	elseif structureHotkeys[inp.KeyCode] then
		selectedStructure = structureHotkeys[inp.KeyCode]
	end
end)


game:GetService("RunService").Heartbeat:Connect(function()
	
	if selectedStructure then
		if not cam:FindFirstChildOfClass("Model") or selectedStructure.Name ~= cam:FindFirstChildOfClass("Model").Name then
			
			if cam:FindFirstChildOfClass("Model") then cam:FindFirstChildOfClass("Model"):Destroy() end
			
			local newStructureModel = selectedStructure:Clone()
			for _, d in pairs(newStructureModel:GetDescendants()) do
				if d:IsA("BasePart") and d.Name ~= "Hitbox" then
					d.Color = Color3.new(d.Color.R, math.clamp(d.Color.G + 0.4, 0, 1), d.Color.B)
					d.Transparency = 0.5
					d.CanCollide = false
					d.CastShadow = false
				end
			end
			newStructureModel:PivotTo(mouse.Hit)
			newStructureModel.Parent = cam
		end
		
		local structureModel = cam:FindFirstChildOfClass("Model")

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {char, cam, workspace["STRUCTURES"]}
		local mouseRay = workspace:Raycast(cam.CFrame.Position, CFrame.new(cam.CFrame.Position, mouse.Hit.Position).LookVector * ((cam.CFrame.Position - char.Head.Position).Magnitude + 15), raycastParams)

		local y, x, z = cam.CFrame:ToEulerAnglesYXZ()
		local cameraAngle = math.deg(x)
		cameraAngle = math.round(cameraAngle/90)*90 + 90
			
		local newCurrentRot = cameraAngle + currentRot
			
		local structurePosition = mouseRay and mouseRay.Position or cam.CFrame.Position + CFrame.new(cam.CFrame.Position, mouse.Hit.Position).LookVector * ((cam.CFrame.Position - char.Head.Position).Magnitude + 15)
		structurePosition = Vector3.new(math.round(structurePosition.X/increment) * increment, math.round(structurePosition.Y/increment) * increment, math.round(structurePosition.Z/increment) * increment)
		structurePosition += Vector3.new(0, structureModel.Hitbox.Size.Y/2, 0)
			
		local modelCF = CFrame.new(structurePosition) * CFrame.Angles(0, math.rad(newCurrentRot), 0)
		structureModel:PivotTo(structureModel:GetPivot():Lerp(modelCF, 0.5))
		
	elseif cam:FindFirstChildOfClass("Model") then
		cam:FindFirstChildOfClass("Model"):Destroy()
	end
end)


mouse.Button1Up:Connect(function()
	
	if selectedStructure then
		
		local y, x, z = cam.CFrame:ToEulerAnglesYXZ()
		local cameraAngle = math.deg(x)
		cameraAngle = math.round(cameraAngle/90)*90 + 90

		local newCurrentRot = cameraAngle + currentRot
			
		local structurePosition = cam:FindFirstChildOfClass("Model"):GetPivot().Position
		remote:FireServer(selectedStructure, structurePosition, newCurrentRot)
	end
end)