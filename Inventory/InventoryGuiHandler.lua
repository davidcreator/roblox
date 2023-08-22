local button = script.Parent
button.Position = UDim2.new(0.032, 0, 0.5, 0)

local open = false


button.MouseButton1Click:Connect(function()
	
	open = not open
	
	local newPos = open and UDim2.new(0.319, 0, 0.5, 0) or UDim2.new(0.032, 0, 0.5, 0)
		
	button:TweenPosition(newPos, "InOut", "Quint", 0.5)
end)


local inventoryFolder = game.Players.LocalPlayer:WaitForChild("Inventory")


function updateInv()
	
	for i, child in pairs(script.Parent.InventoryScroller:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	for i, item in pairs(inventoryFolder:GetChildren()) do
		
		if item.Value > 0 then
		
			local newButton = script.ItemButton:Clone()
			newButton.ItemName.Text = item.Name
			newButton.Count.Text = item.Value
			
			local cam = Instance.new("Camera", newButton.ItemFrame)
			newButton.ItemFrame.CurrentCamera = cam
			
			local displayItem = game.ReplicatedStorage.Items[item.Name]:Clone()
			displayItem.Parent = newButton.ItemFrame
			
			cam.CFrame = CFrame.new(displayItem.Position + displayItem.CFrame.LookVector * 4, displayItem.Position)
			
			
			newButton.MouseButton1Click:Connect(function()
				
				game.ReplicatedStorage.InventoryRE:FireServer("drop", item.Name)
			end)
		
			newButton.Parent = script.Parent.InventoryScroller
		end
	end
	
	script.Parent.InventoryScroller.CanvasSize = UDim2.new(0, 0, 0, script.Parent.InventoryScroller.UIGridLayout.AbsoluteContentSize.Y)
end

updateInv()

for i, item in pairs(inventoryFolder:GetChildren()) do
	item.Changed:Connect(updateInv)
end