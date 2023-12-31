local structures = game.ReplicatedStorage:WaitForChild("Structures")
local remote = game.ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("PlaceStructure")

local modules = game.ServerStorage:WaitForChild("ModuleScripts")
local findClosestStructure = require(modules:WaitForChild("FindClosestStructure"))
local placeStructure = require(modules:WaitForChild("PlaceStructure"))


local structuresContainer = Instance.new("Folder")
structuresContainer.Name = "STRUCTURES"
structuresContainer.Parent = workspace


remote.OnServerEvent:Connect(function(plr, structure, pos, rot)
	
	if plr and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
		
		if structure and structure.Parent == structures then
			if pos and typeof(pos) == "Vector3" and typeof(rot) == "number" then
				
				local closestStructureCF = findClosestStructure(structure, pos, rot)
				
				if closestStructureCF then
					placeStructure(plr, structure, closestStructureCF)
				end
			end
		end
	end
end)