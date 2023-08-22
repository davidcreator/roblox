local tool = script.Parent
local re = tool:WaitForChild("BasketballRE")

local cooldown = false


local ps = game:GetService("PhysicsService")
ps:CreateCollisionGroup("Ball")
ps:CreateCollisionGroup("Character")
ps:CollisionGroupSetCollidable("Character", "Ball", false)


re.OnServerEvent:Connect(function(plr, mouseHit)
	
	local char = plr.Character
	local hum = char:FindFirstChild("Humanoid")
	
	
	if hum and not cooldown then

		cooldown = true
		
		hum.Jump = true
		
		local ballClone = tool.Handle:Clone()
		ballClone.Transparency = 0
		tool.Handle.Transparency = 1
		
		
		for i, descendant in pairs(plr.Character:GetDescendants()) do
			if descendant:IsA("BasePart") then ps:SetPartCollisionGroup(descendant, "Character") end
		end
		ps:SetPartCollisionGroup(ballClone, "Ball")
		
		
		local velocity = mouseHit.Position + Vector3.new(0, game.Workspace.Gravity * 0.5, 0)
		ballClone.Velocity = velocity
		
		ballClone.CanCollide = true
		ballClone.Parent = workspace
		
		
		game:GetService("Debris"):AddItem(ballClone, 120)
		
		wait(5)
		ballClone.Velocity = Vector3.new(0, 0, 0)
		tool.Handle.Transparency = 0
		cooldown = false
	end
end)