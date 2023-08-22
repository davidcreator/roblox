local re = game.ReplicatedStorage:WaitForChild("AxeRE")

local cooldown = {}


re.OnServerEvent:Connect(function(player, target, mouseHit)
	
	if not cooldown[player] and player.Character and target and target.Name == "Trunk" and target:FindFirstChild("Health") and mouseHit then
		
		local hrp = player.Character.HumanoidRootPart
		local distance = (hrp.Position - target.Position).Magnitude
		
		if distance <= 5 then
			cooldown[player] = true
			
			if not target:FindFirstChild("MaxHealth") then
				local maxHealth = Instance.new("IntValue")
				maxHealth.Name = "MaxHealth"
				maxHealth.Value = target.Health.Value
				maxHealth.Parent = target
			end
			
			target.Health.Value -= 1
			
			if target.Health.Value < 1 then
			
				local treeBottom = target.CFrame:ToWorldSpace(CFrame.new(Vector3.new(0, -target.Size.Y/2, 0)))
				local treeTop = target.CFrame:ToWorldSpace(CFrame.new(Vector3.new(0, target.Size.Y/2, 0)))

				local yHeight = target.CFrame:PointToObjectSpace(mouseHit.Position).Y + target.Size.Y/2

				local treeMiddle = treeBottom:PointToWorldSpace(Vector3.new(0, yHeight, 0))

				local bottomSize = (treeMiddle - treeBottom.Position).Magnitude
				local topSize = (treeMiddle - treeTop.Position).Magnitude

				local bottomPos = treeBottom:PointToWorldSpace(Vector3.new(0, bottomSize/2, 0))
				local topPos = treeTop:PointToWorldSpace(Vector3.new(0, -topSize/2, 0))
				
				target.Health:Destroy()
				
				local bottomPart = target:Clone()
				bottomPart.Position = bottomPos
				bottomPart.Size = Vector3.new(target.Size.X, bottomSize, target.Size.Z)
				bottomPart.Parent = workspace

				local topPart = target:Clone()
				topPart.Position = topPos
				topPart.Size = Vector3.new(target.Size.X, topSize, target.Size.Z)
				topPart.Anchored = false
				topPart.Parent = workspace
				
				local bv = Instance.new("BodyVelocity")
				bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
				bv.Velocity = player.Character.HumanoidRootPart.CFrame.LookVector
				bv.Parent = topPart
				game:GetService("Debris"):AddItem(bv, 1)
				
				local newHealthValue = target.MaxHealth:Clone()
				newHealthValue.Name = "Health"
				newHealthValue.Parent = bottomPart
				newHealthValue:Clone().Parent = topPart
				
				if target.Parent:FindFirstChild("Leaves") then
					local leaves = target.Parent.Leaves
					spawn(function()
						leaves.CanCollide = false
						leaves.Anchored = false
						wait(1)
						leaves.Parent:Destroy()
					end)
				end
				
				target:Destroy()
			end
			
			wait(1)
			cooldown[player] = false
		end
	end
end)