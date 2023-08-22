local newYear = os.time({year = os.date("%Y", os.time() + (365*24*60*60) - (24*60*60)), month = 1, day = 1})


while wait(1) do
	
	local currentTime = os.time()
	
	local timeDiff = newYear - currentTime
	
	
	local d = math.floor(timeDiff/60/60/24)
	local h = string.format("%0.2i", math.floor((timeDiff - (d*60*60*24))/60/60))
	local m = string.format("%0.2i", math.floor((timeDiff - (d*60*60*24) - (h*60*60))/60))
	local s = string.format("%0.2i", timeDiff - (d*60*60*24) - (h*60*60) - (m*60))
	local formattedTime = d .. ":" .. h .. ":" .. m .. ":" .. s
	
	script.Parent.Clock.ClockGui.TimeToNewYear.Text = timeDiff <= 0 and "00:00:00:00" or formattedTime
	
	if timeDiff <= 0 then

		break
	end
end


for i = 1, 100 do
	
	for x = 1, math.random(2, 7) do
		
		spawn(function()
			
			local firework = script.Firework:Clone()
			firework.Parent = workspace
			
			local cf = CFrame.new(
				Vector3.new(
					math.random(script.Parent.FireworkSpawn.Position.X - script.Parent.FireworkSpawn.Size.X/2, script.Parent.FireworkSpawn.Position.X + script.Parent.FireworkSpawn.Size.X/2), 
					script.Parent.FireworkSpawn.Position.Y + firework.Size.Y/2, 
					math.random(script.Parent.FireworkSpawn.Position.Z - script.Parent.FireworkSpawn.Size.Z/2, script.Parent.FireworkSpawn.Position.Z + script.Parent.FireworkSpawn.Size.Z/2)),
				Vector3.new(
					0,
					math.random(0, 360),
					0))
			
			firework.CFrame = cf
			
			firework.Transparency = 0
			
			firework.Velocity = Vector3.new(0, 200, 0)
			
			firework.Anchored = false
			
			firework.LaunchSound:Play()
			
			repeat wait() until firework.Velocity.Magnitude <= 30
			
			firework.Anchored = true
			firework.Transparency = 1
			
			firework.FireworkParticles.Enabled = true
			
			firework.ExplodeSound:Play()
			
			game:GetService("Debris"):AddItem(firework, 2)
		end)
		
		wait(math.random(10)/10)
	end
	
	wait(math.random(1, 3))
end