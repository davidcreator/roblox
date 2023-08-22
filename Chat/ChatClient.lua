game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)


local chatInput = script.Parent:WaitForChild("ChatInput")


local uis = game:GetService("UserInputService")


local onChatInputted = game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ChatEvent")


local cooldown = 1

local isCoolingDown = false
local isChatting = false


local msgsContainer = game.ReplicatedStorage:WaitForChild("Containers"):WaitForChild("ChatMessageContainer")
local messageFrame = script.Parent:WaitForChild("ChatMessageFrame")


local defaultSize

game:GetService("RunService").RenderStepped:Connect(function()

	messageFrame:ClearAllChildren()
	Instance.new("UIListLayout", messageFrame)

	for i, messageValue in pairs(msgsContainer:GetChildren()) do
		
		messageValue = messageValue:Clone()
		
		if messageValue:IsA("TextLabel") then
			
			messageValue.Size = defaultSize or UDim2.new(1, 0, messageFrame.Size.Y.Scale/5, 0)

			messageValue.Parent = messageFrame


			messageFrame.CanvasSize = UDim2.new(0, 0, #msgsContainer:GetChildren()/10, 0)
			
			if i == 1 then defaultSize = UDim2.new(0, messageValue.AbsoluteSize.X, 0, messageValue.AbsoluteSize.Y) end

		end
	end
end)


uis.InputBegan:Connect(function(key, gameProcessed)

	if key.KeyCode == Enum.KeyCode.Slash and not gameProcessed then	
		
		isChatting = true
		
		wait()
		chatInput:CaptureFocus()		
	end
end)


chatInput.FocusLost:Connect(function(enterPressed)

	if not enterPressed then return end
	
	isChatting = false


	local input = chatInput.Text

	chatInput.Text = ""


	if string.len(input) > 0 then


		if isCoolingDown == true then 

			chatInput.Text = "Wait for cooldown to end!"
			
			wait(1)
			
			if not isChatting then chatInput.Text = "" end

			return 		
		end

		isCoolingDown = true


		onChatInputted:FireServer(input)


		wait(cooldown)

		isCoolingDown = false	
	end	
end)