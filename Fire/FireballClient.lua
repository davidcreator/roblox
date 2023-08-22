local rs = game.ReplicatedStorage:WaitForChild("FireballReplicatedStorage")

local re = rs:WaitForChild("RemoteEvent")
local config = require(rs:WaitForChild("CONFIGURATION"))

local cas = game:GetService("ContextActionService")
local mobileButtonDown = false
local mouse = game.Players.LocalPlayer:GetMouse()
local camera = workspace.CurrentCamera

local char = script.Parent
local humanoid = char:WaitForChild("Humanoid")

local clientStart = tick()
local clientDebounce = false

local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 0
blurEffect.Parent = game.Lighting

local cameraTrauma = 0
local shakeSeed = Random.new():NextNumber()
local shakeIterator = 0


function disableParticles(part)
	for i, child in pairs(part:GetChildren()) do
		if child:IsA("ParticleEmitter") then
			child.Enabled = false
		end
	end
end

function cameraShake(epicentre)
	
	if typeof(epicentre) == "Vector3" then
		cameraTrauma = math.clamp(40/(char.HumanoidRootPart.Position - epicentre).Magnitude, 0, 2)
	else
		cameraTrauma = epicentre
	end

	shakeIterator = 0
	shakeSeed = Random.new():NextNumber()
end


function explosion(explosionPos)
	local newExplosion = Instance.new("Part")
	newExplosion.Anchored = true
	newExplosion.Transparency = 1
	newExplosion.Position = explosionPos

	newExplosion.Parent = workspace

	local explosionPhase1 = rs.FireballParts.Explosion.ExplosionPhase1:Clone()
	explosionPhase1.Parent = newExplosion

	task.wait(0.5)

	local explosionPhase1Debris = rs.FireballParts.Explosion.ExplosionPhase1Debris:Clone()
	explosionPhase1Debris.Parent = newExplosion

	task.wait(0.3)
	disableParticles(explosionPhase1)
	disableParticles(explosionPhase1Debris)
	
	local explosionLight = rs.FireballParts.Explosion.ExplosionLight:Clone()
	explosionLight.Parent = newExplosion

	local explosionSound = rs:WaitForChild("Sounds"):WaitForChild("Explosion"):Clone()
	explosionSound.Parent = newExplosion
	explosionSound:Play()

	local explosionPhase2 = rs.FireballParts.Explosion.ExplosionPhase2:Clone()
	explosionPhase2.Parent = newExplosion
	local explosionPhase3 = rs.FireballParts.Explosion.ExplosionPhase3:Clone()
	explosionPhase3.Parent = newExplosion
	
	cameraShake(explosionPos)

	task.wait(0.1)
	disableParticles(explosionPhase2)
	disableParticles(explosionPhase3)

	local explosionPhase3Debris = rs.FireballParts.Explosion.ExplosionPhase3Debris:Clone()
	explosionPhase3Debris.Parent = newExplosion

	task.wait(0.3)
	disableParticles(explosionPhase3Debris)

	task.wait(0.2)
	newExplosion:Destroy()
end


function handleInput(actionName, inputState, inputObject)
	
	if actionName ~= "FIREBALL" or inputState ~= Enum.UserInputState.End or clientDebounce then return end
	
	if inputObject.KeyCode == config.hotkey then
		clientDebounce = true
		
		re:FireServer(mouse.Hit)

		task.wait(config.cooldown)
		clientDebounce = false
		
	elseif inputObject.UserInputType == Enum.UserInputType.Touch then
		mobileButtonDown = not mobileButtonDown
	end
end

function fireMobile(actionName, inputState, inputObject)
	
	if actionName == "FIREBALL MOBILE" and inputState == Enum.UserInputState.End and not clientDebounce then
	
		if mobileButtonDown then
			clientDebounce = true
			mobileButtonDown = false

			re:FireServer(mouse.Hit)

			task.wait(config.cooldown)
			clientDebounce = false
			
		else
			return Enum.ContextActionResult.Pass
		end
	else
		return Enum.ContextActionResult.Pass
	end
end

cas:BindAction("FIREBALL", handleInput, true, config.hotkey)

cas:BindAction("FIREBALL MOBILE", fireMobile, false, Enum.UserInputType.Touch)

cas:SetImage("FIREBALL", "rbxassetid://11565509890")
cas:SetPosition("FIREBALL", UDim2.new(0.63, 0, 0.12, 0))


re.OnClientEvent:Connect(function(instruction, data)
	
	if instruction == "camera shake" then
		cameraShake(data[1])
		
		
	elseif instruction == "fireball" then
		
		local charShooting = data[3]
		
		local p0 = data[1]
		local p2 = data[2]
		
		local distance = (p0 - p2).Magnitude
		local travelTime = distance / config.fireballSpeed
		
		local randomX = Random.new():NextNumber(config.minFireballOffset, config.maxFireballOffset) * (distance/100)
		randomX *= Random.new():NextNumber() > 0.5 and -1 or 1
		
		local randomY = Random.new():NextNumber(config.minFireballOffset, config.maxFireballOffset) * (distance/100)
		randomY *= Random.new():NextNumber() > 0.5 and -1 or 1
		
		local randomZ = Random.new():NextNumber(config.minFireballOffset, config.maxFireballOffset) * (distance/100)
		randomZ *= Random.new():NextNumber() > 0.5 and -1 or 1
		
		local p1 = p0:Lerp(p2, 0.5) + Vector3.new(randomX, randomY, randomZ)
		
		local newFireball = rs:WaitForChild("FireballParts"):WaitForChild("Fireball"):Clone()
		newFireball.CanCollide = false
		newFireball.Anchored = true
		
		newFireball.Parent = workspace
		
		local shootSound = rs:WaitForChild("Sounds"):WaitForChild("Shoot"):Clone()
		shootSound.Parent = charShooting.HumanoidRootPart
		shootSound:Play()
		
		shootSound.Ended:Connect(function()
			shootSound:Destroy()
		end)
		
		local increments = travelTime / game:GetService("RunService").Heartbeat:Wait()
		
		for i = 1, increments do
			local p0Pos = p0:Lerp(p1, i/increments)
			local p1Pos = p1:Lerp(p2, i/increments)
				
			local curvePos = p0Pos:Lerp(p1Pos, i/increments)
			newFireball.Position = curvePos
			
			if i == math.floor(increments * 0.56) then
				task.spawn(explosion, p2)
			end

			game:GetService("RunService").Heartbeat:Wait()
		end
		
		newFireball:Destroy()
	end
end)


game:GetService("RunService").RenderStepped:Connect(function()
	
	if cameraTrauma > 0 then
		
		local now = tick() - clientStart
		shakeIterator += 1

		local shake = (cameraTrauma ^ 2)

		local noiseX = (math.noise(shakeIterator, now, shakeSeed)) * shake
		local noiseY = (math.noise(shakeIterator + 1, now, shakeSeed)) * shake
		local noiseZ = (math.noise(shakeIterator + 2 + 1, now, shakeSeed)) * shake

		humanoid.CameraOffset = Vector3.new(noiseX, noiseY, noiseZ)
		camera.CFrame = camera.CFrame * CFrame.Angles(noiseX / 50, noiseY / 50, noiseZ / 50)

		blurEffect.Size = shake * 12

		local falloffSpeed = 1.6
		cameraTrauma = math.clamp(cameraTrauma - falloffSpeed * game:GetService("RunService").Heartbeat:Wait(), 0, 3)
		
	else
		humanoid.CameraOffset = Vector3.new(0, 0, 0)
	end
end)