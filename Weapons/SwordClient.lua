local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

local idleAnim = character:WaitForChild("Humanoid"):LoadAnimation(script.IdleAnimation)

local animCombo = {
	character:WaitForChild("Humanoid"):LoadAnimation(script.Swing1Animation),
	character:WaitForChild("Humanoid"):LoadAnimation(script.Swing2Animation),
	character:WaitForChild("Humanoid"):LoadAnimation(script.Swing3Animation),
}

local currentCombo = 1
	
	
script.Parent.Equipped:Connect(function()
	
	game.ReplicatedStorage.SwordRE:FireServer("connectm6d", script.Parent.BodyAttach)
	
	character.RightHand.ToolM6D:GetPropertyChangedSignal("Part1"):Wait()
	idleAnim:Play()
end)


script.Parent.Unequipped:Connect(function()

	game.ReplicatedStorage.SwordRE:FireServer("disconnectm6d")
	
	idleAnim:Stop()
end)


local cooldown = false

script.Parent.Activated:Connect(function()
	
	if cooldown then return end
	
	cooldown = true
	
	game.ReplicatedStorage.SwordRE:FireServer("attack", script.Parent.BodyAttach)
	
	animCombo[currentCombo]:Play()
	
	character.HumanoidRootPart.Velocity = character.HumanoidRootPart.CFrame.LookVector * 100 * Vector3.new(1, 0, 1)
	
	currentCombo += 1
	if currentCombo > #animCombo then currentCombo = 1 end
	
	local previousCombo = currentCombo
	
	spawn(function()
		
		wait(3)
		
		if currentCombo == previousCombo then
			currentCombo = 1
		end
	end)
	
	wait(0.5)
	
	cooldown = false
end)


game.ReplicatedStorage.SwordRE.OnClientEvent:Connect(function(bodyAttach)
	
	bodyAttach.Slash:Play()
	
	bodyAttach.Trail.Enabled = true
	wait(0.3)
	bodyAttach.Trail.Enabled = false
end)