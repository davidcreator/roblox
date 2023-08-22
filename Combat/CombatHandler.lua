local leftPunch = script:WaitForChild("LPunch")
local rightPunch = script:WaitForChild("RPunch")

local leftKick = script:WaitForChild("LKick")
local rightKick = script:WaitForChild("RKick")


local char = script.Parent

local humanoid = char:WaitForChild("Humanoid")


local uis = game:GetService("UserInputService")


local debounce = false
local isAnimationPlaying = false


local loadedAnimation
local currentAnimationId


local remoteEvent = game.ReplicatedStorage.OnSuccessfulHit


uis.InputBegan:Connect(function(input, gameProcessed)
	
	if gameProcessed or isAnimationPlaying then return end

	
	if input.KeyCode == Enum.KeyCode.Q then
		
		
		isAnimationPlaying = true
		currentAnimationId = leftPunch.AnimationId
		
		loadedAnimation = humanoid:LoadAnimation(leftPunch)
		
		loadedAnimation:Play()
		
		
	elseif input.KeyCode == Enum.KeyCode.E then
		
		
		isAnimationPlaying = true
		currentAnimationId = rightPunch.AnimationId
		
		loadedAnimation = humanoid:LoadAnimation(rightPunch)
		
		loadedAnimation:Play()
		
		
	elseif input.KeyCode == Enum.KeyCode.F then
		
		
		isAnimationPlaying = true
		currentAnimationId = leftKick.AnimationId
		
		loadedAnimation = humanoid:LoadAnimation(leftKick)
		
		loadedAnimation:Play()
		
		
	elseif input.KeyCode == Enum.KeyCode.G then
		
		
		isAnimationPlaying = true
		currentAnimationId = rightKick.AnimationId
		
		loadedAnimation = humanoid:LoadAnimation(rightKick)
		
		loadedAnimation:Play()
	end
	
	if loadedAnimation then 
		
		
		loadedAnimation.Stopped:Wait()
		
		isAnimationPlaying = false
	end
end)


humanoid.Touched:Connect(function(hit, bodyPart)
	
	if not isAnimationPlaying or debounce then return end
	
	local charOfHitPlayer = hit.Parent
	local humanoidOfHitPlayer = charOfHitPlayer:FindFirstChild("Humanoid")
	
	if not humanoidOfHitPlayer then return end
	
	debounce = true
	
	
	if currentAnimationId == leftPunch.AnimationId and bodyPart.Name == "LeftHand" then
		
		remoteEvent:FireServer(humanoidOfHitPlayer)
			
	elseif currentAnimationId == rightPunch.AnimationId and bodyPart.Name == "RightHand" then
		
		remoteEvent:FireServer(humanoidOfHitPlayer)
		
	elseif currentAnimationId == leftKick.AnimationId and bodyPart.Name == "LeftFoot" then
		
		remoteEvent:FireServer(humanoidOfHitPlayer)
		
	elseif currentAnimationId == rightKick.AnimationId and bodyPart.Name == "RightFoot" then
		
		remoteEvent:FireServer(humanoidOfHitPlayer)
	end
	
	wait(0.1)
	
	debounce = false
end)