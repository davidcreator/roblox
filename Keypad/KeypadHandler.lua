local door = script.Parent.Parent.Parent.Door


local input = script.Parent.InputtedCode

local buttons = script.Parent.ButtonsBG


local code = "2471"
local currentCode = ""

input.Text = currentCode



for i, button in pairs(buttons:GetChildren()) do
	
	
	button.MouseButton1Click:Connect(function()
		
		if tonumber(button.Name) then
			
			currentCode = currentCode .. button.Name
			input.Text = currentCode
			
			
		elseif button.Name == "Reset" then
			
			currentCode = ""
			input.Text = currentCode
			
			
		elseif button.Name == "Enter" then
			
			
			if currentCode == code then
				
				currentCode = ""
				
				input.Text = "Success"
				door.Transparency = 1
				door.CanCollide = false
				
				wait(5)
				
				input.Text = ""
				door.Transparency = 0
				door.CanCollide = true
				
				
			else
				
				currentCode = ""
				input.Text = "Incorrect code"
			end
		end
	end)
end