local remoteEvent = game.ReplicatedStorage:WaitForChild("ExplosionRE")


function createExplosion(radius, position)
	
	local newExplosion = Instance.new("Explosion")
	newExplosion.BlastRadius = radius
	newExplosion.Position = position
	
	newExplosion.BlastPressure = 0
	
	newExplosion.Parent = workspace
	
	newExplosion.Hit:Connect(function(part, distance)
		
		local plr = game.Players:GetPlayerFromCharacter(part.Parent)
		
		
		if plr then
			
			remoteEvent:FireClient(plr, distance)
		end
	end)
end


while wait(5) do

	createExplosion(100, Vector3.new(0, 0, 0))
end