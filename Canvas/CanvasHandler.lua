local gui = script.Parent


local canvas = gui.Canvas


local brushButton = gui.Brush

local eraserButton = gui.Eraser


local clearButtton = gui.ClearCanvas


local brushSize = gui.BrushSizeInput

local sizeConfirm = gui.ConfirmBrushSize

local size = 10


local brushColour = gui.BrushColourInput

local colourConfirm = gui.ConfirmBrushColour

local colour = Color3.fromRGB(0, 0, 0)


local isEraser = false


local paint = game.ReplicatedStorage.Paint


local plr = game.Players.LocalPlayer

local mouse = plr:GetMouse()


local isMouseDown = false



canvas.MouseMoved:Connect(function(xPos, yPos)
	
	
	if isMouseDown then
		
		
		if isEraser == false then
		
			local paintCloned = paint:Clone()
			
			
			local offset = Vector2.new(math.abs(xPos - canvas.AbsolutePosition.X), math.abs(yPos - canvas.AbsolutePosition.Y - 36))
			
			
			paintCloned.Size = UDim2.new(0, size, 0, size)
			paintCloned.Position = UDim2.new(0, offset.X, 0, offset.Y)
			
			paintCloned.ImageColor3 = colour
			
			paintCloned.Parent = canvas
			
			
		else			
			
			local guisAtPos = plr.PlayerGui:GetGuiObjectsAtPosition(xPos, yPos - 36)
			
			
			for i, paintToErase in pairs(guisAtPos) do
				
				
				if paintToErase.Name == "Paint" then paintToErase:Destroy() end
				
			end		
		end		
	end	
end)


game:GetService("UserInputService").InputBegan:Connect(function(input)
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		
		
		isMouseDown = true
	end	
end)


game:GetService("UserInputService").InputEnded:Connect(function(input)
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		
		
		isMouseDown = false
	end	
end)


eraserButton.MouseButton1Down:Connect(function()
	
	
	isEraser = true	
end)


brushButton.MouseButton1Down:Connect(function()
	
	
	isEraser = false	
end)


clearButtton.MouseButton1Down:Connect(function()
	
	
	
	for i, paintToClear in pairs(canvas:GetChildren()) do
		
		
		paintToClear:Destroy()		
	end
end)



sizeConfirm.MouseButton1Down:Connect(function()
	
	
	if not tonumber(brushSize.Text) then return end
	
	
	size = math.clamp(tonumber(brushSize.Text), 1, 100)
	
end)


colourConfirm.MouseButton1Down:Connect(function()
	
	
	local hexColour = brushColour.Text
	
	
	if string.len(hexColour) < 6 then return end
	
	
	hexColour = string.gsub(hexColour, "#", "")
	hexColour = string.gsub(hexColour, "0x", "", 1)
	
	local r = tonumber("0x" .. hexColour:sub(1, 2))
	local g = tonumber("0x" .. hexColour:sub(3, 4))
	local b = tonumber("0x" .. hexColour:sub(5, 6))
	
	
	colour = Color3.fromRGB(r, g, b)
end)