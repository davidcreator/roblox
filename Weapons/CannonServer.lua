local cannonCooldowns = {}


game.ReplicatedStorage:WaitForChild("CannonRE").OnServerEvent:Connect(function(player, cannon, instruction, mouse)
	
	if cannon.Top.Seat.Occupant == player.Character.Humanoid then
		
		if instruction == "MOVE" then
			cannon.Top:SetPrimaryPartCFrame(cannon.Top.PrimaryPart.CFrame * CFrame.Angles(0, -mouse.X/200, 0))
			
			cannon.Top.Gun:SetPrimaryPartCFrame(cannon.Top.Gun.PrimaryPart.CFrame * CFrame.Angles(0, mouse.Y/200, 0))
			
			if cannon.Top.Gun.PrimaryPart.Orientation.X > -65 then
				cannon.Top.Gun:SetPrimaryPartCFrame(cannon.Top.Gun.PrimaryPart.CFrame * CFrame.Angles(0, -mouse.Y/200, 0))
			end
			
			
		elseif instruction == "SHOOT" and not cannonCooldowns[cannon] then
			
			cannonCooldowns[cannon] = true

			local ball = game.ReplicatedStorage:WaitForChild("Cannonball"):Clone()
			ball.CFrame = CFrame.new(cannon.Top.Gun.CannonballPositionPart.Position)
			
			local bv = Instance.new("BodyVelocity")
			bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bv.Parent = ball
			
			local distance = (mouse.LookVector * 500 - cannon.Top.Gun.CannonballPositionPart.Position).Magnitude
			bv.Velocity = mouse.LookVector * 500
			
			ball.Touched:Connect(function(hit)
				
				local cannonHit = false
				for i, descendant in pairs(cannon:GetDescendants()) do
					if descendant == hit then
						cannonHit = true
					end
				end
				
				if not cannonHit then					
					if hit.Parent:FindFirstChild("Humanoid") then
						ball:Destroy()
						hit.Parent.Humanoid:TakeDamage(80)
					end
				end
			end)
			
			game:GetService("Debris"):AddItem(ball, 30)
			
			ball.Parent = workspace
			game.ReplicatedStorage.CannonRE:FireClient(player, ball)
			
			cannon.Top.Gun.CannonballPositionPart.ShootSound:Play()
			spawn(function()
				cannon.Top.Gun.CannonballPositionPart.ShootParticles.Enabled = true
				wait(0.1)
				cannon.Top.Gun.CannonballPositionPart.ShootParticles.Enabled = false
			end)
			
			spawn(function()
				wait(0.1)
				bv:Destroy()
			end)
			
			wait(2)
			
			cannonCooldowns[cannon] = false
		end
	end
end)