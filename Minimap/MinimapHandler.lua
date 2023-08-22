local screenGui = script.Parent
local frame = script.Parent:WaitForChild("MinimapFrame")
local arrow = frame:WaitForChild("DirectionArrow")


local plr = game.Players.LocalPlayer

local char = plr.Character or plr.CharacterAdded:Wait()

local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")


local uis = game:GetService("UserInputService")


local vpf = Instance.new("ViewportFrame", frame)
vpf.Size = UDim2.new(1, 0, 1, 0)
vpf.BackgroundTransparency = 1


local currentCamera = Instance.new("Camera")

currentCamera.FieldOfView = 1
currentCamera.CameraType = Enum.CameraType.Scriptable

currentCamera.Parent = workspace


vpf.CurrentCamera = currentCamera


local parts = script:WaitForChild("MinimapParts")
parts.Parent = workspace

local partsCF = CFrame.Angles(math.rad(90), 0, 0) * CFrame.new(-15, -10, 3)


for i, minimapObject in pairs(workspace.Map:GetDescendants()) do

	if minimapObject:IsA("BasePart") then
		
		minimapObject:Clone().Parent = vpf
	end
end


game:GetService("RunService").RenderStepped:Connect(function()
	
	local camCFrame = CFrame.new(hrp.Position + Vector3.new(0, 5000, 0), hrp.Position)
	
	currentCamera.CFrame = camCFrame
	
	
	parts:SetPrimaryPartCFrame(workspace.CurrentCamera.CFrame * partsCF)
	
	
	vpf.Rotation = hrp.Orientation.Y + 90
end)



uis.InputBegan:Connect(function(inp, processed)	
	
	
	if not processed and inp.KeyCode == Enum.KeyCode.M then		
		
		if partsCF == CFrame.Angles(math.rad(90), 0, 0) * CFrame.new(-15, -10, 3) then
			
			partsCF = CFrame.Angles(math.rad(90), 0, 0) * CFrame.new(0, -6, 0)
			
		else
			partsCF = CFrame.Angles(math.rad(90), 0, 0) * CFrame.new(-15, -10, 3)
		end
	end
end)