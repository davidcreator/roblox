local flashbang = script.Parent

local re = flashbang:WaitForChild("ThrowRE")

local cooldown = false


local ts = game:GetService("TweenService")


local ps = game:GetService("PhysicsService")
ps:CreateCollisionGroup("Flashbang")
ps:CreateCollisionGroup("Character")
ps:CollisionGroupSetCollidable("Character", "Flashbang", false)



re.OnServerEvent:Connect(function(plr, mouseHit)
	
	if cooldown then return end
	cooldown = true
		
	
	local flashbangCopy = flashbang.Handle:Clone()
	
	
	for i, descendant in pairs(plr.Character:GetDescendants()) do
		
		if descendant:IsA("BasePart") then ps:SetPartCollisionGroup(descendant, "Character") end
	end
	
	ps:SetPartCollisionGroup(flashbangCopy, "Flashbang")
	
	
	local velocity = (mouseHit.Position - Vector3.new(0, -game.Workspace.Gravity * 0.3, 0))
	flashbangCopy.Velocity = velocity
	
	
	local bav = Instance.new("BodyAngularVelocity", flashbangCopy)
	bav.AngularVelocity = velocity
	
	
	local touched = false
	
	
	flashbangCopy.Touched:Connect(function(hit)
		
		if not touched and hit.Parent ~= plr.Character and hit.Parent.Parent ~= plr.Character then
			
			touched = true
		
			bav:Destroy()
			
			
			for i, plrInGame in pairs(game.Players:GetPlayers()) do
				
				if plrInGame.Character and plrInGame.Character:FindFirstChild("HumanoidRootPart") then
					
					local char = plrInGame.Character
					
					
					local start = CFrame.new(flashbangCopy.Position, char.HumanoidRootPart.Position)
					
					local ray = Ray.new(start.Position, start.LookVector * 100)
					
					local part, pos, normal = workspace:FindPartOnRayWithWhitelist(ray, {char.HumanoidRootPart})
					
					normal = char.HumanoidRootPart.CFrame:VectorToObjectSpace(normal)
					local x, y, z = normal.X, normal.Y, normal.Z
					
					
					local frontHit = false
					
					if z ~= 0 and x == 0 and y == 0 and z < 0 then

						frontHit = true
					end
					
					
					local distance = (flashbangCopy.Position - plrInGame.Character.HumanoidRootPart.Position).Magnitude
					
					
					if part.Parent == plrInGame.Character and frontHit and distance < 30 then
						
						local gui = script:WaitForChild("FlashbangGui"):Clone()
						
						gui.FlashedFrame.Transparency = 1
						
						gui.Parent = plrInGame.PlayerGui
						
						local fadeInTween = ts:Create(gui.FlashedFrame, TweenInfo.new(0.3), {Transparency = 0}) 
						fadeInTween:Play()
						
						spawn(function()
							
							wait(3)
							
							local fadeOutTween = ts:Create(gui.FlashedFrame, TweenInfo.new(0.5), {Transparency = 1}) 
							fadeOutTween:Play()
							
							game:GetService("Debris"):AddItem(gui, 0.5)
						end)
					end
				end
			end
		end
	end)
	
	
	flashbangCopy.CanCollide = true
	flashbangCopy.Parent = workspace
	
	
	flashbang.Handle.Transparency = 1
	
	
	wait(3)

	flashbang.Handle.Transparency = 0
	flashbangCopy:Destroy()
	
	cooldown = false
end)