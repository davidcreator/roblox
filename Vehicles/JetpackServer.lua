local jetpackTool = script.Parent


local spacePressedRE = jetpackTool:WaitForChild("OnSpacePressed")
local spaceReleasedRE = jetpackTool:WaitForChild("OnSpaceReleased")


jetpackTool.Equipped:Connect(function()
		
	local upperTorso = jetpackTool.Parent:WaitForChild("UpperTorso")
		
	local mainPart = jetpackTool:WaitForChild("MainPart")
		
		
	local weld = Instance.new("Weld")
		
	weld.C0 = CFrame.new(0, 0.2, -0.6)
		
	weld.Part0 = mainPart
	weld.Part1 = upperTorso
		
	weld.Parent = mainPart
end)


spacePressedRE.OnServerEvent:Connect(function()

	jetpackTool.ParticlesPartLeft.ParticleEmitter.Enabled = true
	jetpackTool.ParticlesPartRight.ParticleEmitter.Enabled = true
end)

spaceReleasedRE.OnServerEvent:Connect(function()
	
	jetpackTool.ParticlesPartLeft.ParticleEmitter.Enabled = false
	jetpackTool.ParticlesPartRight.ParticleEmitter.Enabled = false
end)