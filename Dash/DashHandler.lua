local uis = game:GetService("UserInputService")


local char = script.Parent


local dashLength = 0.05

local cooldown = 2
local isCoolingDown = false


local function handleDash(velocity)
	
	
	if isCoolingDown then return end
	isCoolingDown = true
	

	local bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bv.Velocity = velocity

	bv.Parent = char.HumanoidRootPart
	
	wait(dashLength)

	bv:Destroy()
	
	wait(cooldown - dashLength)
	isCoolingDown = false
end


uis.InputBegan:Connect(function(key, processed)
	
	if processed then return end
	

	if key.KeyCode == Enum.KeyCode.Q then

		local velocity = -char.HumanoidRootPart.CFrame.RightVector * 100 + Vector3.new(0, 10, 0)

		handleDash(velocity)


	elseif key.KeyCode == Enum.KeyCode.E then

		local velocity = char.HumanoidRootPart.CFrame.RightVector * 100 + Vector3.new(0, 10, 0)

		handleDash(velocity)
	end
end)