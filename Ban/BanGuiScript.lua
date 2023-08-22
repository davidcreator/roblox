local remoteEvent = game.ReplicatedStorage:WaitForChild("BanGuiReplicatedStorage"):WaitForChild("BanRemoteEvent")

local tweenService = game:GetService("TweenService")

local frame = script.Parent:WaitForChild("BanFrame")
frame.Visible = false

local openBtn = script.Parent:WaitForChild("OpenButton")
local closeBtn = frame:WaitForChild("CloseButton")

local banFrame = frame:WaitForChild("BanBox")
local boxPos = banFrame.Position

local idBox = frame:WaitForChild("SearchIdBox")

local originalTransparencies = {}


function openFrame()
	
	frame:WaitForChild("BanBox").Visible = false
	
	local uiElements = frame:GetDescendants()
	table.insert(uiElements, frame)
	
	for i, d in pairs(uiElements) do
		if d:IsA("TextButton") or d:IsA("TextBox") or d:IsA("TextLabel") then
			local bT = d.BackgroundTransparency
			local tT = d.TextTransparency
			if originalTransparencies[d] then
				bT = originalTransparencies[d]["BackgroundTransparency"]
				tT = originalTransparencies[d]["TextTransparency"]
			end
			d.BackgroundTransparency = 1
			d.TextTransparency = 1
			
			originalTransparencies[d] = {BackgroundTransparency = bT, TextTransparency = tT}
			
		elseif d:IsA("ImageButton") or d:IsA("ImageLabel") or d:IsA("ViewportFrame") then
			local bT = d.BackgroundTransparency
			local iT = d.ImageTransparency
			if originalTransparencies[d] then
				bT = originalTransparencies[d]["BackgroundTransparency"]
				iT = originalTransparencies[d]["ImageTransparency"]
			end
			d.BackgroundTransparency = 1
			d.ImageTransparency = 1
			
			originalTransparencies[d] = {BackgroundTransparency = bT, ImageTransparency = iT}
			
		elseif d:IsA("Frame") then
			local bT = d.BackgroundTransparency
			if originalTransparencies[d] then
				bT = originalTransparencies[d]["BackgroundTransparency"]
			end
			d.BackgroundTransparency = 1
			
			originalTransparencies[d] = {BackgroundTransparency = bT}
			
		elseif d:IsA("UIStroke") then
			local sT = d.Transparency
			if originalTransparencies[d] then
				sT = originalTransparencies[d]["Transparency"]
			end
			d.Transparency = 1
			
			originalTransparencies[d] = {Transparency = sT}
		end
	end
	
	frame.Visible = true
	
	local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	
	frame.Position = UDim2.new(0.5, 0, 0.5, 8)
	local driftTween = tweenService:Create(frame, ti, {Position = UDim2.new(0.5, 0, 0.5, 0)})
	driftTween:Play()
	
	for uiElement, transparencies in pairs(originalTransparencies) do
		
		local goal = {}
		for property, value in pairs(transparencies) do
			goal[property] = value
		end
		
		local fadeTween = tweenService:Create(uiElement, ti, goal)
		fadeTween:Play()
	end
end

function closeFrame()
	
	local uiElements = frame:GetDescendants()
	table.insert(uiElements, frame)

	for i, d in pairs(uiElements) do
		if not originalTransparencies[d] then
			if d:IsA("TextButton") or d:IsA("TextBox") or d:IsA("TextLabel") then
				local bT = d.BackgroundTransparency
				local tT = d.TextTransparency
				originalTransparencies[d] = {BackgroundTransparency = bT, TextTransparency = tT}

			elseif d:IsA("ImageButton") or d:IsA("ImageLabel") or d:IsA("ViewportFrame") then
				local bT = d.BackgroundTransparency
				local iT = d.ImageTransparency
				originalTransparencies[d] = {BackgroundTransparency = bT, ImageTransparency = iT}

			elseif d:IsA("Frame") then
				local bT = d.BackgroundTransparency
				originalTransparencies[d] = {BackgroundTransparency = bT}

			elseif d:IsA("UIStroke") then
				local sT = d.Transparency
				originalTransparencies[d] = {Transparency = sT}
			end
		end
	end

	local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	local driftTween = tweenService:Create(frame, ti, {Position = UDim2.new(0.5, 0, 0.5, 8)})
	driftTween:Play()

	for uiElement, transparencies in pairs(originalTransparencies) do

		local goal = {}
		for property, value in pairs(transparencies) do
			goal[property] = 1
		end

		local fadeTween = tweenService:Create(uiElement, ti, goal)
		fadeTween:Play()
	end
	
	task.wait(0.3)
	frame.Visible = false
