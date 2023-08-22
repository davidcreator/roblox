local jetpackTool = script.Parent


local fuelGui = script:WaitForChild("FuelGui")
local fuelGuiClone 

local fuelMax = 10
local fuelAmount = fuelMax


local plr = game.Players.LocalPlayer

local char = plr.Character or plr.CharacterAdded:Wait()


local uis = game:GetService("UserInputService")


local spacePressedRE = jetpackTool:WaitForChild("OnSpacePressed")
local spaceReleasedRE = jetpackTool:WaitForChild("OnSpaceReleased")

local spaceHeld = false


local bodyForce = Instance.new("BodyForce")
bodyForce.Force = Vector3.new(0, 0, 0)
bodyForce.Parent = jetpackTool.MainPart


jetpackTool.Equipped:Connect(function()
	
	fuelGuiClone = fuelGui:Clone()
	fuelGuiClone.Parent = plr.PlayerGui
	
	
	uis.InputBegan:Connect(function(key)
		
		if key.KeyCode == Enum.KeyCode.Space then
			
			spaceHeld = true
		end
	end)
	
	uis.InputEnded:Connect(function(key)
		
		if key.KeyCode == Enum.KeyCode.Space then
			
			spaceHeld = false
		end
	end)
end)


jetpackTool.Unequipped:Connect(function()
	
	spaceHeld = false
	
	fuelGuiClone:Destroy()
end)


while wait() do
	
	if plr.PlayerGui:FindFirstChild("FuelGui") then
		
		local xScale = (1 / fuelMax) * fuelAmount
		fuelGuiClone.BarBG.FuelBar.Size = UDim2.new(xScale, 0, 1, 0)
	end
	
	if spaceHeld and fuelAmount >= 0.03 then
		
		spacePressedRE:FireServer()
		
		bodyForce.Force = Vector3.new(0, 10000, 0)
		
		fuelAmount = math.clamp(fuelAmount - 0.03, 0, fuelMax)
		
	else
		
		spaceReleasedRE:FireServer()
		
		bodyForce.Force = Vector3.new(0, 0, 0)
		
		fuelAmount = math.clamp(fuelAmount + 0.01, 0, fuelMax)
	end
end