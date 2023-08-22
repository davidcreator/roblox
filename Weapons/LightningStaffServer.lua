local folder = game.ReplicatedStorage:WaitForChild("LightningStaffReplicatedStorage")
local re = folder:WaitForChild("RemoteEvent")

local cooldowns = {}


re.OnServerEvent:Connect(function(plr, tool, mouseHit)
	
	local char = plr.Character
	
	if not cooldowns[plr] and char and tool.Parent == char and char.Humanoid.Health > 0 then
		
		local hrp = char.HumanoidRootPart
		
		local distance = (mouseHit.Position - hrp.Position).Magnitude
		
		if distance <= 40 then
		
			cooldowns[plr] = true
			re:FireClient(plr, "cooldownOn")
			
			local hitCF = CFrame.new(mouseHit.Position, Vector3.new(hrp.Position.X, mouseHit.Position.Y, hrp.Position.Z))
			local cloudCF = hitCF + Vector3.new(0, 35, 0)
			
			local cloud = folder.Cloud:Clone()
			cloud.CFrame = cloudCF
			cloud.Parent = workspace
			game:GetService("Debris"):AddItem(cloud, 20)
			
			task.wait(0.7)
			
			local glow = folder.CloudGlow:Clone()
			glow.CFrame = cloudCF
			glow.Parent = workspace
			
			local attachmentsList = {}
			local attachmentsAmount = math.random(7, 11)
			
			local increment = (hitCF.Position - cloudCF.Position).Magnitude / attachmentsAmount
			
			local lastWidth = Random.new():NextNumber(0.5, 1.3)
			
			task.spawn(function()
				for i = 1, attachmentsAmount do
					
					local attachment = Instance.new("Attachment")
					game:GetService("Debris"):AddItem(attachment, 0.5)
					table.insert(attachmentsList, attachment)
					
					local basePos = Vector3.new(0, -(i-1) * increment, 0)
					local rx = Random.new():NextNumber(-4, 4)
					local ry = Random.new():NextNumber(-3, 3)
					local rz = Random.new():NextNumber(-4, 4)
					basePos += Vector3.new(rx, ry, rz)
					
					if i == 1 then
						basePos = Vector3.new(0, 0, 0)
					
					elseif i == attachmentsAmount then
						basePos =  hitCF.Position - cloudCF.Position

						re:FireAllClients("cameraShake", hitCF.Position)
						
						local min = hitCF.Position - Vector3.new(folder.StrikeArea.Size.X/2, 0, folder.StrikeArea.Size.Z/2)
						local max = hitCF.Position + Vector3.new(folder.StrikeArea.Size.X/2, 10, folder.StrikeArea.Size.Z/2)
						local region = Region3.new(min, max)

						local parts = workspace:FindPartsInRegion3(region, nil, 1000)

						for i, part in pairs(parts) do
							if part.Name == "HumanoidRootPart" then
								local distance = (hitCF.Position - Vector3.new(part.Position.X, hitCF.Position.Y, part.Position.Z)).Magnitude
								if distance <= folder.StrikeArea.Size.X/2 then
									part.Parent.Humanoid:TakeDamage(50)
								end
							end
						end
					end
					
					attachment.Position = basePos
					attachment.Parent = cloud
					
					if i > 1 then
						local beam = Instance.new("Beam")
						game:GetService("Debris"):AddItem(beam, 0.5)
						beam.Parent = cloud
						
						beam.Attachment0 = attachmentsList[i-1]
						beam.Attachment1 = attachment
						
						beam.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(135, 143, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 143, 255))}
						beam.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 0)}
						beam.LightInfluence = 0
						beam.Brightness = 5
						beam.LightEmission = 5
						beam.FaceCamera = true
						
						beam.Width0 = lastWidth
						
						local randomWidth = math.clamp(lastWidth + Random.new():NextNumber(-0.4, 0.2), 0.1, 1)
						beam.Width1 = randomWidth
						lastWidth = randomWidth
					end
					
					task.wait(Random.new():NextNumber(0.03, 0.05))
				end
				
				cloud.CloudParticles.Enabled = false
			end)
			
			task.wait(0.2)
			glow.Attachment.GlowParticles.Enabled = false
			game:GetService("Debris"):AddItem(glow, 1)
			
			task.wait(5)
			cooldowns[plr] = false
			re:FireClient(plr, "cooldownOff")
		end
	end
end)