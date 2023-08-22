local sound = script:WaitForChild("PunchSound")



game.Players.PlayerAdded:Connect(function(plr)
	
	plr.CharacterAdded:Connect(function(char)
		
		
		local humanoid = char:WaitForChild("Humanoid")
		local hrp = char:WaitForChild("HumanoidRootPart")
		
		
		local soundClone = sound:Clone()
		soundClone.Parent = hrp
		
		
		local hitChars = {}
		
		
		game:GetService("RunService").Heartbeat:Connect(function()
				
			
			local animations = humanoid:GetPlayingAnimationTracks()

			local attacking = false


			for i, animation in pairs(animations) do


				for i, combatAnim in pairs(game.ReplicatedStorage:WaitForChild("CombatAnimations"):GetChildren()) do

					if animation.Animation.AnimationId == combatAnim.AnimationId then

						attacking = true
					end
				end
			end
			
			
			
			if attacking then
				
				
				local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 3)
				
				local part, position = workspace:FindPartOnRay(ray, char)
				
				
				if part and part.Parent:FindFirstChild("Humanoid") and not hitChars[part.Parent] then
					
					
					hitChars[part.Parent] = true
					
					
					local damage = 10
					
					if part.Name == "Head" then
						
						damage = 30
					end
					
					
					local bv = Instance.new("BodyVelocity")
					bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
					
					bv.Velocity = hrp.CFrame.LookVector * 50 + Vector3.new(0, 10, 0)
					
					bv.Parent = part.Parent.HumanoidRootPart
					
					
					game:GetService("Debris"):AddItem(bv, 0.1)
					
					
					part.Parent.Humanoid:TakeDamage(damage)
					
					soundClone:Play()
					
					
					wait(0.6)
					
					hitChars[part.Parent] = nil
				end
			end
		end)
	end)
end)