--Create folder to contain spawned cars
local spawnedCars = Instance.new("Folder")
spawnedCars.Name = "SpawnedCars"
spawnedCars.Parent = workspace


--Save data when player leaves
local dss = game:GetService("DataStoreService")
local ds = dss:GetDataStore("CarsDataStore")

function saveData(player)
	
	local cash = player.leaderstats.Cash.Value
	
	local cars = {}
	
	for i, car in pairs(player.Cars:GetChildren()) do
		table.insert(cars, car.Name)
	end
	
	ds:SetAsync(player.UserId .. "Cash", cash)
	ds:SetAsync(player.UserId .. "Cars", cars)
end

game.Players.PlayerRemoving:Connect(saveData)
game:BindToClose(function()
	for i, player in pairs(game.Players:GetPlayers()) do
		saveData(player)
	end
end)


--Load data when player joins
game.Players.PlayerAdded:Connect(function(player)
	
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = leaderstats
	
	local carsFolder = Instance.new("Folder")
	carsFolder.Name = "Cars"
	carsFolder.Parent = player
	
	
	local cashData = ds:GetAsync(player.UserId .. "Cash") or 100000
	local carsData = ds:GetAsync(player.UserId .. "Cars") or {}
	
	cash.Value = cashData
	
	for i, car in pairs(carsData) do
		if game.ReplicatedStorage.Cars:FindFirstChild(car) then
			game.ReplicatedStorage.Cars:FindFirstChild(car):Clone().Parent = carsFolder
		end
	end
end)


--Buying and spawning of cars
game.ReplicatedStorage:WaitForChild("CarsRE").OnServerEvent:Connect(function(player, instruction, car, dealership)
	
	local carRequest = game.ReplicatedStorage.Cars:FindFirstChild(car)
	if carRequest then
		
		if instruction == "BUY" then
			if player.leaderstats.Cash.Value >= carRequest.PRICE.Value and not player.Cars:FindFirstChild(carRequest.Name) then
				
				player.leaderstats.Cash.Value -= carRequest.PRICE.Value
				carRequest:Clone().Parent = player.Cars
			end
			
		elseif instruction == "SPAWN" then
			if player.Cars:FindFirstChild(carRequest.Name) then
				
				if spawnedCars:FindFirstChild(player.Name) then 
					spawnedCars[player.Name]:Destroy()
					for i, desc in pairs(workspace.CarDealerships:GetDescendants()) do
						if desc.Name == player.Name and desc.Parent.Parent.Name == "CarSpawns" then
							desc:Destroy()
						end
					end
				end
				
				local spawnedCar = carRequest:Clone()
				spawnedCar.Name = player.Name
				
				local chosenSpawn = nil
				for i, carSpawn in pairs(dealership.CarSpawns:GetChildren()) do
					if #carSpawn:GetChildren() < 1 then
						chosenSpawn = carSpawn
						local takenValue = Instance.new("StringValue")
						takenValue.Name = player.Name
						takenValue.Parent = chosenSpawn
						break
					end
				end
				
				spawnedCar:SetPrimaryPartCFrame(chosenSpawn.CFrame)
				
				spawnedCar.Parent = spawnedCars
			end
		end
	end
end)


--Removing cars when player leaves
game.Players.PlayerRemoving:Connect(function(player)
	if spawnedCars:FindFirstChild(player.Name) then 
		spawnedCars[player.Name]:Destroy()
		for i, desc in pairs(workspace.CarDealerships:GetDescendants()) do
			if desc.Name == player.Name and desc.Parent.Parent.Name == "CarSpawns" then
				desc:Destroy()
			end
		end
	end
end)


--Set up dealerships
for i, dealership in pairs(workspace.CarDealerships:GetChildren()) do
	
	local prompt = Instance.new("ProximityPrompt")
	prompt.ObjectText = "Car Dealership"
	prompt.ActionText = "Hold E to check cars"
	prompt.HoldDuration = 1
	prompt.Parent = dealership.PromptHolder
	
	prompt.Triggered:Connect(function(player)
		game.ReplicatedStorage.CarsRE:FireClient(player, prompt)
	end)
	
	local cars = game.ReplicatedStorage.Cars:GetChildren()
	
	for x, platform in pairs(dealership.CarPlatforms:GetChildren()) do
		
		local randomNum = math.random(1, #cars)
		local randomCar = cars[randomNum]
		table.remove(cars, randomNum)
		
		randomCar = randomCar:Clone()
		
		for y, desc in pairs(randomCar:GetDescendants()) do
			
			if desc:IsA("Seat") or desc:IsA("Script") or desc:IsA("VehicleSeat") or desc:IsA("LocalScript") then
				desc:Destroy()
			end
			if desc:IsA("BasePart") then
				desc.Anchored = true
			end
		end
		
		randomCar:SetPrimaryPartCFrame(CFrame.new(platform.Position, -randomCar.CameraPosition.CFrame.LookVector * 10000))
		randomCar.Parent = platform
		
		spawn(function()
			while wait() do
				randomCar:SetPrimaryPartCFrame(randomCar.PrimaryPart.CFrame * CFrame.Angles(0, 0.005, 0))
			end
		end)
	end
end