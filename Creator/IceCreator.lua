local re = game.ReplicatedStorage:WaitForChild("IceMagicActivated")


local plrsCoolingDown = {}


local shard = script:WaitForChild("IceShard")


local ts = game:GetService("TweenService")

local ti = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)



re.OnServerEvent:Connect(function(plr, mouseCF)
	
	
	if plrsCoolingDown[plr] then return end
	
	plrsCoolingDown[plr] = true
	
	
	local start = CFrame.new(plr.Character.HumanoidRootPart.Position, mouseCF.Position)
	
	local goal = start.LookVector * 70
	
	
	local shardsNum = math.random(8, 15)
	
	local shardIncrements = 70 / shardsNum
	

	
	for i = 1, shardsNum do
		
		
		local newShard = shard:Clone()
		newShard.Anchored = true
		newShard.CanCollide = false
		
		
		local x, y, z = math.random(30, 50)/30 * i, math.random(30, 50)/30 * i * 2, math.random(30, 50)/30 * i
		
		newShard.Size = Vector3.new(0, 0, 0)
		
		newShard.Orientation = Vector3.new(math.random(-30, 30), math.random(-180, 180), math.random(-30, 30))
		
		
		local pos = plr.Character.HumanoidRootPart.Position + start.LookVector * (shardIncrements * i)
		
		newShard.Position = Vector3.new(pos.X, 0, pos.Z)
		
		
		local newSize = Vector3.new(x, y, z)
		local newPos = newShard.Position + Vector3.new(0, y/2.5, 0)
		
		local tween = ts:Create(newShard, ti, {Size = newSize, Position = newPos})
		
		
		newShard.Parent = workspace
		
		tween:Play()
		
		
		local charactersHit = {}
		
		newShard.Touched:Connect(function(touch)
			
			
			if touch.Parent:FindFirstChild("Humanoid") and touch.Parent ~= plr.Character and not charactersHit[touch.Parent] then
				
				charactersHit[touch.Parent] = true
				
				touch.Parent.Humanoid:TakeDamage(30)
			end
		end)
		
		
		coroutine.resume(coroutine.create(function()
			
			
			wait(3)
			
			
			local reverseTween = ts:Create(newShard, ti, {Size = Vector3.new(0, 0, 0), Position = Vector3.new(pos.X, 0, pos.Z)})
			
			reverseTween:Play()
			
			reverseTween.Completed:Wait()
			newShard:Destroy()
		end))
		
		
		wait(math.random(1, 100)/1000)
	end
	
	
	plrsCoolingDown[plr] = false
end)