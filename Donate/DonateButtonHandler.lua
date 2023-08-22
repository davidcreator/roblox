local donateList = workspace:WaitForChild("DonationBoard").DonatePart.DonateGui.DonateList


function handleDonateButton(button)
	
	button.MouseButton1Click:Connect(function()
		
		game.ReplicatedStorage.DonateRE:FireServer(button)
	end)
end


for i, child in pairs(donateList:GetChildren()) do
	
	if child:IsA("TextButton") then
		
		handleDonateButton(child)
	end
end


donateList.ChildAdded:Connect(handleDonateButton)