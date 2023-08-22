local eggs = workspace.Eggs:GetChildren()

local eggsFound = {}


local plr = game.Players.LocalPlayer

local char = plr.Character or plr.CharacterAdded:Wait()


local humanoid = char:WaitForChild("Humanoid")


script.Parent.Text = "Eggs: 0/" .. #eggs


humanoid.Touched:Connect(function(touch)
	
	for i, egg in pairs(eggsFound) do
		
		if egg == touch then return end	
	end
	
	if touch.Name == "Egg" then
			
		touch.Transparency = 1
		touch.CanCollide = false		
				
		table.insert(eggsFound, touch)
		
		script.Parent.Text = "Eggs: " .. #eggsFound .. "/" .. #eggs	
		
			
		if #eggsFound == #eggs then
			
			game.ReplicatedStorage.OnAllEggsFound:FireServer()	
		end	
	end
end)