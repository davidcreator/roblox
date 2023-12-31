local rs = game.ReplicatedStorage:WaitForChild("BossReplicatedStorage")
local re = rs:WaitForChild("RemoteEvent")
local config = require(rs:WaitForChild("Configuration"))
local sounds = rs:WaitForChild("Sounds")
local anims = rs:WaitForChild("Animations")

local plr = game.Players.LocalPlayer
local char = script.Parent
local camera = workspace.CurrentCamera

local plrGui = plr:WaitForChild("PlayerGui")
local healthBarGui = plrGui:WaitForChild("BossHealthGui")
healthBarGui.Enabled = false

local shakeTrauma = 0
local shakeSeed = Random.new():NextNumber()
local shakeIterator = 0
local falloffSpeed = 1.6
local clientStart = tick()
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = game.Lighting

local ts = game:GetService("TweenService")


function cameraShake(epicentre:any, duration:number, intensityScale)
	intensityScale = intensityScale or 1

	if typeof(epicentre) == "Vector3" then
		shakeTrauma = math.clamp(3/(char.HumanoidRootPart.Position - epicentre).Magnitude, 0, 2) * intensityScale
	else
		shakeTrauma = epicentre * intensityScale
	end
	
	if duration then
		falloffSpeed = shakeTrauma / duration
	else
		falloffSpeed = 1.6
	end

	shakeIterator = 0
	shakeSeed = Random.new():NextNumber()
end

function tweenModel(model:Model, goalCFrame:CFrame, length:number, style:Enum, direction:Enum)
	
	local cfv = model:FindFirstChildOfClass("CFrameValue")
	if not cfv then
		cfv = Instance.new("CFrameValue")
		cfv.Value = model:GetPivot()
		cfv.Parent = model
		
		cfv:GetPropertyChangedSignal("Value"):Connect(function()
			model:PivotTo(cfv.Value)
		end)
	end
	
	local ti = TweenInfo.new(length or 1, style or Enum.EasingStyle.Linear, direction or Enum.EasingDirection.InOut)
	local tween = ts:Create(cfv, ti, {Value = goalCFrame})
	tween:Play()
end


re.OnClientEvent:Connect(function(args)
	local instruction = args[1]
	
	if instruction == "TWEEN" then
		tweenModel(args[2], args[3], args[4], args[5], args[6])
		
	elseif instruction == "CAMERA SHAKE" then
		cameraShake(args[2], nil, args[3])
		
		
	elseif instruction == "BOSS INTRO CUTSCENE" then
		camera.CameraType = Enum.CameraType.Scriptable
		
		local boss = args[2]
		
		for _, instruction in pairs(config.IntroCutsceneInstructions) do
			local instructionType = instruction[1]
			
			if instructionType == "WAIT" then
				task.wait(instruction[2])
				
			elseif instructionType == "CAMERA SHAKE" then
				cameraShake(instruction[2], instruction[3])
				
			elseif instructionType == "PLAY SOUND" then
				local sound = sounds:WaitForChild(instruction[2])
				sound:Play()
				
			elseif instructionType == "PLAY ANIMATION" then
				local anim = boss.Humanoid.Animator:LoadAnimation(anims:WaitForChild(instruction[2]))
				anim:Play()
				
			elseif instructionType == "STOP ANIMATION" then
				local playingAnims = boss.Humanoid:GetPlayingAnimationTracks()
				for _, anim in pairs(playingAnims) do
					if anim.Animation.Name == instruction[2] then
						anim:Stop()
						break
					end
				end
				
			elseif instructionType == "MOVE" then
				local ti = TweenInfo.new(instruction[3], instruction[4], instruction[5])
				local tween = ts:Create(camera, ti, {CFrame = instruction[2]})
				tween:Play()
				tween.Completed:Wait()
			end
		end
		
		char.HumanoidRootPart.CFrame = config.BossRoom.Spawns.PlayerSpawn.CFrame
		camera.CameraType = Enum.CameraType.Custom
		sounds:WaitForChild("Music"):Play()
		
		local function updateBar()
			healthBarGui.HealthBarFrame.HealthAmount.Text = boss.Humanoid.Health .. "/" .. boss.Humanoid.MaxHealth
			healthBarGui.HealthBarFrame.HealthBar.Size = UDim2.new(boss.Humanoid.Health / boss.Humanoid.MaxHealth, 0, 1, 0)
		end
		updateBar()
		boss.Humanoid.HealthChanged:Connect(updateBar)
		
		healthBarGui.Enabled = true
		
	elseif instruction == "BOSS FIGHT END" then
		sounds.Music:Stop()
		healthBarGui.Enabled = false
	end
end)


game:GetService("RunService").RenderStepped:Connect(function()

	if shakeTrauma > 0 then
		
		local now = tick() - clientStart
		shakeIterator += 1

		local shake = (shakeTrauma ^ 2) / 3

		local noiseX = (math.noise(shakeIterator, now, shakeSeed)) * shake
		local noiseY = (math.noise(shakeIterator + 1, now, shakeSeed)) * shake
		local noiseZ = (math.noise(shakeIterator + 2 + 1, now, shakeSeed)) * shake
		
		if camera.CameraType == Enum.CameraType.Scriptable then
			camera.CFrame = camera.CFrame * CFrame.Angles(noiseX / 50, noiseY / 50, noiseZ / 50) + Vector3.new(noiseX, noiseY, noiseZ)
		else
			char.Humanoid.CameraOffset = Vector3.new(noiseX, noiseY, noiseZ)
			camera.CFrame = camera.CFrame * CFrame.Angles(noiseX / 50, noiseY / 50, noiseZ / 50)
		end

		blurEffect.Size = shake * 5

		shakeTrauma = math.clamp(shakeTrauma - falloffSpeed * game:GetService("RunService").Heartbeat:Wait(), 0, 3)

	else
		char.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
	end
end)