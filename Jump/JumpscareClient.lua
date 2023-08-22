local remoteEvent = game.ReplicatedStorage:WaitForChild("JumpscareRE")
local monster = game.ReplicatedStorage:WaitForChild("Monster")


remoteEvent.OnClientEvent:Connect(function()
	
	local length = monster.ScreamSound.TimeLength
	
	local newMonster = monster:Clone()
	newMonster.Parent = workspace

	monster.ScreamSound:Play()

	repeat wait() until monster.ScreamSound.PlaybackLoudness > 50
	
	while monster.ScreamSound.IsPlaying do
	
		local random = CFrame.new(Vector3.new(math.random(0, 10)/100, math.random(0, 10)/100, math.random(0, 10)/100)) * CFrame.Angles(math.random(0, 10)/100, math.random(0, 10)/100, math.random(0, 10)/100)
		
		newMonster:SetPrimaryPartCFrame(workspace.CurrentCamera.CFrame * random)
		
		game:GetService("RunService").RenderStepped:Wait()
	end
	
	newMonster:Destroy()
end)