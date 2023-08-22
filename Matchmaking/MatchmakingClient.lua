local button = script.Parent:WaitForChild("QueueButton")


button.MouseButton1Click:Connect(function()
	
	button.QueueText.Text = button.QueueText.Text == "QUEUE" and "IN QUEUE" or "QUEUE"
	
	game.ReplicatedStorage:WaitForChild("QueueRE"):FireServer(button.QueueText.Text)
end)