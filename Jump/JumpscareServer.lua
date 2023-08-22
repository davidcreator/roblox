local remoteEvent = game.ReplicatedStorage:WaitForChild("JumpscareRE")


for i, jumpscareField in pairs(workspace:WaitForChild("JumpscareFields"):GetChildren()) do
	
	local playersScared = {}
	
	jumpscareField.Touched:Connect(function(hit)
		
		local player = game.Players:GetPlayerFromCharacter(hit.Parent) or game.Players:GetPlayerFromCharacter(hit.Parent.Parent)
		
		if player and not playersScared[player] then
			playersScared[player] = true
			
			remoteEvent:FireClient(player)
		end
	end)
end