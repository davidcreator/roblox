local adminIDs = {84182809}


game.Players.PlayerAdded:Connect(function(plr)
	
	if table.find(adminIDs, plr.UserId) then
		
		
		plr.CharacterAdded:Connect(function()
			wait()
			script.AdminGui:Clone().Parent = plr:WaitForChild("PlayerGui")
		end)
	end
end)



game.ReplicatedStorage.AdminClicked.OnServerEvent:Connect(function(admin, plrChosen, buttonChosen)
	
	
	if not plrChosen or not buttonChosen or not table.find(adminIDs, admin.UserId) then return end
	
	
	if buttonChosen == "Kill" then
		
		if plrChosen.Character and plrChosen.Character:FindFirstChild("Humanoid") then
			
			plrChosen.Character.Humanoid.Health = 0
		end
		
		
	elseif buttonChosen == "Kick" then
		
		plrChosen:Kick()
		
		
	elseif buttonChosen == "Bring" and plrChosen.Character and admin.Character then
		
		plrChosen.Character.HumanoidRootPart.CFrame = admin.Character.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0)
		
		
	elseif buttonChosen == "TeleportTo" and plrChosen.Character and admin.Character then

		admin.Character.HumanoidRootPart.CFrame = plrChosen.Character.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0)
	end
end)