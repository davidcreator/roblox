local frame = script.Parent:WaitForChild("CharacterFrame")
frame.Visible = false

--Open and close shop buttons
local openBtn = script.Parent:WaitForChild("OpenShopButton")
local closeBtn = frame:WaitForChild("CloseButton")

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

--Switch between shop and inventory
local shopBtn = frame:WaitForChild("ShopButton")
local invBtn = frame:WaitForChild("InventoryButton")
local selectedBar = frame:WaitForChild("SelectedBar")

local shopPage = frame:WaitForChild("ShopPage")
local invPage = frame:WaitForChild("InventoryPage")
shopPage.Visible = true
invPage.Visible = false

local shopFrame = shopPage.SelectedCrateFrame
local charFrame = invPage.SelectedCharacterFrame
shopFrame.Visible = false
charFrame.Visible = false

shopBtn.MouseButton1Click:Connect(function()
	shopPage.Visible = true
	invPage.Visible = false
	
	shopBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 77)
	invBtn.BackgroundColor3 = Color3.fromRGB(47, 47, 49)
	
	selectedBar.Position = UDim2.new(shopBtn.Position.X.Scale, 0, selectedBar.Position.Y.Scale, 0)
end)

invBtn.MouseButton1Click:Connect(function()
	invPage.Visible = true
	shopPage.Visible = false
	
	invBtn.BackgroundColor3 = Color3.fromRGB(75, 75, 77)
	shopBtn.BackgroundColor3 = Color3.fromRGB(47, 47, 49)
	
	selectedBar.Position = UDim2.new(invBtn.Position.X.Scale, 0, selectedBar.Position.Y.Scale, 0)
end)

--Cash displayer
local cash = game.Players.LocalPlayer.leaderstats.Cash
local cashLabel = frame.CashAmount

function shorten(amount)
	local formatted = amount
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if k == 0 then
			break
		end
	end
	return formatted
end

cashLabel.Text = "$" .. shorten(cash.Value)
cash:GetPropertyChangedSignal("Value"):Connect(function()
	cashLabel.Text = "$" .. shorten(cash.Value)
end)

--Set up shop GUI
local crates = game.ReplicatedStorage:WaitForChild("Crates")

local buttons = {}

for i, crate in pairs(crates:GetChildren()) do
	
	local newBtn = script:WaitForChild("CrateButton"):Clone()
	newBtn.CrateName.Text = crate.Name
	newBtn.CrateImage.Image = crate.CrateImage.Texture
	
	newBtn.MouseButton1Click:Connect(function()
		
		shopFrame.CrateName.Text = crate.Name
		shopFrame.CratePrice.Text = "$" .. crate.Price.Value
		
		for x, child in pairs(shopFrame.UnboxableList:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end
		
		local charDisplays = {}
		
		for x, char in pairs(crate.UnboxableCharacters:GetChildren()) do
			
			local charDisplay = script:WaitForChild("CharacterButton"):Clone()
			charDisplay.AutoButtonColor = false
			charDisplay.Active = false
			
			charDisplay.CharacterName.Text = char.Name
			
			local camera = Instance.new("Camera")
			camera.Parent = charDisplay.CharacterImage
			charDisplay.CharacterImage.CurrentCamera = camera

			local characterModel = char:Clone()
			
			characterModel.Parent = charDisplay.CharacterImage

			local hrp = characterModel.HumanoidRootPart
			camera.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 7, hrp.Position)
			
			table.insert(charDisplays, charDisplay)
		end
		
		table.sort(charDisplays, function(a, b)
			return a.CharacterName.Text < b.CharacterName.Text
		end)
		
		for x, charDisplay in pairs(charDisplays) do
			charDisplay.Parent = shopFrame.UnboxableList
		end
		
		shopFrame.Visible = true
	end)
	
	table.insert(buttons, newBtn)
end

table.sort(buttons, function(a, b)
	local aPrice = crates[a.CrateName.Text].Price.Value
	local bPrice = crates[b.CrateName.Text].Price.Value
	return aPrice == bPrice and a.CrateName.Text < b.CrateName.Text or aPrice < bPrice
end)

for i, button in pairs(buttons) do
	button.Parent = shopPage.CratesList
end

--Set up inventory GUI
local ownedChars = game.Players.LocalPlayer.OwnedCharacters
local equippedChar = game.Players.LocalPlayer.EquippedCharacter

