local rs = game.ReplicatedStorage:WaitForChild("BossReplicatedStorage")
local re = rs:WaitForChild("RemoteEvent")
local config = require(rs:WaitForChild("Configuration"))
local sounds = rs:WaitForChild("Sounds")
local anims = rs:WaitForChild("Animations")
local atks = rs:WaitForChild("Attacks")

local door = config.BossRoom:WaitForChild("EntranceDoor")
local lDoor = door:WaitForChild("Door"):WaitForChild("LeftDoor")
local rDoor = door:WaitForChild("Door"):WaitForChild("RightDoor")
local hitbox = door:WaitForChild("OpenDoorHitbox")

local openedDoor = false

local ts = game:GetService("TweenService")


hitbox.Touched:Connect(function(hit:Instance)
	local char = hit.Parent
	local plr = game.Players:GetPlayerFromCharacter(char)
	
	if plr and not openedDoor then
		openedDoor = true
		
		--Open sound
		local openSound = sounds:WaitForChild("DoorOpen"):Clone()
		openSound.Parent = lDoor.PrimaryPart
		openSound:Play()

		openSound.Ended:Connect(function()
			openSound:Destroy()
		end)
		
		task.wait(0.3)
		
		--Door animation
		local lDoorCFrame = lDoor:GetPivot() * CFrame.Angles(math.rad(75), 0, 0)
		local rDoorCFrame = rDoor:GetPivot() * CFrame.Angles(math.rad(-75), 0, 0)
		
		local duration = 0.7
		local style = Enum.EasingStyle.Back
		local direction = Enum.EasingDirection.Out
		
		re:FireAllClients({"TWEEN", lDoor, lDoorCFrame, duration, style, direction})
		re:FireAllClients({"TWEEN", rDoor, rDoorCFrame, duration, style, direction})
		
		task.wait(0.1)
		re:FireAllClients({"CAMERA SHAKE", lDoor:GetPivot().Position})
		
		
		--Spawn boss
		local boss = rs:WaitForChild("BossCharacter"):WaitForChild("Boss"):Clone()
		boss.Humanoid.MaxHealth = config.BossStats.health
		boss.Humanoid.Health = boss.Humanoid.MaxHealth

		boss.HumanoidRootPart.CFrame = config.BossRoom:WaitForChild("Spawns"):WaitForChild("BossSpawn").CFrame

		boss.Parent = workspace
		
		--Start cutscene
		re:FireAllClients({"BOSS INTRO CUTSCENE", boss})
		
		--Close door behind players
		lDoorCFrame = lDoor:GetPivot() * CFrame.Angles(math.rad(75), 0, 0)
		rDoorCFrame = rDoor:GetPivot() * CFrame.Angles(math.rad(-75), 0, 0)
		duration = 0.05
		style = Enum.EasingStyle.Linear
		direction = Enum.EasingDirection.InOut
		re:FireAllClients({"TWEEN", lDoor, lDoorCFrame, duration, style, direction})
		re:FireAllClients({"TWEEN", rDoor, rDoorCFrame, duration, style, direction})
		
		
		--Attack loop
		task.wait(10)
		
		local idleAnim = boss.Humanoid.Animator:LoadAnimation(anims.Idle)
		idleAnim:Play()
		
		local atksFolder = Instance.new("Folder")
		atksFolder.Name = "BOSS ATTACKS"
		atksFolder.Parent = workspace
		
		while boss.Humanoid.Health > 0 do
			for i, attack in pairs(config.BossStats.damageCycle) do
				
				if boss.Humanoid.Health <= 0 then break end
				
				if string.match(attack, "WAIT") then
					local timeToWait = tonumber(string.sub(attack, 6, -1))
					task.wait(timeToWait);if boss.Humanoid.Health <= 0 then break end
					
				elseif attack == "SPIKES" then
					local atk = atks:WaitForChild("Spike")
					local numSpikes = Random.new():NextInteger(config.BossStats.minSpikes, config.BossStats.maxSpikes)
					
					for x = 1, numSpikes do
						local spikeWarning = atk.SpikeWarning:Clone()
						
						local lbx, ubx = config.BossRoom.Spawns.SpikeSpawn.Position.X - config.BossRoom.Spawns.SpikeSpawn.Size.X/2, config.BossRoom.Spawns.SpikeSpawn.Position.X + config.BossRoom.Spawns.SpikeSpawn.Size.X/2
						local y = config.BossRoom.Spawns.SpikeSpawn.Position.Y
						local lbz, ubz = config.BossRoom.Spawns.SpikeSpawn.Position.Z - config.BossRoom.Spawns.SpikeSpawn.Size.Z/2, config.BossRoom.Spawns.SpikeSpawn.Position.Z + config.BossRoom.Spawns.SpikeSpawn.Size.Z/2
						
						local spikePos = Vector3.new(Random.new():NextNumber(lbx, ubx), y, Random.new():NextNumber(lbz, ubz))
						
						
						spikeWarning.Position = spikePos
						spikeWarning.Parent = atksFolder
						
						local spawnSound = sounds.SpikeSpawn:Clone()
						spawnSound.Parent = spikeWarning
						spawnSound:Play()
						
						local colourTI = TweenInfo.new(config.BossStats.spikeTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
						local colourTween = ts:Create(spikeWarning, colourTI, {Color = Color3.fromRGB(125, 47, 47)})
						colourTween:Play()
						
						task.spawn(function()
							colourTween.Completed:Wait()
							
							local spike = atk.Spike:Clone()
							spike.Position = spikeWarning.Position - Vector3.new(0, spike.Size.Y/2, 0)
							spike.Parent = atksFolder
							
							local touchDebounce = {}
							spike.Touched:Connect(function(hit)
								
								local char = hit.Parent
								if game.Players:GetPlayerFromCharacter(char) and char:FindFirstChild("Humanoid") and not touchDebounce[char] then
									touchDebounce[char] = true
									
									char.Humanoid:TakeDamage(config.BossStats.spikeAttackDamage)
									
									task.wait(2)
									touchDebounce[char] = false
								end
							end)
							
							local popupTI = TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
							local popupTween = ts:Create(spike, popupTI, {Position = spike.Position + Vector3.new(0, spike.Size.Y, 0)})
							popupTween:Play()
							
							local popupSound = sounds.SpikePopup:Clone()
							popupSound.Parent = spike
							popupSound:Play()
							
							task.wait(0.2);if boss.Humanoid.Health <= 0 then return end
							
							local dropTI = TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
							local dropTween = ts:Create(spike, dropTI, {Position = spike.Position - Vector3.new(0, spike.Size.Y, 0)})
							dropTween:Play()
							
							task.wait(0.4);if boss.Humanoid.Health <= 0 then return end
							spike:Destroy()
							spikeWarning:Destroy()
						end)
						
						task.wait(Random.new():NextNumber(0.03, 0.1));if boss.Humanoid.Health <= 0 then break end
					end
					
				elseif attack == "JUMP" then
					local charsIterated = {}
					local closestTarget = nil
					
					for x, plr in pairs(game.Players:GetPlayers()) do
						local char = plr.Character
						if char and char.Humanoid.Health > 0 then
							table.insert(charsIterated, char)
							
							if not closestTarget then
								closestTarget = char
								
							else
								local dist = (char.HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
								local closestDist = (closestTarget.HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
								
								if dist < closestDist then
									closestTarget = char
								end
							end
						end
					end	
					
					if closestTarget then
						local goalPos = closestTarget.HumanoidRootPart.Position
						
						local dist = (goalPos - boss.HumanoidRootPart.Position).Magnitude
						local jumpScale = dist / 20
						
						boss.Humanoid:MoveTo(goalPos)
						boss.HumanoidRootPart.Velocity = goalPos + Vector3.new(0, config.BossStats.jumpPower * jumpScale, 0)
						
						local jumpChargeAnim = boss.Humanoid.Animator:LoadAnimation(anims.JumpCharge)
						jumpChargeAnim:Play()
						jumpChargeAnim.Ended:Wait()
						
						local jumpMiddleAnim = boss.Humanoid.Animator:LoadAnimation(anims.JumpMiddle)
						jumpMiddleAnim:Play()
						
						repeat
							task.wait(0.05)
						until (boss.HumanoidRootPart.Position - goalPos).Magnitude <= 20;if boss.Humanoid.Health <= 0 then break end
						
						jumpMiddleAnim:Stop()
						
						local landAnim = boss.Humanoid.Animator:LoadAnimation(anims.Land)
						landAnim:Play()
						
						local landSound = sounds.GroundSmash:Clone()
						landSound.Parent = boss.HumanoidRootPart
						landSound:Play()
						
						local smoke = atks.Jump.Smoke:Clone()
						smoke.Position = goalPos
						smoke.Parent = atksFolder
						
						game:GetService("Debris"):AddItem(smoke, 0.3)
						
						re:FireAllClients({"CAMERA SHAKE", boss.HumanoidRootPart.Position, 100})
						
						for x, char in pairs(charsIterated) do
							local dist = (char.HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
							
							if dist <= config.BossStats.jumpDamageRange then
								char.Humanoid:TakeDamage(config.BossStats.jumpAttackDamage)
							end
						end
					end
					
				elseif attack == "LASERS" then
					
					local atch0 = Instance.new("Attachment")
					atch0.Name = "Attachment0"
					atch0.Parent = boss.Head
					
					local atch1Part = Instance.new("Part")
					atch1Part.CanCollide = false
					atch1Part.Anchored = true
					atch1Part.Transparency = 1
					
					local laserSound = sounds.Laser:Clone()
					laserSound.Parent = atch1Part
					laserSound:Play()
					
					local atch1 = atks.Laser.LaserEffects.Particles:Clone()
					atch1.Parent = atch1Part
					
					local beam = atks.Laser.LaserEffects.Beam:Clone()
					beam.Attachment0 = atch0
					beam.Attachment1 = atch1
					
					local lasersStarted = tick()
					
					while tick() - lasersStarted < config.BossStats.laserDuration do
						local closestTarget = nil

						for x, plr in pairs(game.Players:GetPlayers()) do
							local char = plr.Character
							if char and char.Humanoid.Health > 0 then

								if not closestTarget then
									closestTarget = char

								else
									local dist = (char.HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude
									local closestDist = (closestTarget.HumanoidRootPart.Position - boss.HumanoidRootPart.Position).Magnitude

									if dist < closestDist then
										closestTarget = char
									end
								end
							end
						end	
						
						if closestTarget then
							local randX = Random.new():NextNumber(-config.BossStats.laserMaxSpread, config.BossStats.laserMaxSpread)
							local randY = Random.new():NextNumber(-config.BossStats.laserMaxSpread, config.BossStats.laserMaxSpread)
							local randZ = Random.new():NextNumber(-config.BossStats.laserMaxSpread, config.BossStats.laserMaxSpread)
							local goal = closestTarget.HumanoidRootPart.Position + Vector3.new(randX, randY, randZ)
							
							local rayParams = RaycastParams.new()
							rayParams.FilterType = Enum.RaycastFilterType.Blacklist
							rayParams.FilterDescendantsInstances = {boss, atksFolder}
							
							local ray = workspace:Raycast(atch0.Position, goal, rayParams)
							
							if ray then
								goal = ray.Position
								
								if game.Players:GetPlayerFromCharacter(ray.Instance.Parent) and ray.Instance.Parent:FindFirstChild("Humanoid") then
									ray.Instance.Parent.Humanoid:TakeDamage(config.BossStats.laserAttackDamage)
								end
							end

							atch1Part.Position = goal
							atch1Part.Parent = atksFolder
							beam.Parent = atch0.Parent
							
							task.wait(0.1);if boss.Humanoid.Health <= 0 then break end
						end
					end
					atch0:Destroy()
					atch1Part:Destroy()
				end
			end
		end
		
		--Death effect
		re:FireAllClients({"BOSS FIGHT END"})
		
		local bp = Instance.new("BodyPosition")
		bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bp.Position = boss.HumanoidRootPart.Position
		bp.Parent = boss.HumanoidRootPart
		
		local anim = boss.Humanoid.Animator:LoadAnimation(anims.Death)
		anim:Play()

		local particles = rs.DeathEffect.Particles.Particles:Clone()
		particles.Parent = boss.HumanoidRootPart
		
		for i = 1, 100 do
			task.wait(0.05)
			bp.Position += Vector3.new(0, 0.05, 0)
		end
		
		local deathSoundPart = Instance.new("Part")
		deathSoundPart.Anchored = true
		deathSoundPart.CanCollide = false
		deathSoundPart.Transparency = 1
		local deathSound = sounds.Death:Clone()
		deathSound.Parent = deathSoundPart
		deathSoundPart.Parent = workspace
		
		deathSound:Play()
		
		task.wait(1)
		boss:Destroy()
		
		game:GetService("Debris"):AddItem(deathSoundPart, 10)
		
		--Open exit door
		local exitDoor = config.BossRoom:WaitForChild("ExitDoor")
		lDoor = exitDoor:WaitForChild("Door"):WaitForChild("LeftDoor")
		rDoor = exitDoor:WaitForChild("Door"):WaitForChild("RightDoor")
		
		lDoorCFrame = lDoor:GetPivot() * CFrame.Angles(math.rad(75), 0, 0)
		rDoorCFrame = rDoor:GetPivot() * CFrame.Angles(math.rad(-75), 0, 0)

		duration = 0.7
		style = Enum.EasingStyle.Back
		direction = Enum.EasingDirection.Out

		re:FireAllClients({"TWEEN", lDoor, lDoorCFrame, duration, style, direction})
		re:FireAllClients({"TWEEN", rDoor, rDoorCFrame, duration, style, direction})
	end
end)