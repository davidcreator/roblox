local bar = script.Parent.Bar

local healthBar = script.Parent.Health


local plr = game.Players.LocalPlayer

local char = plr.Character or plr.CharacterAdded:Wait()


local colorGreen = Color3.fromRGB(0, 255, 17)
local colorRed = Color3.fromRGB(255, 0, 0)


while wait() do
	
	if not char:FindFirstChild("Humanoid") then return end
	
	local health = char.Humanoid.Health
	
	local maxHealth = char.Humanoid.MaxHealth
	
	
	healthBar.Size = UDim2.new(bar.Size.X.Scale / maxHealth * health, 0, healthBar.Size.Y.Scale, 0)
	
	healthBar.ImageColor3 = colorRed:lerp(colorGreen, health / maxHealth)
	
end