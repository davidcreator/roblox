local coin = script.Parent


coin.Touched:Connect(function(touch)
	
	
	local char = touch.Parent
	
	local plr = game.Players:GetPlayerFromCharacter(char)
	
	
	if plr then
		
		
		plr.leaderstats.Money.Value = plr.leaderstats.Money.Value + 20
		
		
		coin:Destroy()
		
	end
end)