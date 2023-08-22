local tool = script.Parent

local idleAnim = script:WaitForChild("Idle")
local idleAnimTrack
local swingAnim = script:WaitForChild("Swing")
local swingAnimTrack

local slashSound = script:WaitForChild("SlashSound")
local sheathSound = script:WaitForChild("SheathSound")
local hitSound = script:WaitForChild("HitSound")

local hitCharacters = {}
local debounce = false

tool.Equipped:Connect(function()
	
	local humanoid = script.Parent.Parent.Humanoid
	if not idleAnimTrack then idleAnimTrack = humanoid:LoadAnimation(idleAnim) end
	
	idleAnimTrack:Play()
	
	sheathSound:Play()
end)
tool.Unequipped:Connect(function()
	
	if idleAnimTrack then idleAnimTrack:Stop() end
	if swingAnimTrack then swingAnimTrack:Stop() end
	
	sheathSound:Play()
end)
tool.Activated:Connect(function()
	
	if debounce then return end
	debounce = true
		
	local humanoid = script.Parent.Parent.Humanoid
	if not swingAnimTrack then swingAnimTrack = humanoid:LoadAnimation(swingAnim) end
	
	swingAnimTrack:Play()
	
	wait(0.5)	
	slashSound:Play()
	
	wait(0.5)
	debounce = false
end)
tool.Blade.Touched:Connect(function(touch)
	
	if hitCharacters[touch.Parent] or not debounce then return end
	if touch.Parent:FindFirstChild("Humanoid") then
		
		if touch.Name == "Head" then
			touch.Parent.Humanoid:TakeDamage(20)
		else
			touch.Parent.Humanoid:TakeDamage(10)
		end
		hitSound:Play()
		hitCharacters[touch.Parent] = true
		wait(1)
		hitCharacters[touch.Parent] = nil
	end
end)