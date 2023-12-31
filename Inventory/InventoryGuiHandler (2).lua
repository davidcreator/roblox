game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

local keys = {
	[1] = Enum.KeyCode.One;
	[2] = Enum.KeyCode.Two;
	[3] = Enum.KeyCode.Three;
	[4] = Enum.KeyCode.Four;
	[5] = Enum.KeyCode.Five;
	[6] = Enum.KeyCode.Six;
	[7] = Enum.KeyCode.Seven;
	[8] = Enum.KeyCode.Eight;
	[9] = Enum.KeyCode.Nine;
}

local uis = game:GetService("UserInputService")

local rs = game:GetService("ReplicatedStorage"):WaitForChild("InventoryReplicatedStorage")
local remotes = rs:WaitForChild("RemoteEvents")

local client = game.Players.LocalPlayer

local hotbar = client:WaitForChild("Hotbar")
local inventory = client:WaitForChild("Inventory")
local equipped = client:WaitForChild("Equipped")

local hotbarGui = script.Parent:WaitForChild("Hotbar"):WaitForChild("SlotsContainer")
local invGui = script.Parent:WaitForChild("Inventory")
invGui.Visible = false
local openInv = script.Parent:WaitForChild("OpenInventory")


function updateHotbar()

	for slotNum, slotVal in pairs(hotbar:GetChildren()) do

		local guiSlot = hotbarGui[slotNum]

		if slotVal.Value then
			guiSlot.ItemName.Visible = true
			guiSlot.ItemName.Text = slotVal.Value.Name

			if string.len(slotVal.Value.TextureId) > 0 then
				guiSlot.ItemViewer.Visible = false
				guiSlot.ItemImage.Visible = true
				
				guiSlot.ItemImage.Image = slotVal.Value.TextureId
			else
				guiSlot.ItemViewer.Visible = true
				guiSlot.ItemImage.Visible = false
				
				guiSlot.ItemViewer:ClearAllChildren()

				local vpfModel = Instance.new("Model")

				local copiedTool = slotVal.Value:Clone()
				for __, desc in pairs(copiedTool:GetDescendants()) do
					if desc:IsA("LocalScript") or desc:IsA("Script") then
						desc:Destroy()
					elseif desc:IsA("BasePart") then
						desc.Parent = vpfModel
					end
				end
				copiedTool:Destroy()

				local cf, size = vpfModel:GetBoundingBox()

				local primaryPart = Instance.new("Part")
				primaryPart.Transparency = 1
				primaryPart.CFrame = cf
				primaryPart.Parent = vpfModel

				vpfModel.PrimaryPart = primaryPart

				vpfModel:PivotTo(CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, math.rad(90), math.rad(90))))

				local itemPivot = vpfModel:GetPivot()
				local itemSize = vpfModel:GetExtentsSize()

				local vpfCam = Instance.new("Camera")
				vpfCam.CFrame = CFrame.new(itemPivot.Position + (Vector3.one * itemSize * 0.5), itemPivot.Position)
				guiSlot.ItemViewer.CurrentCamera = vpfCam

				vpfCam.Parent = guiSlot.ItemViewer
				vpfModel.Parent = guiSlot.ItemViewer
			end
			
		else
			guiSlot.ItemName.Visible = false
			guiSlot.ItemImage.Visible = false
			guiSlot.ItemViewer.Visible = false
		end
	end
end

function updateInventory()
	
	for _, invItem in pairs(invGui.InventoryScroller:GetChildren()) do
		if invItem:IsA(script.InventoryItem.ClassName) then
			invItem:Destroy()
		end
	end
	
	for _, toolVal in pairs(inventory:GetChildren()) do
		
		local tool = toolVal.Value
		
		local newItem = script.InventoryItem:Clone()
		newItem.ItemName.Text = tool.Name
		
		if string.len(tool.TextureId) > 0 then
			newItem.ItemViewer.Visible = false
			newItem.ItemImage.Image = tool.TextureId
		else
			newItem.ItemImage.Visible = false
			
			newItem.ItemViewer:ClearAllChildren()

			local vpfModel = Instance.new("Model")

			local copiedTool = tool:Clone()
			for __, desc in pairs(copiedTool:GetDescendants()) do
				if desc:IsA("LocalScript") or desc:IsA("Script") then
					desc:Destroy()
				elseif desc:IsA("BasePart") then
					desc.Parent = vpfModel
				end
			end
			copiedTool:Destroy()

			local cf, size = vpfModel:GetBoundingBox()

			local primaryPart = Instance.new("Part")
			primaryPart.Transparency = 1
			primaryPart.CFrame = cf
			primaryPart.Parent = vpfModel

			vpfModel.PrimaryPart = primaryPart

			vpfModel:PivotTo(CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, math.rad(90), math.rad(90))))

			local itemPivot = vpfModel:GetPivot()
			local itemSize = vpfModel:GetExtentsSize()

			local vpfCam = Instance.new("Camera")
			vpfCam.CFrame = CFrame.new(itemPivot.Position + (Vector3.one * itemSize * 0.5), itemPivot.Position)
			newItem.ItemViewer.CurrentCamera = vpfCam
			
			vpfCam.Parent = newItem.ItemViewer
			vpfModel.Parent = newItem.ItemViewer
		end
		
		newItem.MouseButton1Click:Connect(function()
			remotes.ToHotbar:FireServer(tool)
		end)
		
		newItem.MouseButton2Click:Connect(function()
			remotes.Drop:FireServer(tool)
		end)
		
		newItem.Parent = invGui.InventoryScroller
	end
