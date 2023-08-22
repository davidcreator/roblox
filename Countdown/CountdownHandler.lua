local countdownGui = script.Parent
local countdownText = countdownGui:WaitForChild("CountdownText")


local day = os.time({year = 2020, month = 8, day = 19, hour = 11, min = 16, sec = 0})


while wait() do
	
	local secondsBetween = os.difftime(day, os.time())

	local seconds = secondsBetween % 60
	local minutes = math.floor(secondsBetween % (60*60) / 60)
	local hours = math.floor(secondsBetween % (60*60*24) / (60*60))
	local days = math.floor(secondsBetween % (60*60*24*30) / (60*60*24))
	
	local textString = days .. "d:" .. hours .. "h:" .. minutes .. "m:" .. seconds .. "s"
	countdownText.Text = textString
	
	if secondsBetween <= 0 then break end
end