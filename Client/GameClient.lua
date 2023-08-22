local re = game.ReplicatedStorage:WaitForChild("RemoteEvent")


re.OnClientEvent:Connect(function(instruction, value)
	
	
	if instruction == "status" then
		
		script.Parent.Text = value
		
		
	elseif instruction == "chat" then
		
		game.StarterGui:SetCore("ChatMakeSystemMessage", 
			{
				Text = value,
				Color = Color3.fromRGB(5, 255, 63),
				Font = Enum.Font.SourceSansBold,
				TextSize = 18,
			})
		
		
	elseif instruction == "finished" then
		
		
		wait(1)
		
		value.CanCollide = true
	end
end)


