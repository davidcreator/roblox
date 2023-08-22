local limit = 5


function updateTools()


	local backpack = game.Players.LocalPlayer:WaitForChild("Backpack")
	local char = script.Parent


	local tools = {}

	for i, child in pairs(char:GetChildren()) do
		if child:IsA("Tool") then table.insert(tools, child) end
	end

	for i, tool in pairs(backpack:GetChildren()) do
		table.insert(tools, tool)
	end	


	for i, tool in pairs(tools) do
		
		if i > limit then tool:Destroy() end
	end
end



local backpack = game.Players.LocalPlayer:WaitForChild("Backpack")

backpack.DescendantAdded:Connect(updateTools)
backpack.DescendantRemoving:Connect(updateTools)

workspace.DescendantAdded:Connect(updateTools)
workspace.DescendantRemoving:Connect(updateTools)