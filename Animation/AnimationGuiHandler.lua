local anims = script:WaitForChild("Animations"):GetChildren()

local templateBtn = script:WaitForChild("AnimButton")


local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")


local currentAnim = nil


for i, anim in pairs(anims) do
	
	
	local loadedAnim = humanoid:LoadAnimation(anim)
	loadedAnim.Looped = true
	loadedAnim.Priority = Enum.AnimationPriority.Action
	
	
	local templateClone = templateBtn:Clone()
	templateClone.Text = anim.Name
	
	templateClone.Parent = script.Parent.AnimationsScroll
	
	
	templateClone.MouseButton1Click:Connect(function()
		
		if currentAnim ~= loadedAnim then 
			
			if currentAnim then currentAnim:Stop() end
			
			currentAnim = loadedAnim
			currentAnim:Play()
			
			
		elseif currentAnim == loadedAnim then
			
			currentAnim:Stop()
			currentAnim = nil
		end
	end)
end