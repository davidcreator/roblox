local re = game.ReplicatedStorage:WaitForChild("EarthMagicRE")


local rock = script:WaitForChild("Rock")


local cooldowns = {}


local ts = game:GetService("TweenService")

local ti = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)



re.OnServerEvent:Connect(function(plr, mouseCF)
	
	
	if cooldowns[plr] then return end
	
	cooldowns[plr] = true
	
	
	local rocksToCreate = math.random(4, 7)
	
	local distance = rock.Size.X * rocksToCreate
	
	
	local startPos = plr.Character.HumanoidRootPart.Position - Vector3.new(0, plr.Character.HumanoidRootPart.Size.Y * 1.5 - rock.Size.Y / 2.3, 0)
	
	local direction = mouseCF.LookVector * Vector3.new(1, 0, 1)
	
	
	for i = 1, rocksToCreate do
		
		
		local newRock = rock:Clone()
		
		local rockPos = startPos + (direction * rock.Size.X * i)
		
		
		local ray = Ray.new(rockPos, rockPos - Vector3.new(0, 1000, 0))
		local part, pos = workspace:FindPartOnRay(ray, newRock)
		
		local y = pos.Y + newRock.Size.Y / 2
		rockPos = Vector3.new(rockPos.X, y, rockPos.Z)
		
		
		newRock.Position = rockPos - Vector3.new(0, rock.Size.Y, 0)
		
		newRock.Orientation = Vector3.new(math.random(-10, 10), math.random(0, 360), math.random(-10, 10))
		
		
		local upTween = ts:Create(newRock, ti, {Position = rockPos})
		upTween:Play()
		
		
		local hitChars = {}
		
		newRock.Touched:Connect(function(hit)
			
			if hit.Parent:FindFirstChild("Humanoid") and hit.Parent ~= plr.Character and not hitChars[hit.Parent] then
				
				hitChars[hit.Parent] = true
				
				hit.Parent.Humanoid:TakeDamage(30)
			end
		end)
		
		
		newRock.Parent = workspace
		
		
		wait(0.5)
		
		local downTween = ts:Create(newRock, ti, {Position = rockPos - Vector3.new(0, rock.Size.Y, 0)})
		downTween:Play()
		
		
		game:GetService("Debris"):AddItem(newRock, 0.5)
	end
	
	
	wait(3)
	
	cooldowns[plr] = false
end)