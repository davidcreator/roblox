local pps = game:GetService("ProximityPromptService")


local bp = Instance.new("BodyPosition")
bp.D = 1000
bp.MaxForce = Vector3.new(0, 0, 0)
bp.Parent = script.Parent

local bg = Instance.new("BodyGyro")
bg.MaxTorque = Vector3.new(0, 0, 0)
bg.Parent = script.Parent


script.Parent.BackParticles.ParticleEmitter.Enabled = false
script.Parent.FrontParticles.ParticleEmitter.Enabled = false



pps.PromptTriggered:Connect(function(prompt, player)
	
	if prompt == script.Parent.ProximityPrompt then
		
		script.Parent:SetNetworkOwner(player)
		
		game.ReplicatedStorage.HoverboardRE:FireClient(player, script.Parent)
		
		bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		
		prompt.Enabled = false
		
		local character = player.Character
		
		character.Humanoid.WalkSpeed = 0
		
		local weld = Instance.new("Weld", script.Parent)
		
		weld.Part0 = script.Parent
		weld.Part1 = character.HumanoidRootPart
		
		weld.C0 = CFrame.new(0, (character.HumanoidRootPart.Size.Y * 0.5) + character.Humanoid.HipHeight, 0)
		
		script.Parent.BackParticles.ParticleEmitter.Enabled = true
		script.Parent.FrontParticles.ParticleEmitter.Enabled = true
	end
end)


game.ReplicatedStorage.HoverboardRE.OnServerEvent:Connect(function(player)
	
	if player == script.Parent:GetNetworkOwner() then
		
		script.Parent:SetNetworkOwner()
		
		bp.MaxForce = Vector3.new(0, 0, 0)
		bg.MaxTorque = Vector3.new(0, 0, 0)
		
		script.Parent.ProximityPrompt.Enabled = true
		
		script.Parent.Weld:Destroy()
		
		player.Character.Humanoid.WalkSpeed = 16
		
		script.Parent.BackParticles.ParticleEmitter.Enabled = false
		script.Parent.FrontParticles.ParticleEmitter.Enabled = false
	end
end)