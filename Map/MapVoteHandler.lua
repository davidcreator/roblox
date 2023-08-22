local pads = script.Parent.MapVotePads

local mapBoards = script.Parent.MapBoards

local votingStatus = script.Parent.VotingStatus


local canVote = false


local maps = 
{
	Map1 = 1515986593,
	Map2 = 177925016,
	Map3 = 956900746,
	Map4 = 47346541,
	Map5 = 1389476778,
	Map6 = 873393577, 
}


while true do
	
	pads.MapVote1.Votes:ClearAllChildren()
	pads.MapVote2.Votes:ClearAllChildren()
	pads.MapVote3.Votes:ClearAllChildren()
	
	pads.MapVote1.VotedGui.VotedAmount.Text = ""
	pads.MapVote2.VotedGui.VotedAmount.Text = ""
	pads.MapVote3.VotedGui.VotedAmount.Text = ""
	
	mapBoards.Map1.MapGui.MapImage.ImageTransparency = 1
	mapBoards.Map2.MapGui.MapImage.ImageTransparency = 1
	mapBoards.Map3.MapGui.MapImage.ImageTransparency = 1
	
	mapBoards.Map1.MapGui.MapName.Text = ""
	mapBoards.Map2.MapGui.MapName.Text = ""
	mapBoards.Map3.MapGui.MapName.Text = ""
	
	for i = 5, 0, -1 do
		
		votingStatus.StatusGui.Status.Text = "Voting will begin in " .. i .. " seconds"
		
		wait(1)
	end
	
	
	votingStatus.StatusGui.Status.Text = "Vote for the map"
	
	
	local keysTable = {}
	for key, value in pairs(maps) do
	    table.insert(keysTable, key)
	end
	
	local randomKey1 = keysTable[math.random(#keysTable)]
	local mapChosen1 = maps[randomKey1]
	
	local randomKey2, mapChosen2
	repeat
		randomKey2 = keysTable[math.random(#keysTable)]
		mapChosen2 = maps[randomKey2]
	until mapChosen2 ~= mapChosen1
	
	local randomKey3, mapChosen3
	repeat
		randomKey3 = keysTable[math.random(#keysTable)]
		mapChosen3 = maps[randomKey3]
	until mapChosen3 ~= mapChosen1 and mapChosen3 ~= mapChosen2
	
	
	mapBoards.Map1.MapGui.MapImage.ImageTransparency = 0
	mapBoards.Map2.MapGui.MapImage.ImageTransparency = 0
	mapBoards.Map3.MapGui.MapImage.ImageTransparency = 0
	
	mapBoards.Map1.MapGui.MapImage.Image = "rbxassetid://" .. mapChosen1
	mapBoards.Map2.MapGui.MapImage.Image = "rbxassetid://" .. mapChosen2
	mapBoards.Map3.MapGui.MapImage.Image = "rbxassetid://" .. mapChosen3
	
	mapBoards.Map1.MapGui.MapName.Text = randomKey1
	mapBoards.Map2.MapGui.MapName.Text = randomKey2
	mapBoards.Map3.MapGui.MapName.Text = randomKey3
	
	
	pads.MapVote1.VotedGui.VotedAmount.Text = "0"
	pads.MapVote2.VotedGui.VotedAmount.Text = "0"
	pads.MapVote3.VotedGui.VotedAmount.Text = "0"
	
	canVote = true
	
	
	local function onPadTouched(touch, pad)
		if not canVote then return end
		if game.Players:GetPlayerFromCharacter(touch.Parent) then
			
			if pads.MapVote1.Votes:FindFirstChild(game.Players:GetPlayerFromCharacter(touch.Parent).Name) then 
				pads.MapVote1.Votes[game.Players:GetPlayerFromCharacter(touch.Parent).Name]:Destroy()
			end
			if pads.MapVote2.Votes:FindFirstChild(game.Players:GetPlayerFromCharacter(touch.Parent).Name) then 
				pads.MapVote2.Votes[game.Players:GetPlayerFromCharacter(touch.Parent).Name]:Destroy()
			end
			if pads.MapVote3.Votes:FindFirstChild(game.Players:GetPlayerFromCharacter(touch.Parent).Name) then 
				pads.MapVote3.Votes[game.Players:GetPlayerFromCharacter(touch.Parent).Name]:Destroy()
			end
		
			local touchVal = Instance.new("StringValue")
			touchVal.Name = game.Players:GetPlayerFromCharacter(touch.Parent).Name
			touchVal.Parent = pad.Votes
			
			pads.MapVote1.VotedGui.VotedAmount.Text = #pads.MapVote1.Votes:GetChildren()
			pads.MapVote2.VotedGui.VotedAmount.Text = #pads.MapVote2.Votes:GetChildren()
			pads.MapVote3.VotedGui.VotedAmount.Text = #pads.MapVote3.Votes:GetChildren()
		end
	end
	
	pads.MapVote1.Touched:Connect(function(touch)
		onPadTouched(touch, pads.MapVote1)
	end)
	pads.MapVote2.Touched:Connect(function(touch)
		onPadTouched(touch, pads.MapVote2)
	end)
	pads.MapVote3.Touched:Connect(function(touch)
		onPadTouched(touch, pads.MapVote3)
	end)
	
	wait(10)
	
	canVote = false
	
	
	local highestVoted
	
	for i, pad in pairs(pads:GetChildren()) do
		
		if not highestVoted then highestVoted = pad end
		
		if #pad.Votes:GetChildren() > #highestVoted.Votes:GetChildren() then 
			
			highestVoted = pad
			
		elseif #pad.Votes:GetChildren() == #highestVoted.Votes:GetChildren() then 
			
			local mapsToChoose = {pad, highestVoted}
			highestVoted = mapsToChoose[math.random(#mapsToChoose)]
		end
	end
	
	local mapName = mapBoards["Map" .. string.gsub(highestVoted.Name, "MapVote", "")].MapGui.MapName.Text
	votingStatus.StatusGui.Status.Text = mapName .. " has been voted"
	
	wait(5)
end