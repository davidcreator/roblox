local cars = game.ReplicatedStorage:WaitForChild("Cars")


function makeGui()
	
	for i, child in pairs(script.Parent:GetChildren()) do
		
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	
	for i, car in pairs(cars:GetChildren()) do
		
		local btn = script.CarButton:Clone()
		
		btn.Text = car.Name
		
		btn.Parent = script.Parent
		
		
		btn.MouseButton1Click:Connect(function()
			
			game.ReplicatedStorage.CarSpawnRE:FireServer(car)
		end)
	end
end


makeGui()

cars.Changed:Connect(makeGui)