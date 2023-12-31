local sounds = script.Parent:WaitForChild("Sounds")

local resourcesOpen = script.Parent:WaitForChild("ResourcesOpenButton")
local craftingOpen = script.Parent:WaitForChild("CraftingOpenButton")

local resourcesFrame = script.Parent:WaitForChild("ResourcesFrame")
local craftingFrame = script.Parent:WaitForChild("CraftingFrame")
resourcesFrame.Visible, craftingFrame.Visible = false, false
craftingFrame.CraftingContainer.Visible = false

function positionUI()
	if resourcesFrame.Visible == true then
		craftingFrame.Position = UDim2.new(0.34, 0, 0.5, 0)
	else
		craftingFrame.Position = UDim2.new(0.2, 0, 0.5, 0)
	end
end

resourcesOpen.MouseButton1Click:Connect(function()
	resourcesFrame.Visible = not resourcesFrame.Visible
	positionUI()
end)
craftingOpen.MouseButton1Click:Connect(function()
	craftingFrame.Visible = not craftingFrame.Visible
	positionUI()
end)

local resourcesClose = resourcesFrame:WaitForChild("CloseButton")
local craftingClose = craftingFrame:WaitForChild("CloseButton")

resourcesClose.MouseButton1Click:Connect(function()
	resourcesFrame.Visible = false
	positionUI()
end)
craftingClose.MouseButton1Click:Connect(function()
	craftingFrame.Visible = false
	craftingFrame.CraftingContainer.Visible = false
end)


local rs = game:GetService("ReplicatedStorage"):WaitForChild("CraftingReplicatedStorage")
local items = rs:WaitForChild("CraftableItems")
local allResources = rs:WaitForChild("Resources")
local remote = rs:WaitForChild("RemoteEvent")
local recipes = require(rs:WaitForChild("Recipes"))


local plrResources = game.Players.LocalPlayer:WaitForChild("RESOURCES")

function displayResources()
	
	for _, child in pairs(resourcesFrame:WaitForChild("ResourcesScrollingFrameBackground"):WaitForChild("ResourcesScrollingFrame"):GetChildren()) do
		if child:IsA("Frame") or child:IsA("ImageLabel") or child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	
	local newFrames = {}
	
	for _, resourceValue in pairs(plrResources:GetChildren()) do
		local resourceName = resourceValue.Name
		local resourceAmount = resourceValue.Value
		
		if resourceAmount > 0 then
			
			local newFrame = script:WaitForChild("ResourceInResourcesFrame"):Clone()
			newFrame.ResourceName.Text = resourceName
			newFrame.ResourceAmount.Text = "x" .. resourceAmount
			
			local resourceModel = allResources[resourceName]:Clone()
			resourceModel.CFrame = CFrame.new()
			resourceModel.Parent = newFrame.ResourceView
			
			local vpfCamera = Instance.new("Camera")
			vpfCamera.CFrame = CFrame.new(resourceModel.Position + Vector3.new(1, 1, 1), resourceModel.Position)
			newFrame.ResourceView.CurrentCamera = vpfCamera
			vpfCamera.Parent = newFrame.ResourceView
			
			table.insert(newFrames, newFrame)
		end
	end
	
	table.sort(newFrames, function(a, b)
		return a.ResourceName.Text < b.ResourceName.Text
	end)
	
	for _, frame in pairs(newFrames) do
		frame.Parent = resourcesFrame.ResourcesScrollingFrameBackground.ResourcesScrollingFrame
	end
end

displayResources()
for _, resource in pairs(plrResources:GetChildren()) do
	resource.Changed:Connect(displayResources)
end
plrResources.ChildAdded:Connect(function(resource)
	displayResources()
	resource.Changed:Connect(displayResources)
end)


