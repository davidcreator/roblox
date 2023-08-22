local characters = game.ReplicatedStorage:WaitForChild("CharactersFolder")
local remoteEvent = game.ReplicatedStorage:WaitForChild("CharacterShopRE")

local ownedCharacters = game.Players.LocalPlayer:WaitForChild("OwnedCharacters")


function setupGui(scrollingFrame, folder)
	
	local canvasPosition = scrollingFrame.CanvasPosition

	for i, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	
	local frames = {}

	for i, character in pairs(folder:GetChildren()) do

		local newFrame = script.CharacterPreviewFrame:Clone()
		newFrame.CharacterNameLabel.Text = character.Name

		local camera = Instance.new("Camera", newFrame.CharacterViewportFrame)
		newFrame.CharacterViewportFrame.CurrentCamera = camera

		local characterModel = game.ReplicatedStorage.CharactersFolder[character.Name]:Clone()
		characterModel.Parent = newFrame.CharacterViewportFrame
		
		local hrp = characterModel.PrimaryPart
		camera.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 7, hrp.Position)

		newFrame.ViewButton.MouseButton1Click:Connect(function()

			local viewerFrame = scrollingFrame.Parent.Parent.CharacterViewerFrame
			viewerFrame.CharacterNameLabel.Text = character.Name

			if viewerFrame:FindFirstChild("PriceLabel") then
				viewerFrame.PriceLabel.Text = "$" .. character.Price.Value
			end
			
			viewerFrame.CharacterViewportFrame:ClearAllChildren()

			local camera2 = camera:Clone()
			camera2.Parent = viewerFrame.CharacterViewportFrame
			viewerFrame.CharacterViewportFrame.CurrentCamera = camera2

			local characterModel2 = characterModel:Clone()
			characterModel2.Parent = viewerFrame.CharacterViewportFrame

			local button = viewerFrame:FindFirstChild("BuyButton") or viewerFrame:FindFirstChild("EquipButton")

			if button.Name == "BuyButton" and ownedCharacters:FindFirstChild(character.Name) then
				button.Text = "OWNED"
				button.BackgroundColor3 = Color3.fromRGB(195, 195, 195)

			elseif button.Name == "EquipButton" and game.Players.LocalPlayer.EquippedCharacter.Value == character.Name then
				button.Text = "USING"
				button.BackgroundColor3 = Color3.fromRGB(195, 195, 195)

			else
				button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				
				if button.Name == "BuyButton" then button.Text = "BUY"
				elseif button.Name == "EquipButton" then button.Text = "USE"
				end
			end

			viewerFrame.Visible = true
		end)
		
		table.insert(frames, newFrame)
	end
	
	table.sort(frames, function(a, b)
		local aPrice = game.ReplicatedStorage.CharactersFolder[a.CharacterNameLabel.Text].Price.Value
		local bPrice = game.ReplicatedStorage.CharactersFolder[b.CharacterNameLabel.Text].Price.Value
		return aPrice < bPrice
	end)
	
	local frameSize = nil
	
	for i, frame in pairs(frames) do
		frame.Parent = scrollingFrame
		frame.Size = frameSize or UDim2.new(0, frame.AbsoluteSize.X, 0, frame.AbsoluteSize.Y)
		if i == 1 then frameSize = frame.Size end
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, scrollingFrame.UIListLayout.AbsoluteContentSize.Y)
	end
	
	if scrollingFrame.Parent.Parent.CharacterViewerFrame.Visible == true then
		if scrollingFrame.Parent.Parent.Name == "ShopFrame" and ownedCharacters:FindFirstChild(scrollingFrame.Parent.Parent.CharacterViewerFrame.CharacterNameLabel.Text) then
			scrollingFrame.Parent.Parent.CharacterViewerFrame.BuyButton.Text = "OWNED"
			scrollingFrame.Parent.Parent.CharacterViewerFrame.BuyButton.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
		elseif scrollingFrame.Parent.Parent.Name == "InventoryFrame" and game.Players.LocalPlayer.EquippedCharacter.Value == scrollingFrame.Parent.Parent.CharacterViewerFrame.CharacterNameLabel.Text then
			scrollingFrame.Parent.Parent.CharacterViewerFrame.EquipButton.Text = "USING"
			scrollingFrame.Parent.Parent.CharacterViewerFrame.EquipButton.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
		elseif scrollingFrame.Parent.Parent.Name == "InventoryFrame" then
			scrollingFrame.Parent.Parent.CharacterViewerFrame.EquipButton.Text = "USE"
			scrollingFrame.Parent.Parent.CharacterViewerFrame.EquipButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
	scrollingFrame.CanvasPosition = canvasPosition
end

setupGui(script.Parent.ShopFrame.CharacterScrollingBackgroundFrame.CharacterScrollingFrame, characters)
setupGui(script.Parent.InventoryFrame.CharacterScrollingBackgroundFrame.CharacterScrollingFrame, ownedCharacters)

characters.ChildAdded:Connect(function()
	setupGui(script.Parent.ShopFrame.CharacterScrollingBackgroundFrame.CharacterScrollingFrame, characters)
end)
ownedCharacters.ChildAdded:Connect(function()
	setupGui(script.Parent.InventoryFrame.CharacterScrollingBackgroundFrame.CharacterScrollingFrame, ownedCharacters)
	setupGui(script.Parent.ShopFrame.CharacterScrollingBackgroundFrame.CharacterScrollingFrame, characters)
end)


script.Parent.ShopFrame.CharacterViewerFrame.BuyButton.MouseButton1Click:Connect(function()
	local charName = script.Parent.ShopFrame.CharacterViewerFrame.CharacterNameLabel.Text
	remoteEvent:FireServer(charName, "buy")
end)

script.Parent.InventoryFrame.CharacterViewerFrame.EquipButton.MouseButton1Click:Connect(function()
	local charName = script.Parent.InventoryFrame.CharacterViewerFrame.CharacterNameLabel.Text
	remoteEvent:FireServer(charName, "use")
	wait(0.1)
	setupGui(script.Parent.InventoryFrame.CharacterScrollingBackgroundFrame.CharacterScrollingFrame, ownedCharacters)
end)

script.Parent.ShopFrame.Visible = false
script.Parent.ShopFrame.CharacterViewerFrame.Visible = false
script.Parent.InventoryFrame.Visible = false
script.Parent.InventoryFrame.CharacterViewerFrame.Visible = false

script.Parent.ShopButton.MouseButton1Click:Connect(function()
	script.Parent.ShopFrame.Visible = not script.Parent.ShopFrame.Visible
	script.Parent.InventoryFrame.Visible = false
end)
script.Parent.InventoryButton.MouseButton1Click:Connect(function()
	script.Parent.InventoryFrame.Visible = not script.Parent.InventoryFrame.Visible
	script.Parent.ShopFrame.Visible = false
end)
script.Parent.ShopFrame.CloseButton.MouseButton1Click:Connect(function()
	script.Parent.ShopFrame.Visible = false
end)
script.Parent.InventoryFrame.CloseButton.MouseButton1Click:Connect(function()
	script.Parent.InventoryFrame.Visible = false
end)