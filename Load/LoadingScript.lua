local BarProgress = 0


while wait() do
	
	BarProgress = BarProgress + 0.5
	
	script.Parent.Size = UDim2.new(BarProgress/100, 0, 0.1, 0)
	
	script.Parent.Parent.LoadingText.Text = ("Loading... "..math.floor(BarProgress*2).."%")
	
	if BarProgress == 50 then
		
		game.Workspace.Ding:Play()
		
		wait(1)
		
		while wait() do
			script.Parent.BackgroundTransparency = script.Parent.BackgroundTransparency + 0.08
			script.Parent.Parent.BarBackground.BackgroundTransparency = script.Parent.Parent.BarBackground.BackgroundTransparency + 0.08
			script.Parent.Parent.LoadingText.TextTransparency = script.Parent.Parent.LoadingText.TextTransparency + 0.08
			script.Parent.Parent.BackgroundTransparency = script.Parent.Parent.BackgroundTransparency + 0.072
			
			if script.Parent.BackgroundTransparency >= 1 then
				
				script.Parent.Parent.Parent:Destroy()
				break	
			end		
		end
	end
end