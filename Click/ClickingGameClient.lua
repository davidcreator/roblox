local coinBtn = script.Parent:WaitForChild("CoinButton")
local upgBtn = script.Parent:WaitForChild("UpgradeButton")
local cashTxt = script.Parent:WaitForChild("CashText")

local statsFolder = game.Players.LocalPlayer:WaitForChild("Stats")

local re = game.ReplicatedStorage:WaitForChild("ClickedRE")


coinBtn.MouseButton1Click:Connect(function()
	
	re:FireServer("Click")
end)

upgBtn.MouseButton1Click:Connect(function()
	
	re:FireServer("Upgrade")
end)


function updateText()
	
	upgBtn.Text = "Upgrade (" .. (statsFolder.Upgrades.Value + 1) ^ 4 .. ")"
	cashTxt.Text = "Cash: " .. statsFolder.Cash.Value
end

updateText()

statsFolder.Upgrades.Changed:Connect(updateText)
statsFolder.Cash.Changed:Connect(updateText)