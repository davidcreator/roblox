local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()

local animations = {
	equip = character:WaitForChild("Humanoid"):LoadAnimation(script:WaitForChild("EquipAnimation")),
	hold = character:WaitForChild("Humanoid"):LoadAnimation(script:WaitForChild("HoldAnimation")),
	reload = character:WaitForChild("Humanoid"):LoadAnimation(script:WaitForChild("ReloadAnimation")),
	shoot = character:WaitForChild("Humanoid"):LoadAnimation(script:WaitForChild("ShootAnimation")),
}

local remoteEvent = game.ReplicatedStorage:WaitForChild("GunRE")

local gun = script.Parent
local gunSettings = require(gun.GunSettings)

local uis = game:GetService("UserInputService")

local mouse = game.Players.LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera

local mouseDown = false

local cameraOffset = 0


--Equipping
gun.Equipped:Connect(function()
	remoteEvent:FireServer("ConnectM6D", gun)

	character.UpperTorso.GunMotor6D.Part0 = character.UpperTorso
	character.UpperTorso.GunMotor6D.Part1 = gun.BodyAttach

	game.Players.LocalPlayer.PlayerGui.GunGui.AmmoFrame.GunLabel.Text = gun.Name
	game.Players.LocalPlayer.PlayerGui.GunGui.AmmoFrame.AmmoLabel.Text = gun.CurrentAmmo.Value
	game.Players.LocalPlayer.PlayerGui.GunGui.Enabled = true
	uis.MouseIconEnabled = false

	animations["equip"]:Play()
	animations["equip"].Stopped:Wait()
	animations["hold"]:Play()
end)
--Unequipping
gun.Unequipped:Connect(function()
	remoteEvent:FireServer("DisconnectM6D", gun)

	game.Players.LocalPlayer.PlayerGui.GunGui.Enabled = false
	uis.MouseIconEnabled = true

	for i, animation in pairs(animations) do
		animation:Stop()
	end
end)

--Update ammo GUI when bullets change
gun.CurrentAmmo:GetPropertyChangedSignal("Value"):Connect(function()
	if gun.Parent == character then
		game.Players.LocalPlayer.PlayerGui.GunGui.AmmoFrame.AmmoLabel.Text = gun.CurrentAmmo.Value
	end
end)

--Clicking to shoot
mouse.Button1Down:Connect(function()
	mouseDown = true

	if gunSettings["automatic"] == true then
		repeat
			remoteEvent:FireServer("Shoot", gun, camera.CFrame, mouse.Hit)
			wait()
		until mouseDown == false

	else
		remoteEvent:FireServer("Shoot", gun, camera.CFrame, mouse.Hit)
	end
end)
--Letting go of click to stop shooting
mouse.Button1Up:Connect(function()
	mouseDown = false
end)

--Reload when player presses R
uis.InputBegan:Connect(function(inp, p)
	if not p and inp.KeyCode == Enum.KeyCode.R then
		remoteEvent:FireServer("Reload", gun)
	end
end)

--Apply recoil to camera and crosshair
game:GetService("RunService").Stepped:Connect(function()
	if gun.Parent == character then
		camera.CFrame = camera.CFrame:Lerp(camera.CFrame * CFrame.Angles(cameraOffset / 30, 0, 0), 0.2)
		cameraOffset = math.clamp(cameraOffset - 0.1, 0, math.huge)

		local crosshair = game.Players.LocalPlayer.PlayerGui.GunGui.CrosshairFrame
		crosshair.Position = UDim2.new(0, mouse.X, 0, mouse.Y)
		crosshair.Top.Position = UDim2.new(crosshair.Top.Position.X.Scale, 0, crosshair.Top.Position.Y.Scale, -math.clamp(cameraOffset, 0, 10) * 5)
		crosshair.Bottom.Position = UDim2.new(crosshair.Bottom.Position.X.Scale, 0, crosshair.Bottom.Position.Y.Scale, math.clamp(cameraOffset, 0, 10) * 5)
		crosshair.Left.Position = UDim2.new(crosshair.Left.Position.X.Scale, -math.clamp(cameraOffset, 0, 10) * 5, crosshair.Left.Position.Y.Scale, 0)
		crosshair.Right.Position = UDim2.new(crosshair.Right.Position.X.Scale, math.clamp(cameraOffset, 0, 10) * 5, crosshair.Right.Position.Y.Scale, 0)
	end
end)

--Server requests for gun
remoteEvent.OnClientEvent:Connect(function(gunEquipped, instruction, p3)
	if gunEquipped == gun then
		--Add recoil
		if instruction == "Recoil" then
			cameraOffset += gunSettings["cameraRecoil"]
			--Play reload animation
		elseif instruction == "Reload" then
			animations["reload"]:Play()
		end

		--Adjust tracer to be smoother on client
	elseif instruction == "Tracer" then

		local beamContainer = Instance.new("Part")
		beamContainer.Name = "BEAM CONTAINER"
		beamContainer.CanCollide = false
		beamContainer.Transparency = 1
		beamContainer.Anchored = true
		beamContainer.Parent = workspace

		local tracer = Instance.new("Beam")
		tracer.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 160, 40)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 160, 40))}
		tracer.FaceCamera = true
		tracer.LightEmission = 5
		local atch0, atch1 = Instance.new("Attachment"), Instance.new("Attachment")
		atch0.Name, atch0.Name = "A0", "A1"
		atch0.Parent, atch1.Parent = beamContainer, beamContainer
		atch0.WorldPosition, atch1.WorldPosition = gunEquipped.ShootPart.Position, p3
		tracer.Attachment0, tracer.Attachment1 = atch0, atch1
		tracer.Width0, tracer.Width1 = 0.05, 0.05

		tracer.Parent = beamContainer
		game:GetService("Debris"):AddItem(beamContainer, 0.1)
	end
end)