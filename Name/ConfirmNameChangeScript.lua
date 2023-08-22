local confirm = script.Parent.ConfirmButton

local input = script.Parent.NameInput


local remoteEvent = game.ReplicatedStorage.NameChangeEvent



confirm.MouseButton1Click:Connect(function()
	
	
	local name = input.Text
	
	
	input.Text = ""
	
	
	if string.len(name) < 1 or string.len(name) > 50 then return end
	
	
	remoteEvent:FireServer(name)
end)