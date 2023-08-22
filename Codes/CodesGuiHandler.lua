local btn = script.Parent.CodesButton

local frame = script.Parent.CodesFrame
frame.Visible = false


btn.MouseButton1Click:Connect(function()
	
	frame.Visible = not frame.Visible
end)


local lastEntered = ""


frame.RedeemButton.MouseButton1Click:Connect(function()
	
	game.ReplicatedStorage.CodeEntered:FireServer(frame.InputCode.Text)
	
	lastEntered = frame.InputCode.Text
end)


game.ReplicatedStorage.CodeEntered.OnClientEvent:Connect(function(msg)
	
	
	if frame.InputCode.Text == lastEntered then 
		
		frame.InputCode.Text = msg
	end
end)