local healthPerDrop = 10
local dropLifetime = 20
local dropSizeMin, dropSizeMax = 0.1, 2

local blood = script:WaitForChild("Blood")


local tweenService = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)


game.Players.PlayerAdded:Connect(function(plr)
	
	plr.CharacterAdded:Connect(function(char)
		
		local humanoid = char:WaitForChild("Humanoid")
		
		
		local previousHealth = humanoid.Health
		
		humanoid.HealthChanged:Connect(function(newHealth)
			
			
			local healthDifference = previousHealth - newHealth
			
			previousHealth = newHealth
			
			if healthDifference < 0 then return end
			
			
			local numOfDrops = math.floor(healthDifference / healthPerDrop)
			
			
			local dropsFolder = Instance.new("Folder", workspace)
			
			for i = 1, numOfDrops do
				
				local dropSize = math.random(dropSizeMin * 10, dropSizeMax * 10) / 10
				
				local bloodDrop = blood:Clone()
				bloodDrop.Size = Vector3.new(0, 0, 0)
				
				
				local xPos = char.HumanoidRootPart.Position.X + math.random(-30, 30) / 10
				local yPos = char.LeftFoot.Position.Y - char.LeftFoot.Size.Y/2 + 0.05
				local zPos = char.HumanoidRootPart.Position.Z + math.random(-30, 30) / 10
				
				bloodDrop.Position = Vector3.new(xPos, yPos, zPos)
				
				bloodDrop.Parent = dropsFolder
				
				
				tweenService:Create(bloodDrop, tweenInfo, {Size = Vector3.new(0.05, dropSize, dropSize)}):Play()
			end
			
			wait(dropLifetime)
			dropsFolder:Destroy()
		end)
	end)
end)