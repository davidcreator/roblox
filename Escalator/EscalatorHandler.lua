local steps = script.Parent:WaitForChild("Steps"):GetChildren()


table.sort(steps, function(a, b)

	return a.Position.Y < b.Position.Y
end)


local startPos = steps[1].Position

local endY = startPos.Y + (#steps - 1) * steps[1].Size.Y


local speed = 1


local ts = game:GetService("TweenService")
local ti = TweenInfo.new(speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)



while wait(speed) do

	for i, step in pairs(steps) do
		
		
		local y, z = (1 / speed) * step.Size.Y, (1 / speed) * step.Size.Z

		step.Velocity = Vector3.new(0, y, z)


		if math.floor(step.Position.Y + 0.5) >= math.floor(endY) then

			step.Position = startPos
		end


		local tween = ts:Create(step, ti, {Position = step.Position + Vector3.new(0, step.Size.Y, step.Size.Z)})

		tween:Play()
	end
end