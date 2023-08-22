local remoteEvent = game.ReplicatedStorage.OnSuccessfulHit


remoteEvent.OnServerEvent:Connect(function(plr, humanoidHit)
	
	
	humanoidHit:TakeDamage(10)
	
end)