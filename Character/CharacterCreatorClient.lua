local items = game.ReplicatedStorage:WaitForChild("CharacterItems")
local re = game.ReplicatedStorage:WaitForChild("CharacterCreatorRE")

local frame = script.Parent:WaitForChild("CreatorFrame")
local button = script.Parent:WaitForChild("OpenGuiTextButton")
frame.Visible = false
button.Visible = true

local currentItems = {}


--Open and close GUI
button.MouseButton1Click:Connect(function()
	
	currentItems = {}
	for i, currentItem in pairs(game.Players.LocalPlayer:WaitForChild("CurrentItems"):GetChildren()) do
		table.insert(currentItems, currentItem.Name)
	end
	
	for x, child in pairs(frame.CharacterViewportFrame:GetChildren()) do
		if child:IsA("Camera") or child:IsA("Model") then child:Destroy() end
	end
	
	local character = game.Players.LocalPlayer.Character
	character.Archivable = true
	local characterModel = character:Clone()
	characterModel.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	characterModel.Name = "Character"
	
	local camera = Instance.new("Camera")
	camera.Parent = frame.CharacterViewportFrame
	frame.CharacterViewportFrame.CurrentCamera = camera
	
	camera.CFrame = CFrame.new(characterModel.PrimaryPart.Position + characterModel.PrimaryPart.CFrame.LookVector * 5, characterModel.PrimaryPart.Position)
	
	characterModel.Parent = frame.CharacterViewportFrame
	
	button.Visible = false
	frame.Visible = true
	
	local blur = Instance.new("BlurEffect")
	blur.Name = "CharacterCreatorBlur"
	blur.Parent = game.Lighting
end)

frame.ConfirmTextButton.MouseButton1Click:Connect(function()
	
	re:FireServer(currentItems)
	
	frame.Visible = false
	button.Visible = true
	
	if game.Lighting:FindFirstChild("CharacterCreatorBlur") then
		game.Lighting.CharacterCreatorBlur:Destroy()
	end
end)


