local tool = script.Parent


local cooldown = 3
local coolingDown = false

local explodesIn = 3


local char


tool.Equipped:Connect(function()
	
	char = tool.Parent
end)

tool.Unequipped:Connect(function()
	
	char = nil
end)


local mouseCF

tool.MouseInfoRE.OnServerEvent:Connect(function(plr, mouseHit)
	
	mouseCF = mouseHit
end)


tool.Activated:Connect(function()
	
	if coolingDown then return end
	
	coolingDown = true
	
	
	char.Humanoid:LoadAnimation(script.ThrowAnim):Play()
	
	wait(0.1)
	
	
	local clone = tool.Handle:Clone()
	
	tool.Handle.Transparency = 1
	
	
	local bv = Instance.new("BodyVelocity")
	bv.Velocity = mouseCF.LookVector * 100
	bv.Parent = clone
	
	
	clone.Parent = workspace
	
	clone.CanCollide = true
	
	
	local explodeCoro = coroutine.wrap(function()
		
		
		wait(explodesIn)
		
		local explosion = Instance.new("Explosion")
		
		explosion.Position = clone.Position
		
		explosion.Parent = clone
		
		clone.ExplodeSound:Play()
		
		wait(1)
		clone:Destroy()
	end)
	
	explodeCoro()
	
	
	wait(0.1)
	
	bv:Destroy()
	

	wait(cooldown - 0.2)
	
	tool.Handle.Transparency = 0
	coolingDown = false
end)