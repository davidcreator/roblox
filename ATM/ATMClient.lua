script.Parent.Visible = false


local re = game.ReplicatedStorage:WaitForChild("ATMRemoteEvent")


re.OnClientEvent:Connect(function(deposited)

	script.Parent.DepositedAmount.Text = "Deposited: $" .. deposited
	script.Parent.CashInput.Text = ""

	script.Parent.Visible = true
end)


script.Parent.CloseButton.MouseButton1Click:Connect(function()

	script.Parent.Visible = false
end)


script.Parent.DepositButton.MouseButton1Click:Connect(function()

	re:FireServer(script.Parent.CashInput.Text, "deposit")
	
	script.Parent.Visible = false
end)

script.Parent.WithdrawButton.MouseButton1Click:Connect(function()

	re:FireServer(script.Parent.CashInput.Text, "withdraw")
	
	script.Parent.Visible = false
end)