function updateGui()
	
	for i, child in pairs(invPage.CharacterList:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	
	local buttons = {}
	
	for i, char in pairs(ownedChars:GetChildren()) do
		
		local newBtn = script.CharacterButton:Clone()
		newBtn.CharacterName.Text = char.Name
		
		local camera = Instance.new("Camera")
		camera.Parent = newBtn.CharacterImage
		newBtn.CharacterImage.CurrentCamera = camera

		local characterModel = game.ReplicatedStorage.Characters[char.Name]:Clone()
		characterModel.Parent = newBtn.CharacterImage

		local hrp = characterModel.HumanoidRootPart
		camera.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 7, hrp.Position)
		
		newBtn.MouseButton1Click:Connect(function()
			
			charFrame.CharacterView:ClearAllChildren()
			
			charFrame.CharacterName.Text = char.Name
			
			local camera = Instance.new("Camera")
			camera.Parent = charFrame.CharacterView
			charFrame.CharacterView.CurrentCamera = camera

			local characterModel = char:Clone()			
			characterModel.Parent = charFrame.CharacterView

			local hrp = characterModel.HumanoidRootPart
			local orientation, size = characterModel:GetBoundingBox()
			
			camera.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * size.Y, hrp.Position)
			
			if equippedChar.Value == char.Name then
				charFrame.EquipButton.Text = "Unequip"
			else
				charFrame.EquipButton.Text = "Equip"
			end
			
			charFrame.Visible = true
		end)
		
		table.insert(buttons, newBtn)
	end
	
	table.sort(buttons, function(a, b)
		return a.CharacterName.Text < b.CharacterName.Text
	end)
	
	for i, button in pairs(buttons) do
		button.Parent = invPage.CharacterList
	end
end
updateGui()
ownedChars.ChildAdded:Connect(updateGui)
ownedChars.ChildRemoved:Connect(updateGui)

--Equip character skin and buy character skin crate buttons
local re = game.ReplicatedStorage:WaitForChild("CharacterRE")

local equipBtn = charFrame.EquipButton
local buyBtn = shopFrame.OpenButton

equipBtn.MouseButton1Click:Connect(function()
	
	local selected = charFrame.CharacterName.Text
	
	local instruction = "Equip Skin"
	if equipBtn.Text == "Unequip" then
		instruction = "Unequip Skin"
		equipBtn.Text = "Equip"
	else
		equipBtn.Text = "Unequip"
	end
	
	re:FireServer(instruction, selected)
end)

buyBtn.MouseButton1Click:Connect(function()
	
	local selected = shopFrame.CrateName.Text
	
	re:FireServer("Open Crate", selected)
end)


--Close unbox GUI when claim is clicked
local unboxFrame = script.Parent:WaitForChild("UnboxFrame")
unboxFrame.Visible = false
unboxFrame.CharactersFrame.ClipsDescendants = true
local slider = unboxFrame.CharactersFrame.CharactersSlider
local claimBtn = unboxFrame.OpenButton
local crateLabel = unboxFrame.CrateName

claimBtn.MouseButton1Click:Connect(function()
	unboxFrame.Visible = false
	openBtn.Visible = true
end)

--Respond to server requests
re.OnClientEvent:Connect(function(instruction, crate, character)
	
	if instruction == "Open Crate" then
		
		slider.Position = UDim2.new(0, 0, 0, 0)
		openBtn.Visible = false
		frame.Visible = false
		
		crateLabel.Text = crate.Name
		claimBtn.Visible = false
		
		local amountOfCharacters = math.random(20, 40)
		local randomPosition = math.random(5, amountOfCharacters - 5)
		
		local chosen = nil
		
		for i = 1, amountOfCharacters do
			local charDisplay = script.CharacterButton:Clone()
			charDisplay.AutoButtonColor = false
			charDisplay.Active = false
			
			local camera = Instance.new("Camera")
			camera.Parent = charDisplay.CharacterImage
			charDisplay.CharacterImage.CurrentCamera = camera
			
			local randomChar = nil
			if i == randomPosition then
				randomChar = character:Clone()
				chosen = charDisplay
			else
				local unboxableChars = crate.UnboxableCharacters:GetChildren()
				randomChar = unboxableChars[math.random(1, #unboxableChars)]:Clone()
			end
			
			randomChar.Parent = charDisplay.CharacterImage

			local hrp = randomChar.HumanoidRootPart
			camera.CFrame = CFrame.new(hrp.Position + hrp.CFrame.LookVector * 7, hrp.Position)
			
			charDisplay.CharacterName.Text = randomChar.Name
			
			charDisplay.Parent = slider
		end
		
		local offset = Random.new():NextNumber(-chosen.AbsoluteSize.X/2, chosen.AbsoluteSize.X/2)
		local goal = (chosen.AbsolutePosition.X + (chosen.AbsoluteSize.X / 2)) - unboxFrame.CharactersFrame.Pointer.AbsolutePosition.X
		local combined = -goal + offset
		local scale = combined / slider.AbsoluteSize.X
		
		slider:TweenPosition(UDim2.new(scale, 0, 0, 0), "Out", "Quint", 5)
		
		unboxFrame.Visible = true
		wait(5)
		claimBtn.Visible = true
	end
end)

--Rotate character currently selected in inventory
while wait() do
	local char = charFrame.CharacterView:FindFirstChildOfClass("Model")
	if char then
		char:SetPrimaryPartCFrame(char.HumanoidRootPart.CFrame * CFrame.Angles(0, 0.01, 0))
	end
end