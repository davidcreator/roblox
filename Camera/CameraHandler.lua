local cam = workspace.CurrentCamera

local char = script.Parent
local hrp = char:WaitForChild("HumanoidRootPart")


cam.CameraType = Enum.CameraType.Scriptable


local cameraPart = Instance.new("Part")
cameraPart.Transparency = 1
cameraPart.CanCollide = false
cameraPart.Parent = workspace

cameraPart.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 20, 0), hrp.Position)


local bp = Instance.new("BodyPosition")
bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
bp.Parent = cameraPart


game:GetService("RunService").RenderStepped:Connect(function()
	
	bp.Position = hrp.Position + Vector3.new(0, 20, 0)
	
	cam.CFrame = cameraPart.CFrame
end)