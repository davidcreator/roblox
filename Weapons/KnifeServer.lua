local knife = script.Parent
local handle = knife:WaitForChild("Handle")


local throwRE = knife:WaitForChild("ThrowKnife")

local throwAnim = script:WaitForChild("ThrowAnimation")


local cooldown = 2
local isCooldown = false


throwRE.OnServerEvent:Connect(function(plr, mouseHit)
	
	
	local character = plr.Character
	
	if not character or not character:FindFirstChild("Humanoid") then return end
	
	
	if isCooldown then return end
	isCooldown = true
	
	
	character.Humanoid:LoadAnimation(throwAnim):Play()
	
	
	wait(0.4)
	
	
	local knifeClone = handle:Clone()
	knifeClone.Velocity = mouseHit.LookVector * 300
	
	knifeClone.Parent = workspace
	
	handle.Transparency = 1
	
	knifeClone.Throw:Play()
	
	
	knifeClone.CFrame = CFrame.new(knifeClone.Position, mouseHit.LookVector * 300)
	
	
	local bav = Instance.new("BodyAngularVelocity")
	bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	
	bav.AngularVelocity = knifeClone.CFrame:VectorToWorldSpace(Vector3.new(-400, 0, 0))
	bav.Parent = knifeClone
	
	
	game.ReplicatedStorage.ClientKnife:FireAllClients(knifeClone, knife.Parent)
	
	
	knifeClone.Touched:Connect(function(touched)
		
		if touched.Transparency < 1 and not knife.Parent:IsAncestorOf(touched) then	
			
			local humanoid = touched.Parent:FindFirstChild("Humanoid") or touched.Parent.Parent:FindFirstChild("Humanoid")
			
			if humanoid then
				
				humanoid.Health = 0
			end
			
			knifeClone.Anchored = true
			
			knifeClone.Hit:Play()
			wait(knifeClone.Hit.TimeLength)
			knifeClone:Destroy()
		end
	end)
	
	
	wait(cooldown - 0.4)
	isCooldown = false
	handle.Transparency = 0
end)