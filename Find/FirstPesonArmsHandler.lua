local char = script.Parent

local humanoid = char:WaitForChild("Humanoid")


local armParts = {"LeftHand", "LeftLowerArm", "LeftUpperArm", "RightHand", "RightLowerArm", "RightUpperArm"}


for i, bodyPart in pairs(char:GetChildren()) do
	
	if table.find(armParts, bodyPart.Name) and bodyPart:IsA("BasePart") then
		
		
		bodyPart.LocalTransparencyModifier = bodyPart.Transparency
		
		
		bodyPart:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
			
			bodyPart.LocalTransparencyModifier = bodyPart.Transparency
		end)
	end
end