end

function findSelectedSlot()
	
	for slotNum, slotVal in pairs(hotbar:GetChildren()) do
		
		local guiSlot = hotbarGui[slotNum]
		
		if slotVal.Value and slotVal.Value == equipped.Value then
			guiSlot.ImageColor3 = Color3.fromRGB(255, 255, 255)
		else
			guiSlot.ImageColor3 = Color3.fromRGB(218, 218, 218)
		end
	end
end


for slotNum, slotVal in pairs(hotbar:GetChildren()) do
	
	local newSlot = script:WaitForChild("HotbarItem"):Clone()
	newSlot.Name = slotNum
	
	if keys[slotNum].Value >= 48 and keys[slotNum].Value <= 57 then
		newSlot.NumberKey.Text = keys[slotNum].Value - 48
	else
		newSlot.NumberKey.Text = string.split(tostring(keys[slotNum]), ".")[3]
	end
	
	if slotVal.Value then
		newSlot.ItemName.Text = slotVal.Value.Name
		
		if string.len(slotVal.Value.TextureId) > 0 then
			newSlot.ItemViewer.Visible = false
			newSlot.ItemImage.Image = slotVal.Value.TextureId
		else
			newSlot.ItemImage.Visible = false
			
			newSlot.ItemViewer:ClearAllChildren()

			local vpfModel = Instance.new("Model")

			local copiedTool = slotVal.Value:Clone()
			for __, desc in pairs(copiedTool:GetDescendants()) do
				if desc:IsA("LocalScript") or desc:IsA("Script") then
					desc:Destroy()
				elseif desc:IsA("BasePart") then
					desc.Parent = vpfModel
				end
			end
			copiedTool:Destroy()
			
			local cf, size = vpfModel:GetBoundingBox()
			
			local primaryPart = Instance.new("Part")
			primaryPart.Transparency = 1
			primaryPart.CFrame = cf
			primaryPart.Parent = vpfModel
			
			vpfModel.PrimaryPart = primaryPart
			
			vpfModel:PivotTo(CFrame.new(Vector3.new(0, 0, 0), Vector3.new(0, math.rad(90), math.rad(90))))
			
			local itemPivot = vpfModel:GetPivot()
			local itemSize = vpfModel:GetExtentsSize()
			
			local vpfCam = Instance.new("Camera")
			vpfCam.CFrame = CFrame.new(itemPivot.Position + (Vector3.one * itemSize * 0.5), itemPivot.Position)
			newSlot.ItemViewer.CurrentCamera = vpfCam
			
			vpfCam.Parent = newSlot.ItemViewer
			
			vpfModel.Parent = newSlot.ItemViewer
		end
		
	else
		newSlot.ItemName.Visible = false
		newSlot.ItemImage.Visible = false
		newSlot.ItemViewer.Visible = false
	end
	
	newSlot.MouseButton1Click:Connect(function()
		local tool = slotVal.Value
		remotes.Equip:FireServer(tool)
	end)
	
	newSlot.MouseButton2Click:Connect(function()
		local tool = slotVal.Value
		remotes.ToInventory:FireServer(tool)
	end)
	
	newSlot.Parent = hotbarGui
	
	slotVal:GetPropertyChangedSignal("Value"):Connect(updateHotbar)
end


updateInventory()
inventory.ChildAdded:Connect(updateInventory)
inventory.ChildRemoved:Connect(updateInventory)


findSelectedSlot()
equipped:GetPropertyChangedSignal("Value"):Connect(findSelectedSlot)


uis.InputBegan:Connect(function(inp, p)
	
	if p then return end
	
	if table.find(keys, inp.KeyCode) then
		
		local slotVal = hotbar[table.find(keys, inp.KeyCode)]
		local tool = slotVal.Value
		remotes.Equip:FireServer(tool)
	end
end)


openInv.MouseButton1Click:Connect(function()
	invGui.Visible = not invGui.Visible
end)