function PlayerEntered()
	
	game.StarterGui.ShopGui.ShopGuiBackground.Visible = false	
end

game.Players.PlayerAdded:Connect(PlayerEntered)