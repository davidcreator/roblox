local re = game.ReplicatedStorage:WaitForChild("SwordReplicatedStorage"):WaitForChild("SwordRE")

local ts = game:GetService("TweenService")

local ps = game:GetService("PhysicsService")
local cGroup = "Players"
ps:CreateCollisionGroup(cGroup)
ps:CollisionGroupSetCollidable(cGroup, cGroup, false)

for i, descendant in pairs(workspace:GetDescendants()) do
	if descendant:IsA("Humanoid") then
		for i, charDescendant in pairs(descendant.Parent:GetDescendants()) do
			if charDescendant:IsA("BasePart") then
				ps:SetPartCollisionGroup(charDescendant, cGroup)
			end
		end
	end 
end

--Create Motor6D when player spawns
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		
		repeat task.wait() until char:FindFirstChild("RightHand")
		
		local m6d = Instance.new("Motor6D")
		m6d.Name = "SwordMotor6D"
		m6d.Parent = char:WaitForChild("RightHand")
		m6d.Part0 = char.RightHand
		
		for i, descendant in pairs(char:GetDescendants()) do
			if descendant:IsA("BasePart") then
				ps:SetPartCollisionGroup(descendant, cGroup)
			end
		end
	end)
end)


local playerCombos = {}

local swingSounds = {
	game.ReplicatedStorage.SwordReplicatedStorage:WaitForChild("Swing1Sound"),
	game.ReplicatedStorage.SwordReplicatedStorage:WaitForChild("Swing2Sound"),
	game.ReplicatedStorage.SwordReplicatedStorage:WaitForChild("Swing3Sound"),
	game.ReplicatedStorage.SwordReplicatedStorage:WaitForChild("Swing4Sound")
}

