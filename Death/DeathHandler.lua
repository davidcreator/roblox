local ts = game:GetService("TweenService")
local fadeTI = TweenInfo.new(5, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
local particlesTI = TweenInfo.new(2, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)


game.Players.PlayerAdded:Connect(function(plr)
	
	plr.CharacterAdded:Connect(function(char)
		
		
		local humanoid = char:WaitForChild("Humanoid")
		humanoid.BreakJointsOnDeath = false
	end)
end)


game.ReplicatedStorage.DiedRE.OnServerEvent:Connect(function(plr)
	
	if not plr.Character or not plr.Character:FindFirstChild("Humanoid") then return end
	
	local char = plr.Character
	local humanoid = char.Humanoid
	
	char.HumanoidRootPart.Anchored = true

	humanoid:LoadAnimation(script.DeathAnimation):Play()

	for i, d in pairs(char:GetDescendants()) do		

		if d:IsA("BasePart") or d:IsA("Decal") then

			spawn(function()


				ts:Create(d, fadeTI, {Transparency = 1}):Play()


				local particles = script.DeathParticles:Clone()
				particles.Rate = 0

				ts:Create(particles, particlesTI, {Rate = 100}):Play()

				particles.Parent = d

				wait(3)
				ts:Create(particles, particlesTI, {Rate = 0}):Play()
			end)
		end
	end
	
	wait(5)
	
	plr:LoadCharacter()
end)