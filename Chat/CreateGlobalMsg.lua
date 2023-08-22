game.ReplicatedStorage.GlobalMessageRE.OnClientEvent:Connect(function(sender, message)
	
	game.StarterGui:SetCore("ChatMakeSystemMessage", 
		{
			Text = "[GLOBAL] " .. sender .. ": " .. message,
			Color = Color3.fromRGB(255, 174, 80),
			Font = Enum.Font.SourceSansBold,
			TextSize = 18,
		})
end)