--Listen to player requests
re.OnServerEvent:Connect(function(plr, instruction, sword)

	local char = plr.Character

	if char and sword and char.Humanoid.Health > 0 then
		--Connect Motor6D between sword and hand
		if instruction == "ConnectM6D" and sword.Parent == plr.Character then
			char.RightHand.SwordMotor6D.Part1 = sword.BodyAttach
		--Disconnect Motor6D when tool is unequipped
		elseif instruction == "DisconnectM6D" then
			char.RightHand.SwordMotor6D.Part1 = nil
			playerCombos[plr] = nil
			
			if char:FindFirstChild("BLOCKING") then
				char["BLOCKING"]:Destroy()
			end

		--Make player swing their sword
		elseif instruction == "attack" and sword.Parent == plr.Character then

			local currentCombo = (playerCombos[plr] and playerCombos[plr][1] or 0) + 1
			local lastAttacked = playerCombos[plr] and playerCombos[plr][2] or 0
			
			if tick() - lastAttacked > 0.4 then
				if currentCombo > 4 and tick() - lastAttacked < 1.3 then
					return
				end
				if currentCombo > 4 then
					currentCombo = 1
				end
				
				playerCombos[plr] = {currentCombo, tick()}
				
				for i, child in pairs(char:GetChildren()) do
					if child.Name == "SPRINTING" or child.Name == "BLOCKING" then
						child:Destroy()
					end
				end

				local hrp = char.HumanoidRootPart

				local rayParams = RaycastParams.new()
				rayParams.FilterDescendantsInstances = {char}
				local ray = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * Vector3.new(1, 0, 1) * 12, rayParams)
				
				task.spawn(function()
					if ray then
						local humanoid = ray.Instance.Parent:FindFirstChild("Humanoid") or ray.Instance.Parent.Parent:FindFirstChild("Humanoid")
						
						if humanoid then
							
							task.wait(currentCombo == 4 and 0.3 or 0.1)
							if not humanoid.Parent:FindFirstChild("BLOCKING") or ray.Normal == Vector3.FromNormalId(Enum.NormalId.Front) then
								
								local damage = currentCombo == 4 and 30 or 10
								humanoid:TakeDamage(damage)
								
								local dmgSound = game.ReplicatedStorage.SwordReplicatedStorage.DamageSound:Clone()
								dmgSound.Parent = ray.Instance
								dmgSound:Play()
								dmgSound.Ended:Connect(function()
									dmgSound:Destroy()
								end)
								
								local blood = game.ReplicatedStorage.SwordReplicatedStorage.BloodParticles.Attachment:Clone()
								blood.Parent = ray.Instance
								blood.Position = ray.Instance.Position - ray.Position
								game:GetService("Debris"):AddItem(blood, 0.2)
								
							else								
								task.spawn(function()
									local hitSound = game.ReplicatedStorage.SwordReplicatedStorage.HitSound:Clone()
									hitSound.Parent = ray.Instance
									task.wait(currentCombo == 4 and 0.3 or 0.1)
									hitSound:Play()
									hitSound.Ended:Connect(function()
										hitSound:Destroy()
									end)
								end)
							end
							
							if game.Players:GetPlayerFromCharacter(humanoid.Parent) then
								re:FireClient(game.Players:GetPlayerFromCharacter(humanoid.Parent), "camera shake")
							end
							
							for i, child in pairs(humanoid.Parent:GetChildren()) do
								if child.Name == "SPRINTING" or child.Name == "BLOCKING" then
									child:Destroy()
								end
							end
							
							local bv = Instance.new("BodyVelocity")
							bv.MaxForce = Vector3.new(math.huge, 0, math.huge)
							bv.Velocity = hrp.CFrame.LookVector * Vector3.new(1, 0, 1) * 50
							bv.Parent = humanoid.Parent.HumanoidRootPart
							game:GetService("Debris"):AddItem(bv, 0.1)
							
						else
							local soundPart = Instance.new("Part")
							soundPart.CanCollide = false
							soundPart.Anchored = true
							soundPart.Transparency = 1
							soundPart.Position = ray.Position
							soundPart.Parent = workspace
							
							task.spawn(function()
								task.wait(currentCombo == 4 and 0.3 or 0.1)
								
								local hitSound = game.ReplicatedStorage.SwordReplicatedStorage.HitSound:Clone()
								hitSound.Parent = soundPart
								hitSound:Play()
								hitSound.Ended:Connect(function()
									soundPart:Destroy()
								end)
								
								local sparks = game.ReplicatedStorage.SwordReplicatedStorage.SparksParticles:Clone()
								sparks.Position = ray.Position
								sparks.Parent = workspace
								game:GetService("Debris"):AddItem(sparks, 0.2)
							end)
						end
					end
				end)
				
				task.spawn(function()
					local swingSound = swingSounds[currentCombo]:Clone()
					swingSound.Parent = sword.BodyAttach
					if currentCombo == 4 then
						task.wait(0.2)
					end
					swingSound:Play()
					swingSound.Ended:Connect(function()
						swingSound:Destroy()
					end)
				end)
				
				if currentCombo == 4 then
					task.spawn(function()
						task.wait(0.3)
						local cracks = game.ReplicatedStorage.SwordReplicatedStorage.CracksPart:Clone()
						
						local cracksPos = Vector3.new()
						if ray and ray.Instance.Parent:FindFirstChild("Humanoid") then
							cracksPos = ray.Instance.Parent.HumanoidRootPart.Position - Vector3.new(0, ray.Instance.Parent.HumanoidRootPart.Size.Y * 1.5, 0) 
						elseif ray then
							cracksPos = ray.Position - Vector3.new(0, hrp.Size.Y * 1.5, 0)
						else
							cracksPos = hrp.Position - Vector3.new(0, hrp.Size.Y * 1.5, 0) + (hrp.CFrame.LookVector * 5 * Vector3.new(1, 0, 1))
						end
						cracks.Position = cracksPos
						local goalSize = cracks.Size
						cracks.Size = Vector3.new(0, 0, 0)
						cracks.Parent = workspace
						
						local ti = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
						local scaleTween = ts:Create(cracks, ti, {Size = goalSize})
						scaleTween:Play()
						
						for i = 1, math.random(3, 7) do
							local rock = Instance.new("Part")
							
							local rockSize = Vector3.new(Random.new():NextNumber(1.5, 2.2), Random.new():NextNumber(1, 2), Random.new():NextNumber(1.4, 2))	
							local orientation = Vector3.new(Random.new():NextNumber(-60, 60), Random.new():NextNumber(-60, 60), Random.new():NextNumber(-60, 60))
							
							local radius = game.ReplicatedStorage.SwordReplicatedStorage.CracksPart.Size.X / 2
							local rx = cracksPos.X + Random.new():NextNumber(-100, 100)
							local rz = cracksPos.Z + Random.new():NextNumber(-100, 100)
							local lookAt = Vector3.new(rx, cracksPos.Y, rz)
							
							local lv = CFrame.new(cracksPos, lookAt).LookVector
							local position = cracksPos + (lv * radius)
							local cf = CFrame.new(position, cracksPos + lv + orientation)
							
							local rayP = RaycastParams.new()
							rayP.FilterDescendantsInstances = {char, cracks}
							local floorRay = workspace:Raycast(cf.Position + Vector3.new(0, 3, 0), position - Vector3.new(0, 100, 0), rayP)
							local colour
							local mat
							if floorRay then
								colour = floorRay.Instance.Color
								mat = floorRay.Instance.Material
							end
							
							rock.Size = Vector3.new(0, 0, 0)
							rock.CFrame = cf
							rock.Orientation = orientation
							
							rock.CanCollide = false
							rock.Anchored = true
							rock.TopSurface = Enum.SurfaceType.Smooth
							rock.Color = colour or Color3.fromRGB(83, 86, 90)
							rock.Material = mat or Enum.Material.Slate
							rock.Parent = workspace
							
							local rockTween = ts:Create(rock, ti, {Size = rockSize})
							rockTween:Play()
							
							task.spawn(function()
								task.wait(1)
								local fallTween = ts:Create(rock, ti, {Position = rock.Position - Vector3.new(0, rock.Size.Y/2, 0)})
								fallTween:Play()
								fallTween.Completed:Wait()
								rock:Destroy()
							end)
						end
						task.wait(1)
						for i, texture in pairs(cracks:GetChildren()) do
							local transparencyTween = ts:Create(texture, ti, {Transparency = 1})
							transparencyTween:Play()
						end
						task.wait(0.3)
						cracks:Destroy()
					end)
				end
				
				re:FireClient(plr, "swing animation", currentCombo)
				
				task.spawn(function()
					if currentCombo == 4 then
						task.wait(0.24)
					else
						task.wait(0.06)
					end
					
					sword.BodyAttach.Attachment.SlashParticles.Rotation = NumberRange.new(-73 + sword.BodyAttach.Orientation.Z)
					sword.BodyAttach.Attachment.SlashParticles.Enabled = true
					wait(0.1)
					sword.BodyAttach.Attachment.SlashParticles.Enabled = false
				end)
				
				task.wait(1)
				if currentCombo == playerCombos[plr][1] then
					playerCombos[plr] = nil
				end
			end
			
		elseif instruction == "sprint" then
			if not char:FindFirstChild("SPRINTING") then
				
				for i, child in pairs(char:GetChildren()) do
					if child.Name == "BLOCKING" then
						child:Destroy()
					end
				end
				
				local sprintingValue = Instance.new("BoolValue")
				sprintingValue.Name = "SPRINTING"
				sprintingValue.Parent = char
				
			else
				for i, child in pairs(char:GetChildren()) do
					if child.Name == "SPRINTING" then
						child:Destroy()
					end
				end
			end
			
		elseif instruction == "block" and sword.Parent == plr.Character then
			
			for i, child in pairs(char:GetChildren()) do
				if child.Name == "SPRINTING" then
					child:Destroy()
				end
			end
			
			local blockValue = Instance.new("BoolValue")
			blockValue.Name = "BLOCKING"
			blockValue.Parent = char
			
		elseif instruction == "stop block" then
			
			for i, child in pairs(char:GetChildren()) do
				if child.Name == "BLOCKING" then
					child:Destroy()
				end
			end
		end
	end
end)