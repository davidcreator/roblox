local cam = workspace.CurrentCamera

local char = script.Parent
local hrp = char:WaitForChild("HumanoidRootPart")


local cas = game:GetService("ContextActionService")

cas:UnbindAction("moveForwardAction")
cas:UnbindAction("moveBackwardAction")


game:GetService("RunService").RenderStepped:Connect(function()
	
	cam.CameraType = Enum.CameraType.Scriptable
	
	cam.CFrame = cam.CFrame:Lerp(CFrame.new(hrp.Position + Vector3.new(0, 5, 10), hrp.Position), 0.1)
end)