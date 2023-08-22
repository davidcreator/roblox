local clipping = script.Parent:WaitForChild("BarClipping")
clipping.ClipsDescendants = true

local expTxt = script.Parent:WaitForChild("Experience")
local levelTxt = script.Parent:WaitForChild("Level")

local expVal = game.Players.LocalPlayer:WaitForChild("Stats"):WaitForChild("Experience")
local levelVal = game.Players.LocalPlayer.Stats:WaitForChild("Level")


local previousExp = expVal.Value


function updateGui()
	
	local neededExp = math.floor(levelVal.Value ^ 1.5 + 0.5) * 500
	
	local previousLevelExp = math.floor((levelVal.Value - 1) ^ 1.5 + 0.5) * 500
	
	local expDiff = neededExp - previousLevelExp
	
	local currentExp = expVal.Value - previousLevelExp
	

	
	local x = currentExp / expDiff
	
	clipping.Size = UDim2.new(x, 0, 1, 0)
	clipping.Bar.Size = UDim2.new(1 / x, 0, 1, 0)
			
	
	expTxt.Text = currentExp .. "/" .. expDiff
	levelTxt.Text = "Level " .. levelVal.Value
	
	
	if expVal.Value == neededExp then
		
		local nextExpNeeded = (math.floor((levelVal.Value + 1) ^ 1.5 + 0.5) * 500) - neededExp
		
		expTxt.Text = "0/" .. nextExpNeeded
		
		levelTxt.Text = "Level " .. levelVal.Value + 1
		
		clipping.Size = UDim2.new(0, 0, 1, 0)
	end
	
	
	previousExp = expVal.Value
end


updateGui()

expVal:GetPropertyChangedSignal("Value"):Connect(updateGui)