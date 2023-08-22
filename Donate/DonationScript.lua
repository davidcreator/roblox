local onDonateEvent = game.ReplicatedStorage.OnDonateClicked


onDonateEvent.OnServerEvent:Connect(function(plr, amount, receiver)
	
	
	local donatorMoney = plr.leaderstats.Money
	
	local receiverMoney = game.Players[receiver].leaderstats.Money
	
	
	if tonumber(amount) <= donatorMoney.Value then
		
		
		donatorMoney.Value = donatorMoney.Value - tonumber(amount)
		
		receiverMoney.Value = receiverMoney.Value + tonumber(amount)
	end	
end)