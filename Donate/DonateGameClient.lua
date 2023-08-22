game.ReplicatedStorage.RemoteEvent.OnClientEvent:Connect(function()
	
	for i, descendant in pairs(workspace:GetDescendants()) do
		
		if descendant.Name == "StandProximityPrompt" then
			descendant.Enabled = false
			
			descendant:GetPropertyChangedSignal("Enabled"):Connect(function()
				
				descendant.Enabled = false
			end)
		end
	end
end)


local mps = game:GetService("MarketplaceService")

for i, descendant in pairs(workspace:GetDescendants()) do
	
	if descendant:IsA("TextButton") and descendant:FindFirstChild("Value") and tonumber(string.sub(descendant.Text, 1, #descendant.Text-2)) then
		
		descendant.MouseButton1Click:Connect(function()
			mps:PromptPurchase(game.Players.LocalPlayer, descendant.Value.Value)
		end)
	end
end

workspace.DescendantAdded:Connect(function(descendant)
	wait()
	if descendant:IsA("TextButton") and descendant:FindFirstChild("Value") and tonumber(string.sub(descendant.Text, 1, #descendant.Text-2)) then
		
		descendant.MouseButton1Click:Connect(function()
			mps:PromptPurchase(game.Players.LocalPlayer, descendant.Value.Value)
		end)
	end
end)