game.ReplicatedStorage.OnPlayerKilled.OnClientEvent:Connect(function(msg)
	
	
	game.StarterGui:SetCore("ChatMakeSystemMessage", 
		{
			Text = msg,
			Color = Color3.fromRGB(5, 255, 63),
			Font = Enum.Font.SourceSansBold,
			TextSize = 18,
		})
end)