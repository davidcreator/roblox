local bomb = script.Parent

local timeLabel = bomb.Timer.TimerGui.Time
local buttonClickDetector = bomb.Button.ClickDetector


local timeToExplode = 10

local timerActive = false


buttonClickDetector.MouseClick:Connect(function()
	
	timerActive = not timerActive
	
	if timerActive then
		
		
		repeat	
			wait(1)
			
			timeToExplode = timeToExplode - 1
			
			
			local secs = timeToExplode % 60
			local mins = math.floor(timeToExplode / 60) % 60
			local hours = math.floor(timeToExplode / (60 * 60))
			
			if string.len(secs) < 2 then secs = "0" .. secs end
			if string.len(mins) < 2 then mins = "0" .. mins end
			if string.len(hours) < 2 then hours = "0" .. hours end
			
			
			local formattedTime = hours .. ":" .. mins .. ":" .. secs
			
			
			timeLabel.Text = formattedTime
			
			
		until timeToExplode == 0 or not timerActive
		
		
		if timeToExplode == 0 then
			
			local explosion = Instance.new("Explosion")
			explosion.Position = bomb.Timer.Position
			explosion.Parent = workspace
			
			bomb:Destroy()	
		end
	end
end)