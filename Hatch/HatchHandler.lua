local incubator = script.Parent

local buyButton = incubator.BuyButton
local clickDetector = buyButton.ClickDetector
local buyTextLabel = buyButton.BuyGui.BuyTextLabel

local egg = incubator.Egg

local re = incubator.HatchRE


local petsFolder = game.ReplicatedStorage.HatchablePets


local plrsHatching = {}


local price = 1000


local rarities = 
{
	Common = 40,
	Uncommon = 30,
	Rare = 15,
	Epic = 10,
	Legendary = 5,
}
local rarityColours =
{
	Common = Color3.fromRGB(162, 169, 181),
	Uncommon = Color3.fromRGB(15, 185, 40),
	Rare = Color3.fromRGB(43, 85, 223),
	Epic = Color3.fromRGB(150, 24, 223),
	Legendary = Color3.fromRGB(223, 141, 25),
}


game.Players.PlayerAdded:Connect(function(plr)
	
	local ls = Instance.new("Folder")
	ls.Name = "leaderstats"
	ls.Parent = plr
	
	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = 1000
	cash.Parent = ls
end)


clickDetector.MouseClick:Connect(function(plrClicked)
	
	if plrsHatching[plrClicked] then return end
	if plrClicked.leaderstats.Cash.Value < price then return end
	
	plrsHatching[plrClicked] = true
	
	plrClicked.leaderstats.Cash.Value = plrClicked.leaderstats.Cash.Value - price
	
	
	local petsToPick = {}
	
	for i, hatchablePet in pairs(petsFolder:GetChildren()) do
		
		local rarity = hatchablePet.Rarity.Value
		
		for i = 1, rarities[rarity] do
			
			table.insert(petsToPick, hatchablePet)
		end
	end
	
	local chosenPet = petsToPick[math.random(1, #petsToPick)]
	
	
	re:FireClient(plrClicked, chosenPet, rarityColours[chosenPet.Rarity.Value])
	
	re.OnServerEvent:Wait()
	
	
	plrsHatching[plrClicked] = false
	
	
	local char = plrClicked.Character
	local hrp = char.HumanoidRootPart
	
	local petClone = chosenPet:Clone()
	
	petClone.CFrame = hrp.CFrame - (hrp.CFrame.RightVector * 5)
	
	local wConstraint = Instance.new("WeldConstraint")
	wConstraint.Part0 = hrp
	wConstraint.Part1 = petClone
	wConstraint.Parent = petClone
	
	petClone.Anchored = false
	petClone.CanCollide = false
	
	petClone.Parent = hrp
end)