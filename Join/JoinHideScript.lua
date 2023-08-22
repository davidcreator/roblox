game.Players.PlayerAdded:Connect(function(plr)
	
	plr.PlayerGui:WaitForChild("ShopGui").ShopGuiBackground.Visible = false
	plr.PlayerGui:WaitForChild("ShopGui").OpenButton.Visible = true
end)