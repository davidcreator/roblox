game.ReplicatedStorage.OnCrouchBegun.OnServerEvent:Connect(function(plr, hum, speed, jump)
	
	hum.WalkSpeed = speed
	hum.JumpPower = jump	
end)