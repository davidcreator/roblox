local cams = workspace:WaitForChild("Cameras")

local cam = workspace.CurrentCamera

local tweenService = game:GetService("TweenService")

wait(4)

cam.CameraType = Enum.CameraType.Scriptable


for i, camPart in pairs(cams:GetChildren()) do
	
	local tweenInfo = TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
	
	local goal = {CFrame = cams[i].CFrame}
	
	
	local tweenToNextCamera = tweenService:Create(cam, tweenInfo, goal)
	
	
	tweenToNextCamera:Play()
	
	tweenToNextCamera.Completed:Wait()
	
end

cam.CameraType = Enum.CameraType.Custom