end


function btnFunc(btn)
	btn.AutoButtonColor = false
	
	local ti = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
	
	local colorProperty = btn:IsA("ImageButton") and "ImageColor3" or "BackgroundColor3"
	local ogColor = btn[colorProperty]
	local ogBColor = btn.BackgroundColor3
	
	local hoverColor = Color3.fromRGB(ogColor.R*255 - 20, ogColor.G*255 - 20, ogColor.B*255 - 20)
	local hoverBColor = Color3.fromRGB(ogBColor.R*255 - 20, ogBColor.G*255 - 20, ogBColor.B*255 - 20)

	btn.MouseEnter:Connect(function()
		
		local colorPropertycolorShift = tweenService:Create(btn, ti, {[colorProperty] = hoverColor, BackgroundColor3 = hoverBColor})
		colorPropertycolorShift:Play()
	end)
	
	btn.MouseLeave:Connect(function()

		local colorPropertycolorShift = tweenService:Create(btn, ti, {[colorProperty] = ogColor, BackgroundColor3 = ogBColor})
		colorPropertycolorShift:Play()
	end)
	
	local ogPos = btn.Position
	local clickPos = ogPos + UDim2.new(0, 0, 0, 2)
	local clickColor = Color3.fromRGB(hoverColor.R*255 - 20, hoverColor.G*255 - 20, hoverColor.B*255 - 20)
	local clickBColor = Color3.fromRGB(hoverBColor.R*255 - 20, hoverBColor.G*255 - 20, hoverBColor.B*255 - 20)
	
	btn.MouseButton1Down:Connect(function()
		
		local tween = tweenService:Create(btn, ti, {Position = clickPos, [colorProperty] = clickColor, BackgroundColor3 = clickBColor})
		tween:Play()
	end)
	
	btn.MouseButton1Up:Connect(function()

		local positionShift = tweenService:Create(btn, ti, {Position = ogPos, [colorProperty] = ogColor, BackgroundColor3 = ogBColor})
		positionShift:Play()
		
		if btn == openBtn then
			if not frame.Visible then
				openFrame()
			else
				closeFrame()
			end
			
		elseif btn == closeBtn then
			closeFrame()
			
		elseif btn == banFrame.BanButton then
			local name = banFrame.PlayerName.Text
			local userId = game.Players:GetUserIdFromNameAsync(name)
			
			local reason = banFrame.BanReasonTextBox.Text
			local days = banFrame.BanLengthTextBox.Text
			
			remoteEvent:FireServer(userId, reason, days)
			
		else
			openBanFrame(game.Players[btn.PlayerName.Text].UserId)
		end
	end)
end


