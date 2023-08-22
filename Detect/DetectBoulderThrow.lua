local re = game.ReplicatedStorage:WaitForChild("BoulderRE")


local mouse = game.Players.LocalPlayer:GetMouse()


local uis = game:GetService("UserInputService")



uis.InputBegan:Connect(function(inp, processed)

	if processed then return end


	if inp.KeyCode == Enum.KeyCode.H then


		re:FireServer()
	end
end)


re.OnClientEvent:Connect(function(boulder)
	
	
	boulder.BodyVelocity.Velocity = mouse.Hit.LookVector * 200
	
	boulder.BodyAngularVelocity.AngularVelocity = mouse.Hit.LookVector * 50
end)