local function onTouch(Touch)
 	if Touch.Parent:FindFirstChild("Humanoid") ~= nil then
		Touch.Parent.Humanoid.Health = 0
	
	end
end


script.Parent.HumanoidRootPart.Touched:Connect(onTouch)