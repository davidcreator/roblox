game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)


local template = script:WaitForChild("PlayerFrame")

local scroller = script.Parent:WaitForChild("PlayerScroller")



function updatePlayers()
	
	
	for i, child in pairs(scroller:GetChildren()) do
		
		if child:IsA("Frame") then child:Destroy() end
	end
	
	
	for i, plr in pairs(game.Players:GetPlayers()) do
		
		
		local img = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		
		
		local templateClone = template:Clone()
		
		
		templateClone.DisplayName.Text = plr.DisplayName
		templateClone.RealName.Text = "@" .. plr.Name
		
		
		local part = Instance.new("Part")
		part.Shape = Enum.PartType.Cylinder
		part.Orientation = Vector3.new(0, -90, 0)
		part.Size = Vector3.new(1, 1, 1)
		part.Transparency = 1
		
		
		local decal = Instance.new("Decal", part)
		decal.Face = Enum.NormalId.Right
		
		decal.Texture = img
		
		
		local camera = Instance.new("Camera")
		camera.CFrame = part.CFrame * CFrame.Angles(0, math.rad(90), 0) + Vector3.new(0, 0, 1.25)
		
		templateClone.CharacterImage.CurrentCamera = camera
		camera.Parent = templateClone.CharacterImage
		
		part.Parent = templateClone.CharacterImage
		
		
		templateClone.Parent = scroller
		
		
		scroller.CanvasSize = UDim2.new(0, 0, 0, scroller.UIListLayout.AbsoluteContentSize.Y)
	end
end


updatePlayers()
game.Players.PlayerAdded:Connect(updatePlayers)
game.Players.PlayerRemoving:Connect(updatePlayers)