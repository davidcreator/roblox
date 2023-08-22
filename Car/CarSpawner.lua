local plrCars = {}


game.ReplicatedStorage:WaitForChild("CarSpawnRE").OnServerEvent:Connect(function(plr, car)
	
	if car then
		
		if plrCars[plr] then
			
			plrCars[plr]:Destroy()
		end
		
		
		local newCar = car:Clone()	
		
		local hrp = plr.Character.HumanoidRootPart
		
		newCar:SetPrimaryPartCFrame(hrp.CFrame + (hrp.CFrame.LookVector * 10) + Vector3.new(0, 10, 0))
		
		newCar.Parent = workspace
		
		plrCars[plr] = newCar
	end
end)