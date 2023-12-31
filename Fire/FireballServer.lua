local rs = game.ReplicatedStorage:WaitForChild("FireballReplicatedStorage")

local re = rs:WaitForChild("RemoteEvent")
local config = require(rs:WaitForChild("CONFIGURATION"))

local onCooldown = {}


re.OnServerEvent:Connect(function(plr, mouseHit)
	
	local char = plr.Character
	if char and char.Humanoid.Health > 0 then
		
		local start = char.HumanoidRootPart.Position
		local goal = mouseHit.Position
		
		local magnitude = (start - goal).Magnitude
		if magnitude > config.maxFireballRange then
			goal = CFrame.new(start, goal).LookVector * config.maxFireballRange
		end
		
		local rayParams = RaycastParams.new()
		rayParams.FilterType = Enum.RaycastFilterType.Blacklist
		rayParams.FilterDescendantsInstances = {char}
		
		local ray = workspace:Raycast(start, goal, rayParams)
		if ray then
			goal = ray.Position
		end
		
		local numFireballs = Random.new():NextInteger(config.minFireballsPerClick, config.maxFireballsPerClick)
		
		for i = 1, numFireballs do
			
			re:FireClient(plr, "camera shake", {1})
			
			task.spawn(function()
				re:FireAllClients("fireball", {start, goal, char})
				
				local distance = (start - goal).Magnitude
				local travelTime = distance / config.fireballSpeed
				
				task.wait(travelTime + 1)
				
				local hitbox = Instance.new("Part")
				hitbox.Shape = Enum.PartType.Cylinder
				hitbox.Anchored = true
				hitbox.CanCollide = false
				hitbox.Transparency = 1
				hitbox.Orientation = Vector3.new(0, 0, 90)
				hitbox.Size = Vector3.new(config.explosionRange, config.explosionRange, config.explosionRange)
				hitbox.Position = goal
				hitbox.Parent = workspace
				
				local connection = hitbox.Touched:Connect(function() end)
				local parts = hitbox:GetTouchingParts()
				connection:Disconnect()
				hitbox:Destroy()
				
				local damagedChars = {}
				for i, part in pairs(parts) do
					
					if part.Parent:FindFirstChild("Humanoid") and not damagedChars[part.Parent] then
						damagedChars[part.Parent] = true
						
						part.Parent.Humanoid:TakeDamage(config.explosionDamage)
					end
				end
			end)
			
			local randomDelay = Random.new():NextNumber(config.minFireballDelay, config.maxFireballDelay)
			task.wait(randomDelay)
		end
	end
end)