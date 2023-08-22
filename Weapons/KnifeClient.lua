local mouse = game.Players.LocalPlayer:GetMouse()


script.Parent.Activated:Connect(function()

	script.Parent:WaitForChild("ThrowKnife"):FireServer(mouse.Hit)
end)



game.ReplicatedStorage:WaitForChild("ClientKnife").OnClientEvent:Connect(function(knife, character)
	
	local knifeClone = knife:Clone()
	knifeClone.Parent = workspace
	
	knife:Destroy()
	
	
	knifeClone.Touched:Connect(function(touched)

		if touched.Transparency < 1 and not character:IsAncestorOf(touched) then	
			
			knifeClone.Anchored = true
			
			wait(knifeClone.Hit.TimeLength)
			knifeClone:Destroy()
		end
	end)
end)