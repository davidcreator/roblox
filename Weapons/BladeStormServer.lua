local ts = game:GetService("TweenService")

local re = game.ReplicatedStorage:WaitForChild("BladeStormRE")

local cooldownLength = 5
local cooldowns = {}

local swords = Instance.new("Folder")
swords.Name = "SwordsFolder"
swords.Parent = workspace


re.OnServerEvent:Connect(function(plr, zoneP)
	
	local c = plr.Character
	if not cooldowns[plr] and c and c:FindFirstChild("Humanoid") and c.Humanoid.Health > 0 then
		local d = (c.HumanoidRootPart.Position - zoneP).Magnitude
		
		if d <= 80 then
			re:FireClient(plr, "CooldownOn")
			cooldowns[plr] = true
			spawn(function()
				wait(cooldownLength)
				cooldowns[plr] = false
				re:FireClient(plr, "CooldownOff")
			end)
			
			local newZone = game.ReplicatedStorage.Zone:Clone()
			newZone.Position = zoneP
			newZone.Circle.Color3 = Color3.fromRGB(3500, 100, 130)
			newZone.Parent = workspace
			
			spawn(function()
				while wait() do
					if newZone then
						newZone.Orientation += Vector3.new(0, 2, 0)
					else
						break
					end
				end
			end)
			
			re:FireClient(plr, newZone)
			
			local dropSound = game.ReplicatedStorage:WaitForChild("DropSwordSound"):Clone()
			dropSound.Parent = newZone
			dropSound:Play()
			dropSound.Ended:Connect(function()
				dropSound:Destroy()
			end)
			
			wait(0.7)
			for i = 1, math.random(25, 32) do

				local cx = zoneP.X
				local cz = zoneP.Z
				local radius = game.ReplicatedStorage.Zone.Size.Y / 2

				local randomRadius = radius * math.sqrt(Random.new():NextNumber())
				local theta = Random.new():NextNumber() * 2 * math.pi
				local x = cx + randomRadius * math.cos(theta)
				local z = cz + randomRadius * math.sin(theta)
				local y = zoneP.Y

				local goal = Vector3.new(x, y, z)
				local start = Vector3.new(x + Random.new():NextNumber(-3, 3), y + Random.new():NextNumber(15, 20), z + Random.new():NextNumber(-3, 3))

				local rp = RaycastParams.new()
				rp.FilterDescendantsInstances = {swords}
				local ray = workspace:Raycast(start, CFrame.new(start, goal).LookVector * 1000, rp)
				y = ray and ray.Position.Y or zoneP.Y
				goal = Vector3.new(goal.X, y, goal.Z)
				
				if ray then
					local humanoid = ray.Instance.Parent:FindFirstChild("Humanoid") or ray.Instance.Parent.Parent:FindFirstChild("Humanoid")
					if humanoid then
						humanoid:TakeDamage(60)
					end
				end

				local fallTime = (start.Y - goal.Y) * (Random.new():NextNumber(0, 0.3) / 15)

				re:FireAllClients(start, goal, fallTime, newZone)		

				wait(Random.new():NextNumber(0, 0.2))
			end
			
			re:FireClient(plr)
			
			local ti = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
			local fade = ts:Create(newZone.Circle, ti, {Transparency = 1})
			local scale = ts:Create(newZone, ti, {Size = Vector3.new(0.001, game.ReplicatedStorage.Zone.Size.Z*1.5, game.ReplicatedStorage.Zone.Size.Z*1.5)})
			fade:Play()
			scale:Play()
			scale.Completed:Wait()

			newZone:Destroy()
		end
	end
end)