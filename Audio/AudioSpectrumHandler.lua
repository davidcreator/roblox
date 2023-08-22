local music = script:WaitForChild("Music")

local barsSize = 0.1
local barsAmount = 100

local spectrumStartPos = Vector3.new(-6.27, 5.92, -3.67)

local audioSpectrumGroup = Instance.new("Model")
audioSpectrumGroup.Parent = workspace

for i = 0, barsAmount - 1 do
		
	local bar = Instance.new("Part")
	
	bar.Size = Vector3.new(barsSize, barsSize, barsSize)
	bar.Position = spectrumStartPos + Vector3.new(i * barsSize, 0, 0)	
	
	bar.Anchored = true
	bar.CanCollide = false
	
	bar.Parent = audioSpectrumGroup
end


game:GetService("RunService").RenderStepped:Connect(function()
	
	local currentLoudness = music.PlaybackLoudness

	for i, audioSpectrumBar in pairs(audioSpectrumGroup:GetChildren()) do
		
		audioSpectrumBar.Size = Vector3.new(barsSize, currentLoudness/barsAmount + (math.random(-10, 10)/10), barsSize)	

		audioSpectrumBar.Color = Color3.fromRGB(99, 0, math.clamp(currentLoudness, 0, 255))
	end
end)