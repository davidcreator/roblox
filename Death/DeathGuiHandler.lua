local respawnBtn = script.Parent:WaitForChild("RespawnButton")
local timeToRespawn = script.Parent:WaitForChild("TimeToRespawn")
local skullImage = script.Parent:WaitForChild("Skull")

local blur = game.Lighting:WaitForChild("DeathScreenBlur")


local plr = game.Players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")


skullImage.Position    = UDim2.new(0.5, 0, 2, 0)
timeToRespawn.Position = UDim2.new(0.5, 0, 2, 0)
respawnBtn.Position    = UDim2.new(0.5, 0, 2, 0)

blur.Size = 0


local tweenService = game:GetService("TweenService")
local blurTI = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)

local blurTween = tweenService:Create(blur, blurTI, {Size = 20})
local unblurTween = tweenService:Create(blur, blurTI, {Size = 0})


local hasRespawned = false


local function hideGui()
	
	hasRespawned = true
	
	
	timeToRespawn:TweenPosition(UDim2.new(0.5, 0, 2, 0), "InOut", "Quint", 1)
	wait(0.2)

	respawnBtn:TweenPosition(UDim2.new(0.5, 0, 2, 0), "InOut", "Quint", 1)
	wait(0.2)

	skullImage:TweenPosition(UDim2.new(0.5, 0, 2, 0), "InOut", "Quint", 1)
	wait(0.2)


	unblurTween:Play()
	wait(1)


	game.ReplicatedStorage.RespawnRE:FireServer()
end


humanoid.Died:Connect(function()
	
	hasRespawned = false
	
	
	blurTween:Play()
	
	wait(1)
	
	
	skullImage:TweenPosition(UDim2.new(0.5, 0, 0.63, 0), "InOut", "Quint", 1)
	wait(0.2)
	
	respawnBtn:TweenPosition(UDim2.new(0.5, 0, 0.669, 0), "InOut", "Quint", 1)
	wait(0.2)
	
	timeToRespawn:TweenPosition(UDim2.new(0.5, 0, 0.775, 0), "InOut", "Quint", 1)
	wait(0.2)
	
	
	respawnBtn.MouseButton1Click:Connect(function()

		hideGui()
	end)
	
	
	for i = game.Players.RespawnTime, 0, -1 do
			
		timeToRespawn.Text = "Respawing in " .. i .. " seconds"
			
		wait(1)
	end
	
	if not hasRespawned then hideGui() end
end)