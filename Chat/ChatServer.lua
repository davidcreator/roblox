local msgContainer = game.ReplicatedStorage:WaitForChild("Containers"):WaitForChild("ChatMessageContainer")

local onChatInputted = game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ChatEvent")


onChatInputted.OnServerEvent:Connect(function(plr, msg)


	local filteredText

	local filteredString


	local stringValue = game.ReplicatedStorage:WaitForChild("Templates"):WaitForChild("ChatMessageTemplate"):Clone()


	local success, errormsg = pcall(function()


		filteredText =  game:GetService("TextService"):FilterStringAsync(msg, plr.UserId)			
	end)


	if success then

		local success2, errormsg2 = pcall(function()


			filteredString = filteredText:GetNonChatStringForBroadcastAsync()

		end)


		if success2 then

			stringValue.Text = "[" .. plr.Name .. "] " .. filteredString


			stringValue.Parent = msgContainer
			
			for i = 50, 0, -1 do
				
				wait()
				stringValue.TextTransparency = i/50
			end
			
			wait(30)
			
			for i = 0, 50 do

				wait()
				stringValue.TextTransparency = i/50
			end
			
			stringValue:Destroy()
			
			
		else

			warn(errormsg2)
			stringValue:Destroy()			
		end		
	else

		warn(errormsg)
		stringValue:Destroy()		
	end
end)