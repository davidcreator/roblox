local nametag = script:WaitForChild("AFKGui")


game.ReplicatedStorage.IsAFK.OnServerEvent:Connect(function(plr, isAFK)
	
	
	local char = plr.Character or plr.CharacterAdded:Wait()
	local head = char:WaitForChild("Head")
	
	
	if isAFK and not head:FindFirstChild(nametag.Name) then
		
		nametag:Clone().Parent = head
		
		
	elseif not isAFK and head:FindFirstChild(nametag.Name) then
		
		head[nametag.Name]:Destroy()
	end
end)