local re = game.ReplicatedStorage:WaitForChild("OnFireballThrown")


local plrsOnCooldown = {}


local ts = game:GetService("TweenService")


re.OnServerEvent:Connect(function(plr, mouseCF)
	
	
	if plrsOnCooldown[plr] then return end
	
	plrsOnCooldown[plr] = true
	
	
	local hrp = plr.Character:WaitForChild("HumanoidRootPart")
	
	
	local cf = CFrame.new(hrp.Position, mouseCF.Position)
	
	local newPos = cf.LookVector * 10000
	
	
	local fireball = script:WaitForChild("Fireball"):Clone()
	
	fireball.CFrame = cf
	
	
	local tweenTime = (hrp.Position - newPos).Magnitude / 100
	
	local ti = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	
	
	local tween = ts:Create(fireball, ti, {Position = newPos})
	tween:Play()
	
	tween.Completed:Connect(function()
		fireball:Destroy()
	end)
	
	
	fireball.Touched:Connect(function(hit)
		
		
		if hit.Parent ~= plr.Character then
			
			
			if hit.Parent:FindFirstChild("Humanoid") then
				
				hit.Parent.Humanoid:TakeDamage(30)
				
				
				local fires = {}
				
				for i, child in pairs(hit.Parent:GetChildren()) do
					
					if child:IsA("BasePart") then
						
						local fire = Instance.new("Fire", child)
						
						table.insert(fires, fire)
					end
				end
				
				
				spawn(function()
					
					for i = 1, math.random(5, 10) do
						
						hit.Parent.Humanoid:TakeDamage(5)
						
						wait(1)
					end
					
					
					for i, fire in pairs(fires) do
						fire:Destroy()
					end
				end)
			end
			
			
			fireball:Destroy()
		end
	end)
	
	
	fireball.Parent = workspace
	
	
	wait(1)
	
	plrsOnCooldown[plr] = nil
end)