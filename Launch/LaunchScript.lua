local bouncePad = script.Parent

bouncePad.Touched:Connect(function(touch)
	
	
	local char = touch.Parent
	
	
	if game.Players:GetPlayerFromCharacter(char) and char:FindFirstChild("HumanoidRootPart") and not char:FindFirstChild("HumanoidRootPart"):FindFirstChild("BodyVelocity") then
		
		
		local bodyVelocity = Instance.new("BodyVelocity")
		
		bodyVelocity.Velocity = Vector3.new(0, 300, 0)
		bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.P = math.huge
		
		bodyVelocity.Parent = char.HumanoidRootPart
		
		
		wait(0.3)
		
		
		bodyVelocity:Destroy()		
	end
end)