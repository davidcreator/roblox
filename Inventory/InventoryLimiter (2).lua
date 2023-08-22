local inventoryLimit = 3


function getTools(plr:Player)
	
	local tools = {}
	
	for _, tool in pairs(plr.Backpack:GetChildren()) do
		table.insert(tools, tool)
	end
	
	for _, child in pairs(plr.Character:GetChildren()) do
		if child:IsA("Tool") then
			table.insert(tools, child)
		end
	end
	
	return tools
end

function checkIfOverLimit(plr:Player)
	
	local plrTools = getTools(plr)
	
	if #plrTools > inventoryLimit then
		
		for i = 1, (#plrTools - inventoryLimit) do
			local toolToRemove = plrTools[i]
			
			game:GetService("RunService").Heartbeat:Wait()
			toolToRemove.Parent = workspace
			toolToRemove.Handle.CFrame = plr.Character.HumanoidRootPart.CFrame - plr.Character.HumanoidRootPart.CFrame.LookVector * 5
		end
	end
end


game.Players.PlayerAdded:Connect(function(plr)
	
	plr:WaitForChild("Backpack").ChildAdded:Connect(function()
		checkIfOverLimit(plr)
	end)
	
	plr.CharacterAdded:Connect(function(char)
		
		char.ChildAdded:Connect(function(child)
			
			if child:IsA("Tool") then
				checkIfOverLimit(plr)
			end
		end)
	end)
end)