function displayRecipes()
	
	for _, child in pairs(craftingFrame:WaitForChild("RecipesContainer"):WaitForChild("RecipesScrollingFrameBackground"):WaitForChild("RecipesScrollingFrame"):GetChildren()) do
		if child:IsA("Frame") or child:IsA("ImageLabel") or child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	
	local recipeFrames = {}
	
	for item, recipe in pairs(recipes) do
		local recipeFrame = script:WaitForChild("CraftableItem"):Clone()
		recipeFrame.ItemName.Text = item.Name
		
		local itemModel = Instance.new("Model")
		local clonedItem = item:Clone()
		for _, d in pairs(clonedItem:GetDescendants()) do
			if d:IsA("LocalScript") or d:IsA("Script") or d:IsA("ModuleScript") or d:IsA("Sound") then
				d:Destroy()
			end
		end
		for _, c in pairs(clonedItem:GetChildren()) do
			c.Parent = itemModel
		end
		clonedItem:Destroy()
		itemModel.PrimaryPart = itemModel:FindFirstChild("Handle") or itemModel:FindFirstChildWhichIsA("BasePart", true)
		itemModel:PivotTo(CFrame.new())
		itemModel.Parent = recipeFrame.ItemView
		
		local itemPivot = itemModel:GetPivot()
		local itemSize = itemModel:GetExtentsSize()
		
		local vpfCamera = Instance.new("Camera")
		vpfCamera.CFrame = CFrame.new(itemPivot.Position + (Vector3.new(1, 1, 1) * itemSize * 0.8), itemPivot.Position)
		recipeFrame.ItemView.CurrentCamera = vpfCamera
		vpfCamera.Parent = recipeFrame.ItemView
		
		local recipeCost = 0
		for resource, amount in pairs(recipe) do
			recipeCost += amount
		end
		
		recipeFrame.MouseButton1Click:Connect(function()
			if item.Name ~= craftingFrame.CraftingContainer.ItemFrame.ItemName.Text or craftingFrame.CraftingContainer.Visible == false then
				
				for _, child in pairs(craftingFrame.CraftingContainer.ResourcesScrollingFrame:GetChildren()) do
					if child:IsA("Frame") or child:IsA("ImageLabel") or child:IsA("TextLabel") then
						child:Destroy()
					end
				end
				
				local resourceFrames = {}
				for resource, amount in pairs(recipe) do
					local resourceFrame = script:WaitForChild("ResourceInCraftingFrame"):Clone()
					resourceFrame.ResourceName.Text = resource
					resourceFrame.ResourceAmount.Text = "x" .. amount
					
					local resourceModel = allResources[resource]:Clone()
					resourceModel.CFrame = CFrame.new()
					resourceModel.Parent = resourceFrame.ResourceView

					local vpfCamera = Instance.new("Camera")
					vpfCamera.CFrame = CFrame.new(resourceModel.Position + Vector3.new(1, 1, 1), resourceModel.Position)
					resourceFrame.ResourceView.CurrentCamera = vpfCamera
					vpfCamera.Parent = resourceFrame.ResourceView
					
					local plrResourceAmount = plrResources[resource].Value
					if plrResourceAmount < amount then
						local h, s, v = resourceFrame.BackgroundColor3:ToHSV()
						resourceFrame.BackgroundColor3 = Color3.fromHSV(h, s + 0.03, v - 0.2)
						
						craftingFrame.CraftingContainer.CraftButton.ImageColor3 = Color3.fromRGB(159, 159, 159)
						craftingFrame.CraftingContainer.CraftButton.Active = false
					else
						craftingFrame.CraftingContainer.CraftButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
						craftingFrame.CraftingContainer.CraftButton.Active = true
					end
					
					table.insert(resourceFrames, {resourceFrame, plrResourceAmount >= amount})
				end
				
				table.sort(resourceFrames, function(a, b)
					local aAmount = a[1].ResourceAmount.Text
					local bAmount = b[1].ResourceAmount.Text
					aAmount, bAmount = string.gsub(aAmount, "x", ""), string.gsub(bAmount, "x", "")
					aAmount, bAmount = tonumber(aAmount), tonumber(bAmount)
					return (aAmount > bAmount) and (a[2] or not b[2])
				end)
				for _, resourceFrame in pairs(resourceFrames) do
					resourceFrame[1].Parent = craftingFrame.CraftingContainer.ResourcesScrollingFrame
				end
				
				craftingFrame.CraftingContainer.ItemFrame.ItemName.Text = item.Name
				if craftingFrame.CraftingContainer.ItemFrame:FindFirstChild("ItemView") then
					craftingFrame.CraftingContainer.ItemFrame.ItemView:Destroy()
				end
				local vpf = recipeFrame.ItemView:Clone()
				vpf.Size = UDim2.new(1, 0, 1, 0)
				vpf.Position = UDim2.new(vpf.AnchorPoint.X, 0, vpf.AnchorPoint.Y, 0)
				vpf.Parent = craftingFrame.CraftingContainer.ItemFrame
				
				craftingFrame.CraftingContainer.Visible = true
			end
		end)
		
		table.insert(recipeFrames, {recipeFrame, recipeCost})
	end
	
	table.sort(recipeFrames, function(a, b)
		return a[2] < b[2]
	end)
	for _, recipeFrame in pairs(recipeFrames) do
		recipeFrame[1].Parent = craftingFrame.RecipesContainer.RecipesScrollingFrameBackground.RecipesScrollingFrame
	end