--Setup character creator GUI
local function setupGui()
	
	for i, child in pairs(frame.CategoriesScrollingFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	for x, category in pairs(items:GetChildren()) do
		
		local categoryName = category.Name
		
		local newCategoryButton = script.ItemCategoryButton:Clone()
		newCategoryButton.Text = categoryName
		
		newCategoryButton.MouseButton1Click:Connect(function()
			
			for y, child in pairs(frame.ItemsScrollingFrame:GetChildren()) do
				if child:IsA("TextButton") then child:Destroy() end
			end
			
			local debounce = false
			
			for z, item in pairs(category:GetChildren()) do
				local itemType = item:FindFirstChildOfClass("Shirt") or item:FindFirstChildOfClass("Pants") or item
				local itemName = itemType.Name
				
				local newItemButton = script.ItemButton:Clone()
				newItemButton.Name = itemName
				newItemButton.ItemName.Text = itemName
				newItemButton.UIStroke.Enabled = false
				if table.find(currentItems, itemType.Name) then newItemButton.UIStroke.Enabled = true end
				
				local camera = Instance.new("Camera")
				camera.Parent = newItemButton.ItemViewportFrame
				newItemButton.ItemViewportFrame.CurrentCamera = camera
				
				local itemModel = item:Clone()
				local itemMainPart = itemModel:FindFirstChild("Handle") or itemModel.PrimaryPart
				
				if itemModel:FindFirstChild("Humanoid") then
					itemModel.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
				end
				
				local distance = 6				
				if itemMainPart.Name == "Handle" then distance = 2 end
				camera.CFrame = CFrame.new(itemMainPart.Position + itemMainPart.CFrame.LookVector * distance, itemMainPart.Position)
				
				newItemButton.MouseButton1Click:Connect(function()
					
					if frame.CharacterViewportFrame:FindFirstChild("Character") and not debounce then
						debounce = true
						if not table.find(currentItems, itemType.Name) then
							table.insert(currentItems, itemType.Name)
							
							newItemButton.UIStroke.Enabled = true
							
							local itemToApply = itemType:Clone()
							
							if itemType:IsA("Shirt") then
								
								if frame.CharacterViewportFrame.Character:FindFirstChildOfClass("Shirt") then
									for i, item in pairs(currentItems) do
										if items:FindFirstChild(item, true) and items:FindFirstChild(item, true):IsA("Shirt") then
											table.remove(currentItems, i)
										end
									end
									if frame.ItemsScrollingFrame:FindFirstChild(frame.CharacterViewportFrame.Character:FindFirstChildOfClass("Shirt").Name) then
										frame.ItemsScrollingFrame:FindFirstChild(frame.CharacterViewportFrame.Character:FindFirstChildOfClass("Shirt").Name).UIStroke.Enabled = false
									end
									for i, child in pairs(frame.CharacterViewportFrame.Character:GetChildren()) do
										if child:IsA("Shirt") then child:Destroy() end
									end
								end
								itemToApply.Parent = frame.CharacterViewportFrame.Character
								
							elseif itemType:IsA("Pants") then
								
								if frame.CharacterViewportFrame.Character:FindFirstChildOfClass("Pants") then
									for i, item in pairs(currentItems) do
										if items:FindFirstChild(item, true) and items:FindFirstChild(item, true):IsA("Pants") then
											table.remove(currentItems, i)
										end
									end
									if frame.ItemsScrollingFrame:FindFirstChild(frame.CharacterViewportFrame.Character:FindFirstChildOfClass("Pants").Name) then
										frame.ItemsScrollingFrame:FindFirstChild(frame.CharacterViewportFrame.Character:FindFirstChildOfClass("Pants").Name).UIStroke.Enabled = false
									end
									for i, child in pairs(frame.CharacterViewportFrame.Character:GetChildren()) do
										if child:IsA("Pants") then child:Destroy() end
									end
								end
								itemToApply.Parent = frame.CharacterViewportFrame.Character
								
							elseif itemType:IsA("Accessory") then
								
								local c = frame.CharacterViewportFrame.Character
								c.Parent = workspace
								
								itemToApply.Parent = c
								local a1 = itemToApply.Handle:FindFirstChildOfClass("Attachment")
								local a0 = c.Head[a1.Name]
								
								local weld = Instance.new("Weld")
								weld.Part0 = a0.Parent
								weld.Part1 = a1.Parent
								weld.C0 = a0.CFrame
								weld.C1 = a1.CFrame
								weld.Parent = a0.Parent
								
								local po = itemToApply.Handle.Position - c.Head.Position
								local ro = itemToApply.Handle.Orientation - c.Head.Orientation
								
								c.Parent = frame.CharacterViewportFrame
								itemToApply.Parent = c
								local atch = itemToApply.Handle:FindFirstChildOfClass("Attachment")
								itemToApply.Handle.CFrame = c.Head.CFrame * CFrame.new(po) * CFrame.Angles(math.rad(ro.Z), math.rad(ro.Y), math.rad(ro.X))
							end
							
						else
							table.remove(currentItems, table.find(currentItems, itemType.Name))
							
							newItemButton.UIStroke.Enabled = false
							frame.CharacterViewportFrame.Character[itemName]:Destroy()
						end
					end
					wait(1)
					debounce = false
				end)
				
				itemModel.Parent = newItemButton.ItemViewportFrame
				
				newItemButton.Parent = frame.ItemsScrollingFrame
				newItemButton.Size = UDim2.new(0, newItemButton.AbsoluteSize.X, 0, newItemButton.AbsoluteSize.Y)
				frame.ItemsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, frame.ItemsScrollingFrame.UIGridLayout.AbsoluteContentSize.Y)
			end
		end)
		
		newCategoryButton.Parent = frame.CategoriesScrollingFrame
		newCategoryButton.Size = UDim2.new(0, newCategoryButton.AbsoluteSize.X, 0, newCategoryButton.AbsoluteSize.Y)
		frame.CategoriesScrollingFrame.CanvasSize = UDim2.new(0, frame.CategoriesScrollingFrame.UIListLayout.AbsoluteContentSize.X, 0, 0)
	end
end

setupGui()
items.DescendantAdded:Connect(setupGui)