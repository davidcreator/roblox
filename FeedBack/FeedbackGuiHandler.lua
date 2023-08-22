local adminIDs = {84182809}


local btn = script.Parent:WaitForChild("Feedback")
local frame = script.Parent:WaitForChild("FeedbackFrame")


btn.MouseButton1Click:Connect(function()
	
	frame.Visible = not frame.Visible
end)


frame:WaitForChild("SendButton").MouseButton1Click:Connect(function()
	
	game.ReplicatedStorage.FeedbackRE:FireServer(frame.FeedbackInput.Text)
end)


game.ReplicatedStorage:WaitForChild("FeedbackFolder").ChildAdded:Connect(function()
	
	for i, child in pairs(frame:WaitForChild("FeedbackScroller"):GetChildren()) do
		
		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end
	
	for i, child in pairs(game.ReplicatedStorage.FeedbackFolder:GetChildren()) do
		
		local feedbackTxt = script:WaitForChild("Feedback"):Clone()
		feedbackTxt.Text = child.Name .. "\n" .. child.Value

		feedbackTxt.Parent = frame.FeedbackScroller
	end
end)


if not table.find(adminIDs, game.Players.LocalPlayer.UserId) then
	
	frame:WaitForChild("FeedbackScroller").Visible = false
end