end

displayRecipes()


function sendCraftRequest()
	local itemToCraft = craftingFrame.CraftingContainer.ItemFrame.ItemName.Text
	if recipes[items[itemToCraft]] then
		remote:FireServer(itemToCraft)
	end
end
craftingFrame.CraftingContainer.CraftButton.MouseButton1Click:Connect(sendCraftRequest)


remote.OnClientEvent:Connect(function(msg)
	if msg == "CRAFT SUCCESS" then
		sounds.Crafted:Play()
		craftingFrame.CraftingContainer.Visible = false
	end
end)



--Animations and sound effects
local ts = game:GetService("TweenService")
local ti = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut)


function buttonEffect(button:TextButton|ImageButton)
	
	local originalSize = button.Size
	local hoverSize = UDim2.new(originalSize.X.Scale * 1.02, 0, originalSize.Y.Scale * 1.02, 0)
	local clickSize = UDim2.new(originalSize.X.Scale * 0.98, 0, originalSize.Y.Scale * 0.98, 0)
	
	local colourProperty = button:IsA("TextButton") and "BackgroundColor3" or button:IsA("ImageButton") and "ImageColor3"
	local originalColour = button[colourProperty]
	local h, s, v = originalColour:ToHSV()
	local hoverColour = Color3.fromHSV(h, s + 0.03, v - 0.1)
	local clickColour = Color3.fromHSV(h, s + 0.035, v - 0.15)
	
	local scaleUpTween = ts:Create(button, ti, {Size = hoverSize, [colourProperty] =  hoverColour})
	local scaleDownTween = ts:Create(button, ti, {Size = clickSize, [colourProperty] = clickColour})
	local resetTween = ts:Create(button, ti, {Size = originalSize, [colourProperty] = originalColour})
	
	button.MouseEnter:Connect(function()
		if button.Active then
			sounds.Hover:Play()
			scaleUpTween:Play()
		end
	end)
	button.MouseLeave:Connect(function()
		if button.Active then
			resetTween:Play()
		end
	end)
	button.MouseButton1Down:Connect(function()
		if button.Active then
			scaleDownTween:Play()
		end
	end)
	button.MouseButton1Up:Connect(function()
		if button.Active then
			sounds.Click:Play()
			scaleUpTween:Play()
		end
	end)
end


script.Parent.DescendantAdded:Connect(function(desc)
	if desc:IsA("TextButton") or desc:IsA("ImageButton") then
		buttonEffect(desc)
	end
end)

for _, desc in pairs(script.Parent:GetDescendants()) do
	if desc:IsA("TextButton") or desc:IsA("ImageButton") then
		buttonEffect(desc)
	end
end