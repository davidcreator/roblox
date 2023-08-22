local seat = script.Parent


local bv = Instance.new("BodyVelocity", seat)
bv.MaxForce = Vector3.new(0, 0, 0)
bv.Velocity = Vector3.new(0, 0, 0)

local bg = Instance.new("BodyGyro", seat)
bg.MaxTorque = Vector3.new(0, 0, 0)


seat:GetPropertyChangedSignal("Occupant"):Connect(function()
	
		
	for i, child in pairs(seat.Parent:GetChildren()) do

		if child.Name == "Particles" then 

			child.ParticleEmitter.Enabled = seat.Occupant ~= nil
		end
	end
	
	
	if seat.Occupant then
		
		seat:SetNetworkOwner(game.Players:GetPlayerFromCharacter(seat.Occupant.Parent))
		
		bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		
		
	else	
			
		bv.MaxForce = Vector3.new(0, 0, 0)
		bg.MaxTorque = Vector3.new(0, 0, 0)
	end
end)