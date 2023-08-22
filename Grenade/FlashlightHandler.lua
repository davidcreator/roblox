local tool = script.Parent

local lightSource = tool.LightSource:WaitForChild("SpotLight")


tool.Activated:Connect(function()
	
	lightSource.Enabled = not lightSource.Enabled
end)