function openBanFrame(userId)
	
	local success, plrName = pcall(function()
		return game.Players:GetNameFromUserIdAsync(userId)
	end)
	
	if plrName then
		local alreadyOpen = false
		if banFrame.Visible == true then
			local openName = banFrame.PlayerName.Text
			alreadyOpen = plrName == openName
		end
		
		if not alreadyOpen then
			banFrame.Visible = false
			
			banFrame.PlayerName.Text = plrName
			
			banFrame.PlayerViewportFrame:ClearAllChildren()
			
			local img = game.Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

			local pictureFrame = game.ReplicatedStorage.BanGuiReplicatedStorage.UserPictureFrame:Clone()
			local decal = Instance.new("Decal", pictureFrame)
			decal.Texture = img
			pictureFrame.Parent = banFrame.PlayerViewportFrame

			local camera = Instance.new("Camera", banFrame.PlayerViewportFrame)
			banFrame.PlayerViewportFrame.CurrentCamera = camera

			camera.CFrame = CFrame.new(pictureFrame.Position + (pictureFrame.CFrame.LookVector * 2.3), pictureFrame.Position)
			
			local uiElements = banFrame:GetDescendants()
			table.insert(uiElements, banFrame)

			for i, d in pairs(uiElements) do
				if d:IsA("TextButton") or d:IsA("TextBox") or d:IsA("TextLabel") then
					local bT = d.BackgroundTransparency
					local tT = d.TextTransparency
					if originalTransparencies[d] then
						bT = originalTransparencies[d]["BackgroundTransparency"]
						tT = originalTransparencies[d]["TextTransparency"]
					end
					
					d.BackgroundTransparency = 1
					d.TextTransparency = 1
					originalTransparencies[d] = {BackgroundTransparency = bT, TextTransparency = tT}

				elseif d:IsA("ImageButton") or d:IsA("ImageLabel") or d:IsA("ViewportFrame") then
					local bT = d.BackgroundTransparency
					local iT = d.ImageTransparency
					if originalTransparencies[d] then
						bT = originalTransparencies[d]["BackgroundTransparency"]
						iT = originalTransparencies[d]["ImageTransparency"]
					end
					d.BackgroundTransparency = 1
					d.ImageTransparency = 1
					originalTransparencies[d] = {BackgroundTransparency = bT, ImageTransparency = iT}

				elseif d:IsA("Frame") then
					local bT = d.BackgroundTransparency
					if originalTransparencies[d] then
						bT = originalTransparencies[d]["BackgroundTransparency"]
					end
					d.BackgroundTransparency = 1
					originalTransparencies[d] = {BackgroundTransparency = bT}

				elseif d:IsA("UIStroke") then
					local sT = d.Transparency
					if originalTransparencies[d] then
						sT = originalTransparencies[d]["Transparency"]
					end
					d.Transparency = 1
					originalTransparencies[d] = {Transparency = sT}
				end
			end
			
			banFrame.Position = boxPos + UDim2.new(0, 0, 0, 8)
			banFrame.Visible = true

			local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

			local driftTween = tweenService:Create(banFrame, ti, {Position = boxPos})
			driftTween:Play()

			for uiElement, transparencies in pairs(originalTransparencies) do

				local goal = {}
				for property, value in pairs(transparencies) do
					goal[property] = value
				end

				local fadeTween = tweenService:Create(uiElement, ti, goal)
				fadeTween:Play()
			end
		end
	end
end


function updatePlayerList()
	
	for i, child in pairs(frame:WaitForChild("PlayersList"):GetChildren()) do
		if child:IsA("ImageButton") or child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	local players = game.Players:GetPlayers()
	local playerButtons = {}
	
	for i, plr in pairs(players) do
		
		local newButton = script.PlayerButton:Clone()
		newButton.PlayerName.Text = plr.Name
		
		local img = game.Players:GetUserThumbnailAsync(plr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
		
		local pictureFrame = game.ReplicatedStorage.BanGuiReplicatedStorage.UserPictureFrame:Clone()
		local decal = Instance.new("Decal", pictureFrame)
		decal.Texture = img
		pictureFrame.Parent = newButton.PlayerViewportFrame
		
		local camera = Instance.new("Camera", newButton.PlayerViewportFrame)
		newButton.PlayerViewportFrame.CurrentCamera = camera
		
		camera.CFrame = CFrame.new(pictureFrame.Position + (pictureFrame.CFrame.LookVector * 2.3), pictureFrame.Position)
		
		btnFunc(newButton)
		
		table.insert(playerButtons, newButton)
	end
	
	table.sort(playerButtons, function(a, b)
		local aName = a.PlayerName.Text
		local bName = b.PlayerName.Text
		return aName < bName
	end)
	
	for i, playerBtn in pairs(playerButtons) do
		playerBtn.Parent = frame.PlayersList
	end
end
updatePlayerList()

game.Players.PlayerAdded:Connect(updatePlayerList)
game.Players.PlayerRemoving:Connect(updatePlayerList)

btnFunc(openBtn)
btnFunc(closeBtn)
btnFunc(banFrame.BanButton)


idBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		openBanFrame(idBox.Text)
	end
end)