game.Players.PlayerAdded:Connect(function(plr)
	
	
	plr.CharacterAdded:Connect(function(char)
		
		
		local startPos
		
		
		local humanoid = char:WaitForChild("Humanoid")	
		
		
		humanoid.StateChanged:Connect(function(oldState, newState)
			
			
			if newState == Enum.HumanoidStateType.Freefall then
					
				startPos = char:WaitForChild("HumanoidRootPart").Position.Y
				
				
			elseif newState == Enum.HumanoidStateType.Landed then
				
				
				if not startPos then return end
					
				
				local landPos = char:WaitForChild("HumanoidRootPart").Position.Y
				
				
				if startPos < landPos then return end
								
				
				local distanceFallen = (startPos - landPos)	
				
				
				humanoid:TakeDamage(distanceFallen)
			end
		end)
	end)	
end)