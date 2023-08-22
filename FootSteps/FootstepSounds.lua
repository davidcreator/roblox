local materialSounds = 
{
	[Enum.Material.Grass] = "rbxassetid://507863105",
	[Enum.Material.Metal] = "rbxassetid://2812417769",
	[Enum.Material.DiamondPlate] = "rbxassetid://2812417769",
	[Enum.Material.Pebble] = "rbxassetid://131436155",
	[Enum.Material.Wood] = "rbxassetid://4085869581",
	[Enum.Material.WoodPlanks] = "rbxassetid://4085869581",
	[Enum.Material.Plastic] = "rbxassetid://4453297814",
	[Enum.Material.SmoothPlastic] = "rbxassetid://4453297814",
	[Enum.Material.Sand] = "rbxassetid://265653329",
}


local char = script.Parent
		
local humanoid = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")
		
local footstepsSound = hrp:WaitForChild("Running")
		
humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
			
	local floorMat = humanoid.FloorMaterial
	local soundOfMat = materialSounds[floorMat]
			
	if soundOfMat then
		footstepsSound.SoundId = soundOfMat
	end
end)