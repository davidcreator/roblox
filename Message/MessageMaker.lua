game.ReplicatedStorage.PlayerJoinedRE.OnClientEvent:Connect(function(plrName)

	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = plrName .. " has joined!",
		Color = Color3.fromRGB(255, 115, 0),
		Font = Enum.Font.SourceSansBold,
		TextSize = 18,
	})
end)