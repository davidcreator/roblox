game.Players.PlayerRemoving:Connect(function(plr)
	
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		
		Text = plr.Name .. " has left!",
		
		Color = Color3.fromRGB(255, 115, 0),
		Font = Enum.Font.SourceSansBold,
		TextSize = 18,
	})
end)