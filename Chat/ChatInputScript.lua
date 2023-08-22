local chatInput = script.Parent:WaitForChild("ChatInput")


local uis = game:GetService("UserInputService")


local onChatInputted = game.ReplicatedStorage:WaitForChild("OnChatInputted")


local cooldown = 1

local isCoolingDown = false


uis.InputBegan:Connect(function(key, gameProcessed)
		
	if key.KeyCode == Enum.KeyCode.Slash and not gameProcessed then	
		
		chatInput:CaptureFocus()		
	end
end)


chatInput.FocusLost:Connect(function(enterPressed)

	if not enterPressed then return end
	
	
	local input = chatInput.Text
	
	chatInput.Text = ""	
	
	
	if string.len(input) > 0 then
		
		
		if isCoolingDown == true then 
			
			chatInput.Text = "Wait for cooldown to end!"
			
			return 		
		end
		
		isCoolingDown = true
		
		
		onChatInputted:FireServer(input)
		
		
		wait(cooldown)
			
		isCoolingDown = false	
	end	
end)