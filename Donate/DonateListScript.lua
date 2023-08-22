local list = script.Parent.PlayerList

local amountTextBox = script.Parent.DonateAmount

local template = game.ReplicatedStorage.PlayerNameTemplate


local onDonateEvent = game.ReplicatedStorage.OnDonateClicked


local cooldown = false


while wait() do

	
	game.Players.PlayerRemoving:Connect(function(plrLeft)
		
		if list:FindFirstChild(plrLeft.Name) then list[plrLeft.Name]:Destroy() end
	end)


	for i, plr in pairs(game.Players:GetChildren()) do
		
		if not list:FindFirstChild(plr.Name) and plr ~= game.Players.LocalPlayer then
		
		
			local plrName = template:Clone()
			plrName.Text = plr.Name
			plrName.Name = plr.Name
				
			plrName.Parent = list
		
		end	
	end
		
		
	for i, plrName in pairs(list:GetChildren()) do
		
		
		if plrName.ClassName == "TextButton" then
			
			
			plrName.MouseButton1Click:Connect(function()
				
				
				if not cooldown then
				
					cooldown = true
					
					
					local amount = amountTextBox.Text
					
					
					if amount and tonumber(amount) then
					
						onDonateEvent:FireServer(amount, plrName.Text)	
					end
					
					
					wait(2)
					
					
					cooldown = false
				end
			end)
		end
	end
end