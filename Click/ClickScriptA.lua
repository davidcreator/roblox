local ButtonPress = script.Parent:WaitForChild("ClickDetector")
local Door = game.Workspace.DoorA.door
local lol = false
local Xscale = Door.Size.X

ButtonPress.MouseClick:Connect(function(touch)
	if lol == false then
		for x = 1,5 do
			for i = 1, Xscale do
				Door.Size = Vector3.new(Door.Size.X - 0.2, Door.Size.Y, Door.Size.Z)
				Door.CFrame = Door.CFrame*CFrame.new(0.1, 0, 0)
				wait()
				lol = true
			end
		end
	end
end)
	
ButtonPress.MouseClick:Connect(function(touch)
	if lol == true then
		for x = 1,5 do
			for i = 1, Xscale do
				Door.Size = Vector3.new(Door.Size.X + 0.2, Door.Size.Y, Door.Size.Z)
				Door.CFrame = Door.CFrame*CFrame.new(-0.1, 0, 0)
				wait()
				lol = false
			end
		end 
	end
end)