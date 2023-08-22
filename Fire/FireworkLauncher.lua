local tweenService = game:GetService("TweenService")

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Bounce, Enum.EasingDirection.InOut)


local clickDetector = script.Parent.ClickDetector


local function propertyOfChildren(parent, property, value)
	
	for i, child in pairs(parent:GetChildren()) do	
		
		if child.ClassName == "Part" or child.ClassName == "MeshPart" then
			
			child[property] = value
		end	
	end
end


clickDetector.MouseClick:Connect(function()
	
	
	clickDetector:Destroy()
	
	
	script.Parent.ParticlesPart.LaunchParticles.Enabled = true
	
	
	local cframeVal = Instance.new("CFrameValue")
	
	cframeVal.Value = script.Parent:GetPrimaryPartCFrame()
	
	
	cframeVal:GetPropertyChangedSignal("Value"):Connect(function()
		
		script.Parent:SetPrimaryPartCFrame(cframeVal.Value)
	end)
	
	
	local tweenShake = tweenService:Create(cframeVal, tweenInfo, {Value = script.Parent.PrimaryPart.CFrame * CFrame.Angles(math.rad(math.random(10, 20)), math.rad(math.random(10, 20)), 0)})	
	tweenShake:Play()	
	
	tweenShake.Completed:Wait()
	
	
	local tweenShakeReturn = tweenService:Create(cframeVal, tweenInfo, {Value = script.Parent.PrimaryPart.CFrame * CFrame.Angles(math.rad(math.random(-20, -10)), math.rad(math.random(-20, -10)), 0)})	
	tweenShakeReturn:Play()	
	
	tweenShakeReturn.Completed:Wait()
	
	
	propertyOfChildren(script.Parent, "Anchored", false)
	
	
	local bodyPos = Instance.new("BodyVelocity")
	
	bodyPos.Velocity = Vector3.new(0, 3000, 0)
	
	bodyPos.Parent = script.Parent.MainBody
	
	
	script.Parent.ParticlesPart.LaunchSound:Play()
	
	
	wait(0.5)
	
	
	script.Parent.ParticlesPart.LaunchSound:Stop()
	
	
	bodyPos:Destroy()
	
	propertyOfChildren(script.Parent, "Anchored", true)
	
	
	propertyOfChildren(script.Parent, "Transparency", 1)
	
	
	script.Parent.ExplodeSound:Play()
	
	
	script.Parent.ParticlesPart.LaunchParticles.Enabled = false
	
	script.Parent.MainBody.ExplodeParticles.Enabled = true
	
	
	wait(3)
	
	
	script.Parent:Destroy()
end)