local txtLabel = script.Parent

local timeTo100 = 5


local isRunning = false
local function countNumEffect(startN, endN, inc, waitTime)
	
	isRunning = true
	
	for i = startN, endN, inc do

		if not isRunning then return end

		txtLabel.Text = i
		wait(waitTime)
	end
	
	txtLabel.Text = endN
	
	isRunning = false
end



local startNum = tonumber(txtLabel.Text)
local endNum = 0

local negator = 0
local increment = 1

if endNum < startNum then negator = -1; increment = -1 end


local waitTime = (negator + ((timeTo100 / 100) * math.abs(endNum - startNum))) / 100


if waitTime < (1/30) then
	local numsPerWait = math.ceil((1/30) / waitTime)
	increment = increment * numsPerWait
end


isRunning = false
countNumEffect(startNum, endNum, increment, waitTime)