game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)


local re = game.ReplicatedStorage:WaitForChild("MessageSentRE")

local folder = game.ReplicatedStorage:WaitForChild("MessageFolder")


local scroller = script.Parent.MessageScroller


local ts = game:GetService("TweenService")
local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)


local maxMsgs = 200

local messages = {}



folder.ChildAdded:Connect(function(child)
	
	
	local textLabel = script.MessageTemplate:Clone()
	
	textLabel.Text = child.Value
	
	textLabel.TextTransparency = 1
	textLabel.BackgroundTransparency = 1
	
	textLabel.Parent = scroller
	
	ts:Create(textLabel, ti, {TextTransparency = 0, BackgroundTransparency = 0}):Play()
	
	
	table.insert(messages, {child.Value, textLabel})
	
	
	if #messages > maxMsgs then
		
		messages[1][2]:Destroy()
		table.remove(messages, 1)
	end
	
	scroller.CanvasSize = UDim2.new(0, 0, 0, scroller.UIListLayout.AbsoluteContentSize.Y)
	
	scroller.CanvasPosition = Vector2.new(0, 9999)
end)


script.Parent.ChatInput.FocusLost:Connect(function(enterPressed)
	
	if not enterPressed then return end
	
	re:FireServer(script.Parent.ChatInput.Text)
	
	script.Parent.ChatInput.Text = ""
end)


game:GetService("UserInputService").InputBegan:Connect(function(inp, gameProcessed)
	
	if gameProcessed then return end
	
	if inp.KeyCode == Enum.KeyCode.Slash then
		
		wait()
		script.Parent.ChatInput:CaptureFocus()
	end
end)