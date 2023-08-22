local boombox = script.Parent
local re = boombox:WaitForChild("BoomboxRE")


local plr = game.Players.LocalPlayer

local clonedGui


boombox.Equipped:Connect(function()
	
	clonedGui = game.ReplicatedStorage.BoomboxGui:Clone()
	clonedGui.Parent = plr.PlayerGui
	
	clonedGui.MusicIDInput.FocusLost:Connect(function(enterPressed)
		
		if not enterPressed then return end
		
		local inputtedID = clonedGui.MusicIDInput.Text
		clonedGui.MusicIDInput.Text = ""
		
		re:FireServer(inputtedID)
	end)
end)

boombox.Unequipped:Connect(function()
	
	clonedGui:Destroy()
end)


re.OnClientEvent:Connect(function(musicList)
	
	repeat wait() until clonedGui
	
	if not musicList then return end
	
	clonedGui.ListOfMusic:ClearAllChildren()
	
	local uiGridLayout = Instance.new("UIGridLayout")
	uiGridLayout.FillDirection = Enum.FillDirection.Vertical
	uiGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiGridLayout.CellSize = UDim2.new(1, 0, 0.072, 0)
	
	uiGridLayout.Parent = clonedGui.ListOfMusic
	
	
	for musicId, musicName in pairs(musicList) do
		
		local musicInfoClone = script.MusicInfo:Clone()
		musicInfoClone.MusicName.Text = musicName
		
		musicInfoClone.Parent = clonedGui.ListOfMusic
		
		musicInfoClone.PlayButton.MouseButton1Click:Connect(function()
			
			re:FireServer(musicId)
		end)
	end
end)