local re = game.ReplicatedStorage:WaitForChild("CharacterRE")
local chars = game.ReplicatedStorage:WaitForChild("Characters")


local shop = script.Parent:WaitForChild("Shop")
local inv = script.Parent:WaitForChild("Inventory")


script.Parent.OpenShop.MouseButton1Click:Connect(function()
	shop.Visible = not shop.Visible
end)

script.Parent.OpenInventory.MouseButton1Click:Connect(function()
	inv.Visible = not inv.Visible
end)


shop.CharacterPreview.BuyButton.MouseButton1Click:Connect(function()
	
	re:FireServer(true, shop.CharacterPreview.CharacterName.Text)
end)



for i, char in pairs(chars:GetChildren()) do
	
	local price = char.Price.Value
	local displayChar = char:Clone()
	
	
	local button = script.SelectButton:Clone()
	button.Name = char.Name
	
	local cam = Instance.new("Camera", button.CharacterViewer)
	button.CharacterViewer.CurrentCamera = cam
	
	displayChar.Parent = button.CharacterViewer
	
	cam.CFrame = CFrame.new(displayChar.HumanoidRootPart.Position + Vector3.new(0, -0.5, 5), displayChar.HumanoidRootPart.Position)
	
	button.Parent = shop.CharacterSelector
	
	
	button.MouseButton1Click:Connect(function()

		shop.CharacterPreview.CharacterName.Text = char.Name
		shop.CharacterPreview.BuyButton.Text = "BUY for " .. price

		shop.CharacterPreview.CharacterViewer:ClearAllChildren()

		local viewerCam = Instance.new("Camera", shop.CharacterPreview.CharacterViewer)
		shop.CharacterPreview.CharacterViewer.CurrentCamera = viewerCam

		displayChar:Clone().Parent = shop.CharacterPreview.CharacterViewer

		viewerCam.CFrame = CFrame.new(displayChar.HumanoidRootPart.Position + Vector3.new(0, -0.5, 5), displayChar.HumanoidRootPart.Position)
	end)
end


game.Players.LocalPlayer.OwnedCharacters.ChildAdded:Connect(function(child)

	
	local button = shop.CharacterSelector[child.Name]:Clone()
	button.Parent = inv.CharacterSelector

	button.MouseButton1Click:Connect(function()

		re:FireServer(false, child.Name)
	end)
end)