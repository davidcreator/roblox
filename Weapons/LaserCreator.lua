local tool = script.Parent
local shootPos = tool:WaitForChild("ShootPosition")

local shootRE = tool:WaitForChild("ShootRE")
local mouseRE = tool:WaitForChild("MouseRE")


local mouseCF = CFrame.new()
local camPos = Vector3.new()
local firing = false



shootRE.OnServerEvent:Connect(function(plr, isFiring)
	
	firing = isFiring
end)


mouseRE.OnServerEvent:Connect(function(plr, mouseHit, cameraPosition)
	
	mouseCF = mouseHit
	camPos = cameraPosition
end)



while wait() do
	
	
	local plr = game.Players:GetPlayerFromCharacter(tool.Parent)
	
	if firing and plr then
		
		local bullet = game.ServerStorage:WaitForChild("Bullet"):Clone()
		
		local ray = Ray.new(camPos, mouseCF.LookVector * 10000)
		
		local part, position = workspace:FindPartOnRayWithIgnoreList(ray, plr.Character:GetDescendants())
		
		if not position then position = mouseCF.LookVector * 10000 end
		
		local distance = (position - shootPos.Position).Magnitude
		local speed = distance / 50
		
		bullet.CFrame = CFrame.new(shootPos.Position, mouseCF.Position)
		
		local ti = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local tween = game:GetService("TweenService"):Create(bullet, ti, {Position = position})
		tween:Play()
		
		bullet.Parent = workspace
		
		
		bullet.Touched:Connect(function()end)
		
		touched = {}
		
		coroutine.resume(coroutine.create(function()
			
			while bullet do
				wait()
				local touching = bullet:GetTouchingParts()
				
				for i, part in pairs(touching) do
					
					if not part:IsDescendantOf(plr.Character) then
						
						local h = part.Parent:FindFirstChild("Humanoid") 

						if h and not touched[h] then

							h:TakeDamage(30)
							touched[h] = true
						end

						bullet:Destroy()
					end
				end
			end
		end))

		
		shootPos.ShootSound:Play()
		shootPos.ShootLight.Enabled = true
		wait(0.1)
		shootPos.ShootLight.Enabled = false
		
		wait(1)
	end
end