local remoteEvent = game.ReplicatedStorage:WaitForChild("GunRE")

local cooldown = {}

--Create connection when character spawns
game.Players.PlayerAdded:Connect(function(player)			
	player.CharacterAdded:Connect(function(character)	

		local motor6d = Instance.new("Motor6D")
		motor6d.Name = "GunMotor6D"
		motor6d.Part0 = character.UpperTorso
		motor6d.Parent = character.UpperTorso
	end)
end)

--Reloading function
function reload(player, gun, gunSettings)
	if not cooldown[player] and gun.Parent == player.Character and gun.CurrentAmmo.Value < gunSettings["ammo"] then
		cooldown[player] = true

		remoteEvent:FireClient(player, gun, "Reload")
		gun.BodyAttach.ReloadSound:Play()
		wait(gunSettings["reloadTime"])

		gun.CurrentAmmo.Value = gunSettings["ammo"]
		cooldown[player] = false
	end
end

--Handle client requests for gun
remoteEvent.OnServerEvent:Connect(function(player, instruction, gun, p4, p5)

	local character = player.Character
	if character then

		local gunSettings = require(gun.GunSettings)

		--Equipping
		if instruction == "ConnectM6D" and gun.Parent == character then

			character.UpperTorso.GunMotor6D.Part1 = gun.BodyAttach
			gun.BodyAttach.EquipSound:Play()

			cooldown[player] = true
			gun.BodyAttach.EquipSound.Ended:Wait()
			cooldown[player] = false

			--Unequipping
		elseif instruction == "DisconnectM6D" then

			for i, child in pairs(gun.BodyAttach:GetChildren()) do
				if child:IsA("Sound") then child:Stop() end
			end

			character.Humanoid:UnequipTools()
			character.UpperTorso.GunMotor6D.Part1 = nil

			--Shooting	
		elseif instruction == "Shoot" and not cooldown[player] and gun.Parent == player.Character then

			if gun.CurrentAmmo.Value > 0 then
				cooldown[player] = true
				spawn(function()
					gun.CurrentAmmo.Value -= 1

					gun.BodyAttach.ShootSound:Play()

					for i, effect in pairs(gun.ShootPart:GetChildren()) do
						effect.Enabled = true

						spawn(function()
							wait(0.1)
							effect.Enabled = false
						end)
					end

					remoteEvent:FireClient(player, gun, "Recoil")

					for i = 1, gunSettings["bulletsPerShot"] do

						local raycastParams = RaycastParams.new()
						raycastParams.FilterDescendantsInstances = {character, workspace:FindFirstChild("BulletHoleContainer")}

						local ray = workspace:Raycast(p4.Position, p5.LookVector * 1000, raycastParams)
						local desination = ray and ray.Position or p5.LookVector * 1000

						local distance = ray and ray.Distance or 1000

						local tracerStart = p4.Position
						local tracerEnd = desination

						local spreadMin = -gunSettings["spread"] / 100 * distance * 1000
						local spreadMax = gunSettings["spread"] / 100 * distance * 1000
						local spread = Vector3.new(math.random(spreadMin, spreadMax)/1000, math.random(spreadMin, spreadMax)/1000, math.random(spreadMin, spreadMax)/1000)
						tracerEnd += spread

						local damageRay = workspace:Raycast(tracerStart, CFrame.new(tracerStart, tracerEnd).LookVector * 1000, raycastParams)
						if damageRay then
							tracerEnd = damageRay.Position
							if damageRay.Instance.Parent:FindFirstChild("Humanoid") then
								local damage = gunSettings["damage"]
								damage -= gunSettings["damageFalloff"] * damageRay.Distance
								damageRay.Instance.Parent.Humanoid:TakeDamage(math.clamp(damage, 1, math.huge))
							end

							if not workspace:FindFirstChild("BulletHoleContainer") then
								local container = Instance.new("Folder")
								container.Name = "BulletHoleContainer"
								container.Parent = workspace
							end

							if damageRay.Instance.Anchored == true then
								local bulletHole = game.ReplicatedStorage.BulletHole:Clone()
								bulletHole.Anchored = true
								bulletHole.CFrame = CFrame.new(damageRay.Position, damageRay.Position + damageRay.Normal)
								bulletHole.Parent = workspace.BulletHoleContainer

								game:GetService("Debris"):AddItem(bulletHole, 20)
							end
						end

						remoteEvent:FireAllClients(gun, "Tracer", tracerEnd)
					end

					if gun:FindFirstChild("ShellEjectPart") then
						local shell = Instance.new("Part")
						shell.Color = Color3.fromRGB(255, 160, 40)
						shell.Size = Vector3.new(0.1, 0.1, 0.2)
						shell.CanCollide = false
						shell.CFrame = gun.ShellEjectPart.CFrame

						local bodyVelocity = Instance.new("BodyVelocity")
						bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
						bodyVelocity.Velocity = (shell.CFrame.RightVector * 15) + (shell.CFrame.UpVector * 2)
						bodyVelocity.Parent = shell

						shell.Parent = workspace
						game:GetService("Debris"):AddItem(bodyVelocity, 0.1)
						game:GetService("Debris"):AddItem(shell, 15)
					end
				end)
				wait(gunSettings["fireRate"])
				cooldown[player] = false

			else
				reload(player, gun, gunSettings)
			end

		elseif instruction == "Reload" then
			reload(player, gun, gunSettings)
		end
	end
end)