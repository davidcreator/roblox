local markersFolder = game.Players.LocalPlayer:WaitForChild("MarkersClaimed")

local frame = script.Parent.ClaimedFrame
frame.Visible = false


function createUI()
	
	for i, uiElement in pairs(frame.MarkersScrollingFrame:GetChildren()) do
		
		if uiElement:IsA("Frame") then uiElement:Destroy() end
	end
	
	for i, marker in pairs(markersFolder:GetChildren()) do
		
		local newFrame = script.MarkerFrame:Clone()
		newFrame.MarkerName.Text = marker.Name
		
		local camera = Instance.new("Camera", newFrame.MarkerImage)
		newFrame.MarkerImage.CurrentCamera = camera
		
		local markerModel = workspace.Markers[marker.Name]:Clone()
		markerModel.Parent = newFrame.MarkerImage.CurrentCamera
		
		camera.CFrame = CFrame.new(markerModel.PrimaryPart.Position - markerModel.PrimaryPart.CFrame.UpVector * 2, markerModel.PrimaryPart.Position) * CFrame.Angles(0, 0, 45)
		
		newFrame.Parent = frame.MarkersScrollingFrame
		
		frame.MarkersScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, frame.MarkersScrollingFrame.UIGridLayout.AbsoluteContentSize.Y)
	end
end


script.Parent.OpenButton.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

frame.CloseButton.MouseButton1Click:Connect(function()
	frame.Visible = false
end)


createUI()

markersFolder.DescendantAdded:Connect(createUI)