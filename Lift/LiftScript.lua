local ClickDetector = script.Parent.ClickDetector

local Lift = script.Parent.Parent

local Floor1Button = script.Parent.Parent.Floor1Button
local Floor2Button = script.Parent.Parent.Floor2Button
local Floor3Button = script.Parent.Parent.Floor3Button

local Bool = script.Parent.Parent.BoolValue

local DoorL = script.Parent.Parent.Floor1Door.Left
local DoorR = script.Parent.Parent.Floor1Door.Right

local Placeholder = script.Parent.Parent.Placeholder.Value


ClickDetector.MouseClick:Connect(function()


	
	if math.floor(Lift.Position.Y) == 35 and Bool.Value == true then
		
		Bool.Value = false
		
		for i = 1,100 do
			
			Lift.CFrame = CFrame.new(Lift.Position.X, Lift.Position.Y-0.29922, Lift.Position.Z)
			
			Floor1Button.CFrame = CFrame.new(Floor1Button.Position.X, Floor1Button.Position.Y-0.29922, Floor1Button.Position.Z)
			Floor2Button.CFrame = CFrame.new(Floor2Button.Position.X, Floor2Button.Position.Y-0.29922, Floor1Button.Position.Z)
			Floor3Button.CFrame = CFrame.new(Floor3Button.Position.X, Floor3Button.Position.Y-0.29922, Floor3Button.Position.Z)
			
			wait(0.001)
		end
		wait(0.4)
		
		Lift.Ding:Play()
		
		Bool.Value = true	
		
		while Bool.Value == true do
			
			wait(0.1)
			
			while Placeholder == true do 
			
				for x = 1, 20 do
					
					DoorL.Size = Vector3.new(DoorL.Size.X, DoorL.Size.Y, DoorL.Size.Z - 0.2195)
					DoorL.CFrame = DoorL.CFrame*CFrame.new(0, 0, 0.10975)
					
					DoorR.Size = Vector3.new(DoorR.Size.X, DoorR.Size.Y, DoorR.Size.Z - 0.2195)
					DoorR.CFrame = DoorR.CFrame*CFrame.new(0, 0, -0.10975)
					wait()
					
					if x == 20 then		
						Placeholder = false
					end
				end
			end
		end
		
		
		for x = 1, 20 do

			DoorL.Size = Vector3.new(DoorL.Size.X, DoorL.Size.Y, DoorL.Size.Z + 0.2195)
			DoorL.CFrame = DoorL.CFrame*CFrame.new(0, 0, -0.10975)
			
			DoorR.Size = Vector3.new(DoorR.Size.X, DoorR.Size.Y, DoorR.Size.Z + 0.2195)
			DoorR.CFrame = DoorR.CFrame*CFrame.new(0, 0, 0.10975)
			wait()
		end
		Placeholder = true			
	end
	
	
	
	if math.floor(Lift.Position.Y) == 20 and Bool.Value == true then
		
		Bool.Value = false
		
		for i = 1,50 do
			
			Lift.CFrame = CFrame.new(Lift.Position.X, Lift.Position.Y-0.29644, Lift.Position.Z)
			
			Floor1Button.CFrame = CFrame.new(Floor1Button.Position.X, Floor1Button.Position.Y-0.29644, Floor1Button.Position.Z)
			Floor2Button.CFrame = CFrame.new(Floor2Button.Position.X, Floor2Button.Position.Y-0.29644, Floor2Button.Position.Z)
			Floor3Button.CFrame = CFrame.new(Floor3Button.Position.X, Floor3Button.Position.Y-0.29644, Floor3Button.Position.Z)
			
			wait(0.001)
		end
		
		wait(0.4)
		
		Lift.Ding:Play()
		
		Bool.Value = true
		
		
		while Bool.Value == true do
			
			wait()
			
			while Placeholder == true do 
				
			
				for x = 1, 20 do
					
					DoorL.Size = Vector3.new(DoorL.Size.X, DoorL.Size.Y, DoorL.Size.Z - 0.2195)
					DoorL.CFrame = DoorL.CFrame*CFrame.new(0, 0, 0.10975)
					
					DoorR.Size = Vector3.new(DoorR.Size.X, DoorR.Size.Y, DoorR.Size.Z - 0.2195)
					DoorR.CFrame = DoorR.CFrame*CFrame.new(0, 0, -0.10975)
					wait()
					
					if x == 20 then		
						Placeholder = false
					end
				end
			end
		end
		
		for x = 1, 20 do

			DoorL.Size = Vector3.new(DoorL.Size.X, DoorL.Size.Y, DoorL.Size.Z + 0.2195)
			DoorL.CFrame = DoorL.CFrame*CFrame.new(0, 0, -0.10975)
			
			DoorR.Size = Vector3.new(DoorR.Size.X, DoorR.Size.Y, DoorR.Size.Z + 0.2195)
			DoorR.CFrame = DoorR.CFrame*CFrame.new(0, 0, 0.10975)
			wait()
		end
		Placeholder = true
	end
end)