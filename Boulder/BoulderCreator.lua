local re = game.ReplicatedStorage:WaitForChild("BoulderRE")


local plrsOnCooldown = {}


local ts = game:GetService("TweenService")



re.OnServerEvent:Connect(function(plr)


	if plrsOnCooldown[plr] then return end

	plrsOnCooldown[plr] = true


	local hrp = plr.Character:WaitForChild("HumanoidRootPart")


	local startPos = hrp.Position + (hrp.CFrame.LookVector * 5) - Vector3.new(0, hrp.Size.Y * 1.5, 0)
	
	
	local boulder = script:WaitForChild("Boulder"):Clone()
	
	boulder.Size = Vector3.new(0, 0, 0)
	boulder.Position = startPos
	
	boulder.Anchored = true
	boulder.CanCollide = false
	
	
	boulder.Parent = workspace
	
	
	local newPos = startPos + Vector3.new(0, 10, 0)
	local newSize = Vector3.new(7, 7, 7)
	
	
	local ti = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
	
	local liftTween = ts:Create(boulder, ti, {Position = newPos, Size = newSize})
	liftTween:Play()
	
	liftTween.Completed:Wait()
	
	
	local bv = Instance.new("BodyVelocity", boulder)
	bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	
	local bav = Instance.new("BodyAngularVelocity", boulder)
	bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	
	
	boulder.Anchored = false
	boulder.CanCollide = true
	
	
	boulder:SetNetworkOwner(plr)
	
	re:FireClient(plr, boulder)
	
	
	local hitChars = {}
	
	
	boulder.Touched:Connect(function(hit)
			
		bv:Destroy()
		bav:Destroy()
		
		boulder:SetNetworkOwner(nil)
		
		
		if hit.Parent ~= plr.Character then
			
			
			if hit.Parent:FindFirstChild("Humanoid") and not hitChars[hit.Parent] then
				
				hitChars[hit.Parent] = true
				
				hit.Parent.Humanoid:TakeDamage(40)
			end
		end
	end)
	
	
	game:GetService("Debris"):AddItem(boulder, 30)
	

	wait(1)

	plrsOnCooldown[plr] = nil
end)