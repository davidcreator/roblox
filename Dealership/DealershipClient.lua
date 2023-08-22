--Open and close GUI
local frame = script.Parent
frame.Visible = false

local promptTriggered = nil

frame.CloseButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	promptTriggered.Enabled = true
end)

game.ReplicatedStorage.CarsRE.OnClientEvent:Connect(function(prompt)
	frame.Visible = true
	promptTriggered = prompt
	promptTriggered.Enabled = false
end)


--Scrolling frame set up
frame.CarPreviewFrame.Visible = false

function setupScrollingFrame(folder)
	
	for i, button in pairs(frame.CarsScrollingFrame:GetChildren()) do
		if button:IsA("TextButton") then
			button:Destroy()
		end
	end
	
	local cars = folder:GetChildren()
	table.sort(cars, function(a, b)
		return a.PRICE.Value < b.PRICE.Value
	end)
	
	for i, car in pairs(cars) do
		
		local newBtn = script.CarButton:Clone()
		newBtn.CarNameLabel.Text = car.Name
		
		local carModel = car:Clone()
		carModel.Parent = newBtn.CarViewportFrame
		
		for x, desc in pairs(carModel:GetDescendants()) do
			if desc:IsA("Seat") or desc:IsA("Script") or desc:IsA("VehicleSeat") or desc:IsA("LocalScript") or desc:IsA("ScreenGui") or desc:IsA("ModuleScript") then
				desc:Destroy()
			end
		end
		
		local camera = Instance.new("Camera")
		newBtn.CarViewportFrame.CurrentCamera = camera
		camera.Parent = newBtn.CarViewportFrame
		
		camera.CFrame = carModel.CameraPosition.CFrame
		
		newBtn.Parent = frame.CarsScrollingFrame
		
		if i == 1 then
			frame.CarsScrollingFrame.UIGridLayout.CellSize = UDim2.new(0, newBtn.AbsoluteSize.X, 0, newBtn.AbsoluteSize.Y)
		end
		
		newBtn.MouseButton1Click:Connect(function()
			
			frame.CarPreviewFrame.CarNameLabel.Text = car.Name
			
			local price = car.PRICE.Value
			local formatted = price
			while true do  
				formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
				if k == 0 then
					break
				end
			end
			frame.CarPreviewFrame.CarPriceLabel.Text = "$" .. formatted
			
			frame.CarPreviewFrame.CarViewportFrame:ClearAllChildren()
			local carModel2 = carModel:Clone()
			local camera2 = camera:Clone()
			frame.CarPreviewFrame.CarViewportFrame.CurrentCamera = camera2
			carModel2.Parent = frame.CarPreviewFrame.CarViewportFrame
			camera2.Parent = frame.CarPreviewFrame.CarViewportFrame
			
			if folder.Parent == game.Players.LocalPlayer then
				frame.CarPreviewFrame.CarButton.Text = "SPAWN"
			else
				frame.CarPreviewFrame.CarButton.Text = "BUY"
			end
			
			frame.CarPreviewFrame.Visible = true
		end)
		
		frame.CarsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, frame.CarsScrollingFrame.UIGridLayout.AbsoluteContentSize.Y)
	end
end
setupScrollingFrame(game.ReplicatedStorage.Cars)


--Car buttons
frame.CarShopButton.BackgroundColor3 = Color3.fromRGB(142, 41, 214)
frame.OwnedCarsButton.BackgroundColor3 = Color3.fromRGB(142, 110, 145)

frame.CarShopButton.MouseButton1Click:Connect(function()
	frame.CarShopButton.BackgroundColor3 = Color3.fromRGB(142, 41, 214)
	frame.OwnedCarsButton.BackgroundColor3 = Color3.fromRGB(142, 110, 145)
	setupScrollingFrame(game.ReplicatedStorage.Cars)
end)

frame.OwnedCarsButton.MouseButton1Click:Connect(function()
	frame.OwnedCarsButton.BackgroundColor3 = Color3.fromRGB(142, 41, 214)
	frame.CarShopButton.BackgroundColor3 = Color3.fromRGB(142, 110, 145)
	setupScrollingFrame(game.Players.LocalPlayer.Cars)
end)

frame.CarPreviewFrame.CarButton.MouseButton1Click:Connect(function()
	game.ReplicatedStorage.CarsRE:FireServer(frame.CarPreviewFrame.CarButton.Text, frame.CarPreviewFrame.CarNameLabel.Text, promptTriggered and promptTriggered.Parent.Parent or nil)
end)