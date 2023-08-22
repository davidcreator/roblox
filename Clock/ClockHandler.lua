local secsHand = script.Parent.SecondsHand

local minsHand = script.Parent.MinutesHand

local hoursHand = script.Parent.HoursHand


local centre = script.Parent.Centre         
      
     

while wait() do
	
	
	local t = tick()
	
	
	local secs = math.floor(t % 60)
           
	local mins = math.floor((t / 60)% 60)
           
	local hours = math.floor((t / 3600)% 24)
	
	
	local secsAngle = -(secs * 6)
	
	local minsAngle = -(mins * 6)
	
	local hoursAngle = -(hours * 30)


	secsHand.CFrame = CFrame.new(centre.Position) * CFrame.Angles(math.rad(secsAngle), 0, 0) * CFrame.new(0, secsHand.Size.Y / 2, 0)
	
	minsHand.CFrame = CFrame.new(centre.Position) * CFrame.Angles(math.rad(minsAngle), 0, 0) * CFrame.new(0, minsHand.Size.Y / 2, 0)
	
	hoursHand.CFrame = CFrame.new(centre.Position) * CFrame.Angles(math.rad(hoursAngle), 0, 0) * CFrame.new(0, hoursHand.Size.Y / 2, 0)
end