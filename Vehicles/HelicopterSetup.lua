local bp = Instance.new("BodyPosition")
bp.MaxForce = Vector3.new(0, 0, 0)
bp.Parent = script.Parent.VehicleSeat

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(0, 0, 0)
bg.Parent = script.Parent.VehicleSeat



script.Parent.VehicleSeat.Changed:Connect(function()
	
	local occupant = script.Parent.VehicleSeat.Occupant
	
	if occupant then
		
		local player = game.Players:GetPlayerFromCharacter(occupant.Parent)
		
		if player then
			script.Parent.VehicleSeat:SetNetworkOwner(player)
			
			bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		end
		
	else
		
		bp.MaxForce = Vector3.new(0, 0, 0)
		bg.MaxTorque = Vector3.new(0, 0, 0)
		script.Parent.VehicleSeat:SetNetworkOwner(nil)
	end
end)